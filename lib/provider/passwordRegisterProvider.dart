import 'package:flutter/material.dart';
import 'package:hashpass/provider/passwordProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:hashpass/widgets/interface/snackbar.dart';

class PasswordRegisterProvider extends PasswordProvider {
  final titleController = TextEditingController();
  late bool isNewPassword = password.isNew;
  late bool useCredential = password.credential.isNotEmpty;
  final UserPasswordsProvider userPasswordsProvider;

  PasswordRegisterProvider(
    super.password,
    this.userPasswordsProvider,
  ) {
    titleController.text = password.title;
    credentialController.text = password.credential;
    passwordController.text = password.getTrueBasePassword();
    hidePassword = true;
  }

  void setUseCredential(bool useCredential) {
    this.useCredential = useCredential;
    if (!useCredential) {
      password.credential = '';
      credentialController.text = '';
    }
    notifyListeners();
  }

  @override
  void savePassword(BuildContext context) async {
    if (await validatePassword(false)) {
      AuthAppKey.auth(
        onValidate: (key) async {
          password.title = titleController.text;
          password.credential = credentialController.text;
          password.basePassword =
              await HashCrypt.cipherString(passwordController.text, key);
          password.leakCount = leakInformation.leakCount;

          password.save().then((passwordId) {
            if (isNewPassword) {
              userPasswordsProvider.addPassword(password);
            }
            HashPassRouteManager.to(HashPassRoute.INDEX, context);
            HashPassSnackBar.show(
              message:
                  'Senha ${isNewPassword ? 'cadastrada' : 'atualizada'} com sucesso!',
            );
          });
        },
      );
    }
  }
}
