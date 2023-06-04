import 'package:flutter/material.dart';
import 'package:hashpass/provider/passwordProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';

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
    passwordController.text = password.basePassword;
    passwordHasBeenVerified = isNewPassword ? password.leakCount == 0 : false;
  }

  void setUseCredential(bool useCredential) {
    this.useCredential = useCredential;
    notifyListeners();
  }

  @override
  void savePassword(BuildContext context) async {
    if (await validatePassword()) {
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
              HashPassRouteManager.to(HashPassRoute.INDEX, context);
            }
          });
        },
      );
    }
  }
}
