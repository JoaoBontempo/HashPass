import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hashpass/dto/desktop/desktopCopyPasswordDTO.dart';
import 'package:hashpass/dto/desktop/desktopOperationDTO.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/hashPassDesktopProvider.dart';
import 'package:hashpass/provider/passwordProvider.dart';
import 'package:hashpass/provider/passwordRegisterProvider.dart';
import 'package:hashpass/provider/passwordVisualizationProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/security/cryptography.dart';
import 'package:hashpass/view/passwordRegister.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:hashpass/widgets/interface/snackbar.dart';
import 'package:hashpass/widgets/passwordVisualizationModal.dart';
import 'package:provider/provider.dart';

class PasswordCardProvider extends PasswordProvider {
  String lastText = '';
  final bool isHelpExample;

  PasswordCardProvider(
    super.password, {
    this.isHelpExample = false,
  }) {
    password.setTrueBasePassword(password.basePassword);
    credentialController.text = password.credential;
    passwordController.text = password.getTrueBasePassword();

    if (password.leakCount == -1) {
      verifyPasswordLeak(savePassword: true);
    }
  }

  void copyPassword() {
    getBasePassword(
      (basePassword) {
        if (Configuration.instance.useDesktop) {
          HashPassDesktopProvider.instance.sendMessage(
            DesktopOperationDTO<DesktopCopyPasswordDTO>(
              message: 'Password copy',
              success: true,
              data: DesktopCopyPasswordDTO(
                  title: password.title, password: basePassword),
              operation: DesktopOperation.COPY,
            ),
          );
        }

        Clipboard.setData(ClipboardData(text: basePassword)).then(
          (_) => HashPassSnackBar.show(
            message: language.passwordCopied,
            duration: const Duration(milliseconds: 2500),
          ),
        );
      },
    );
  }

  void toUpdatePassword(UserPasswordsProvider userPasswordsProvider) {
    getBasePassword(
      (trueBasePassword) {
        password.setTrueBasePassword(trueBasePassword);
        Get.to(
          ChangeNotifierProvider<PasswordRegisterProvider>(
              create: (context) =>
                  PasswordRegisterProvider(password, userPasswordsProvider),
              builder: (context, widget) => const NewPasswordPage()),
        );
      },
      getRealBase: true,
    );
  }

  void getBasePassword(
    Function(String) onGet, {
    bool getRealBase = false,
  }) async {
    AuthAppKey.auth(
      onValidate: (key) async {
        if (password.useCriptography && !getRealBase) {
          onGet(
            await HashCrypt.applyAlgorithms(
              password.hashAlgorithm,
              password.basePassword,
              password.isAdvanced,
              key,
            ),
          );
        } else {
          onGet(
            await HashCrypt.decipherString(password.basePassword, key) ??
                language.passwordRecoverError,
          );
        }
      },
    );
  }

  void showPassword() {
    AuthAppKey.auth(
      onValidate: (key) {
        Get.dialog(
          ChangeNotifierProvider(
            create: (context) => PasswordVisualizationProvider(
                password: password, appKey: key, context: context),
            builder: (context, _) => const PasswordVisualizationModal(),
          ),
        );
      },
    );
  }

  @override
  void savePassword(BuildContext context) {
    AuthAppKey.auth(
      onValidate: (key) async {
        await _setPasswordValues(key);
        await password.save();
        HashPassSnackBar.show(message: language.passwordSuccessUpdate);
        notifyListeners();
      },
    );
  }

  Future<void> _setPasswordValues(String appKey) async {
    password.credential = credentialController.text;
    if (password.basePassword != passwordController.text) {
      String newPassword =
          await HashCrypt.cipherString(passwordController.text, appKey);
      password.basePassword = newPassword;
      passwordController.text = newPassword;
    }
  }

  void restorePasswordHistory() {
    enablePasswordDelete = true;
    passwordController.text = lastText;
    passwordHasBeenVerified = (lastText.length > 4 || lastText.isNotEmpty);
    notifyListeners();
  }

  void deletePasswordFromTextField() {
    lastText = passwordController.text;
    enablePasswordDelete = false;
    passwordController.text = "";
    passwordHasBeenVerified = false;
    notifyListeners();
  }

  void updatePassword(BuildContext context) async {
    if (await validatePassword(true)) {
      savePassword(context);
    }
  }

  bool get showSecurityUpdateIcon =>
      Configuration.instance.updatePassVerify &&
      passwordController.text.trim().length > 4;
}
