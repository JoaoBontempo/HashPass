import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/security/cryptography.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/snackbar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:hashpass/widgets/data/textfield.dart';

class AuthAppKey extends StatefulWidget {
  static void auth({
    bool lastKeyLabel = false,
    bool onlyText = false,
    required Function(String) onValidate,
  }) {
    Get.dialog(
      AuthAppKey(
        onValidate: (key) => onValidate(key),
        onlyText: onlyText,
        lastKeyLabel: lastKeyLabel,
      ),
    );
  }

  const AuthAppKey({
    Key? key,
    this.onlyText = false,
    this.lastKeyLabel = false,
    this.onInvalid,
    required this.onValidate,
  }) : super(key: key);
  final Function(String) onValidate;
  final Function? onInvalid;
  final bool onlyText;
  final bool lastKeyLabel;
  @override
  _AuthAppKeyState createState() => _AuthAppKeyState();
}

class _AuthAppKeyState extends HashPassState<AuthAppKey> {
  final passwordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isInvalidKey = false;
  int attempts = 3;

  @override
  void initState() {
    final LocalAuthentication auth = LocalAuthentication();
    if (Configuration.instance.isBiometria && !widget.onlyText) {
      try {
        auth.authenticate(
          authMessages: [
            AndroidAuthMessages(
              biometricHint: appLanguage.verifyIdentity,
              signInTitle: appLanguage.authNeeded,
            ),
          ],
          localizedReason: appLanguage.unlockNeeded,
          options: const AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
          ),
        ).then(
          (isValidBiometric) {
            Get.back();
            if (isValidBiometric) {
              HashCrypt.isValidGeneralKey(null).then((isValidKey) {
                if (isValidKey) {
                  widget.onValidate(HashCrypt.getGeneralKeyBase());
                }
              });
            } else if (widget.onInvalid != null) {
              widget.onInvalid!();
            }
          },
        );
      } on Exception catch (error) {
        HashPassSnackBar.show(
          message: appLanguage.errorOcurred + error.toString(),
          type: SnackBarType.ERROR,
        );
      }
    }
    super.initState();
  }

  void validateTextKey() async {
    passwordEC.text = passwordEC.text.trim();
    if (Util.validateForm(formKey)) {
      bool isValidKey = await HashCrypt.isValidGeneralKey(passwordEC.text);
      if (isValidKey) {
        Get.back();
        widget.onValidate(passwordEC.text);
      } else {
        setState(() {
          attempts--;
          if (attempts == 0) {
            exit(0);
          }
          isInvalidKey = !isValidKey;
        });
      }
    }
  }

  @override
  Widget localeBuild(context, language) =>
      Configuration.instance.isBiometria && !widget.onlyText
          ? Container()
          : AlertDialog(
              title: HashPassLabel(
                text: language.authNeeded,
                fontWeight: FontWeight.bold,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: AppTextField(
                      onKeyboardAction: (text) => validateTextKey(),
                      icon: Icons.lock_outlined,
                      maxLength: 50,
                      label: widget.lastKeyLabel
                          ? language.setLastAppKey
                          : language.appKey,
                      padding: 10,
                      controller: passwordEC,
                      validator:
                          HashPassValidator.empty(language.emptyPassword),
                    ),
                  ),
                  Visibility(
                    visible: isInvalidKey,
                    child: Text(
                      "${language.keyAttempts} $attempts.",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text(language.validate),
                  onPressed: () => validateTextKey(),
                ),
              ],
            );
}
