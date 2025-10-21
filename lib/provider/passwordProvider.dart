import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/dto/leakPassDTO.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/hashPassProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/security/cryptography.dart';
import 'package:hashpass/util/security/hash.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:hashpass/widgets/interface/snackbar.dart';

abstract class PasswordProvider extends HashPassProvider {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final credentialController = TextEditingController();
  bool enablePasswordDelete = true;
  bool isDeletingPassword = false;
  bool hidePassword = true;
  bool _disposed = false;
  late PasswordLeakDTO leakInformation =
      PasswordLeakDTO(leakCount: password.leakCount);
  Password password;
  late bool isVerifiedPassword = password.leakCount == 0;
  late bool passwordHasBeenVerified = password.leakCount != -1;

  PasswordProvider(this.password);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @protected
  void verifyPasswordLeak({bool savePassword = false}) {
    HashCrypt.verifyPassowordLeak(passwordController.text).then(
      (response) {
        password.leakCount = response.leakCount;
        leakInformation = response;
        passwordHasBeenVerified = true;
        isVerifiedPassword = response.leakCount == 0;

        if (savePassword) password.save();
        _notify();
      },
    );
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  void handlePasswordTextFieldChanges(String text) {
    enablePasswordDelete = !(text.isEmpty || text.trim() == '');
    if (!enablePasswordDelete || text.length < 4) {
      isDeletingPassword = true;
      passwordHasBeenVerified = false;
      _notify();
      return;
    } else {
      isDeletingPassword = false;
    }

    if (Configuration.instance.updatePassVerify) verifyPasswordLeak();
  }

  void setAlgorithm(HashAlgorithm algorithm) {
    password.hashAlgorithm = algorithm;
    _notify();
  }

  void setAdvanced(bool isAdvanced) {
    password.isAdvanced = isAdvanced;
    _notify();
  }

  void setUseCriptography(bool useCriptography) {
    password.useCriptography = useCriptography;
    _notify();
  }

  void changePasswordVisibility() {
    hidePassword = !hidePassword;
    _notify();
  }

  void deletePassword(UserPasswordsProvider userPasswordsProvider) {
    HashPassMessage.show(
      title: language.confirmDelete,
      message: language.confirmDeleteMessage,
      type: MessageType.YESNO,
    ).then((action) {
      if (action == MessageResponse.YES) {
        AuthAppKey.auth(
          onValidate: (key) async {
            if (await password.delete()) {
              userPasswordsProvider.removePassword(password);
              HashPassSnackBar.show(message: language.deleteSuccess);
            } else {
              HashPassSnackBar.show(
                message: language.deleteError,
                type: SnackBarType.ERROR,
              );
            }
          },
        );
      }
    });
  }

  void savePassword(BuildContext context) async {
    if (await validatePassword(true)) {
      AuthAppKey.auth(
        onValidate: (key) async {
          await password.save();
          _notify();
        },
      );
    }
  }

  Future<bool> validatePassword(bool showConfirmationMessage) async {
    Get.focusScope!.unfocus();
    if (Util.validateForm(formKey)) {
      if (Configuration.instance.updatePassVerify && !isVerifiedPassword) {
        MessageResponse userAction = await HashPassMessage.show(
          message: leakInformation.status == LeakStatus.LEAKED
              ? language.confirmSaveLeakedPassword
              : language.confirmSaveNotVerifiedPassword,
          title: leakInformation.status == LeakStatus.LEAKED
              ? language.leakedPassword
              : language.notVerifiedPassword,
          type: MessageType.YESNO,
        );

        return userAction == MessageResponse.YES;
      }

      if (!password.isNew && showConfirmationMessage) {
        MessageResponse userAction = await HashPassMessage.show(
          title: language.confirm,
          message: language.confirmSavePassword,
          type: MessageType.YESNO,
        );

        return userAction == MessageResponse.YES;
      }

      return true;
    } else {
      return Future(() => false);
    }
  }
}
