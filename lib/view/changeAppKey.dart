import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/security/cryptography.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/data/button.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/snackbar.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class ChangeAppKeyPage extends StatefulWidget {
  const ChangeAppKeyPage({Key? key}) : super(key: key);

  @override
  State<ChangeAppKeyPage> createState() => _ChangeAppKeyPageState();
}

class _ChangeAppKeyPageState extends HashPassState<ChangeAppKeyPage> {
  bool showNewPassword = false;
  bool showConfirmPassword = true;
  final newPasswordEC = TextEditingController();
  final newPasswordTrim = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget localeBuild(context, language) => Consumer<UserPasswordsProvider>(
        builder: (context, passwordProvider, widget) => Scaffold(
          appBar: AppBar(
            title: Text(language.changePasswordMenu),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HashPassLabel(
                    text: language.editPassword,
                    fontWeight: FontWeight.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          AppTextField(
                            icon: Icons.lock_outline,
                            label: language.newPassword,
                            padding: 0,
                            maxLength: 50,
                            obscureText: showNewPassword,
                            controller: newPasswordEC,
                            validator: Validatorless.multiple(
                              [
                                HashPassValidator.empty(
                                  language.emptyPassword,
                                ),
                                Validatorless.compare(
                                  newPasswordTrim,
                                  language.notEqualPasswords,
                                ),
                                Validatorless.min(
                                  4,
                                  language.passwordMinimumSizeMessage,
                                ),
                              ],
                            ),
                            suffixIcon: showNewPassword
                                ? Util.visiblePasswordIcon
                                : Util.notVisiblePasswordIcon,
                            suffixIconClick: () => setState(() {
                              showNewPassword = !showNewPassword;
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: AppTextField(
                              icon: Icons.lock_outline,
                              label: language.confirmPassword,
                              padding: 0,
                              maxLength: 50,
                              obscureText: showConfirmPassword,
                              validator: Validatorless.multiple(
                                [
                                  HashPassValidator.empty(
                                      language.confirmPassword),
                                  Validatorless.compare(
                                    newPasswordEC,
                                    language.notEqualPasswords,
                                  ),
                                ],
                              ),
                              suffixIcon: showConfirmPassword
                                  ? Util.visiblePasswordIcon
                                  : Util.notVisiblePasswordIcon,
                              suffixIconClick: () => setState(() {
                                showConfirmPassword = !showConfirmPassword;
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppButton(
                    label: language.confirm,
                    width: Get.size.width * .5,
                    height: 35,
                    onPressed: () {
                      newPasswordTrim.text = newPasswordEC.text.trim();
                      if (Util.validateForm(formKey)) {
                        AuthAppKey.auth(
                          onValidate: (oldKey) async {
                            try {
                              List<Password> passwords =
                                  await HashCrypt.changeGeneralKey(
                                oldKey,
                                newPasswordEC.text,
                              );
                              passwordProvider.setPasswords(passwords);
                              HashPassRouteManager.to(
                                  HashPassRoute.INDEX, context);
                              HashPassSnackBar.show(
                                message: language.changeGeneralKeySuccess,
                              );
                            } on Exception catch (error) {
                              HashPassSnackBar.show(
                                message:
                                    "${language.errorOcurred} ($error). ${language.tryAgain}",
                                type: SnackBarType.ERROR,
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
