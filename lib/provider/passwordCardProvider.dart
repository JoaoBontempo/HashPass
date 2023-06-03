import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/passwordProvider.dart';
import 'package:hashpass/provider/passwordRegisterProvider.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/view/passwordRegister.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:hashpass/widgets/visualizarSenha.dart';
import 'package:provider/provider.dart';

class PasswordCardProvider extends PasswordProvider {
  String lastText = '';
  final bool isHelpExample;

  PasswordCardProvider(
    super.password, {
    this.isHelpExample = false,
  }) {
    credentialController.text = password.credential;
    passwordController.text = password.basePassword;

    if (password.leakCount == -1) {
      verifyPasswordLeak(savePassword: true);
    }
  }

  void copyPassword(VoidCallback onCopy) {
    getBasePassword(
      (basePassword) => {
        Clipboard.setData(ClipboardData(text: basePassword))
            .then((_) => onCopy()),
      },
    );
  }

  void toUpdatePassword(Function(Password, int) onUpdate) {
    getBasePassword(
      (basePassword) {
        password.basePassword = basePassword;
        Get.to(
          ChangeNotifierProvider<PasswordRegisterProvider>(
              create: (context) => PasswordRegisterProvider(password),
              builder: (context, widget) {
                return NewPasswordPage(
                  password: password,
                  basePassword: basePassword,
                  onUpdate: (_password, code) {
                    Get.back();
                    notifyListeners();
                  },
                );
              }),
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
          onGet(await HashCrypt.applyAlgorithms(
            password.hashAlgorithm,
            password.basePassword,
            password.isAdvanced,
            key,
          ));
        } else {
          onGet(await HashCrypt.decipherString(password.basePassword, key) ??
              "Ocorreu um erro ao recuperar sua senha");
        }
      },
    );
  }

  void showPassword() {
    AuthAppKey.auth(
      onValidate: (key) {
        Get.dialog(
          VisualizacaoSenhaModal(
            chaveGeral: key,
            senha: password,
            copyIconColor: Get.theme.hintColor,
          ),
        );
      },
    );
  }

  @override
  void savePassword(BuildContext context) {
    AuthAppKey.auth(
      onValidate: (key) async {
        _setPasswordValues(key);
        await password.save();
        passwordHasBeenVerified = false;
        notifyListeners();
      },
    );
  }

  void _setPasswordValues(String appKey) async {
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
    if (await validatePassword()) {
      savePassword(context);
    }
  }
}
