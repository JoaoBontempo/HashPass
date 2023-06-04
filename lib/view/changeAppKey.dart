import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/util/validator.dart';
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

class _ChangeAppKeyPageState extends State<ChangeAppKeyPage> {
  bool showNewPassword = false;
  bool showConfirmPassword = true;
  final newPasswordEC = TextEditingController();
  final newPasswordTrim = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPasswordsProvider>(
      builder: (context, passwordProvider, widget) => Scaffold(
        appBar: AppBar(
          title: const Text("Alterar senha geral"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HashPassLabel(
                  text: "Alterar senha",
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
                          label: "Nova senha",
                          padding: 0,
                          maxLength: 50,
                          obscureText: showNewPassword,
                          controller: newPasswordEC,
                          validator: Validatorless.multiple(
                            [
                              HashPassValidator.empty(
                                  "Nenhuma senha foi informada"),
                              Validatorless.compare(newPasswordTrim,
                                  "A senha não pode conter espaços!"),
                              Validatorless.min(4,
                                  "A senha deve ter no mínimo 4 caracteres!"),
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
                            label: "Confirmar nova senha",
                            padding: 0,
                            maxLength: 50,
                            obscureText: showConfirmPassword,
                            validator: Validatorless.multiple(
                              [
                                HashPassValidator.empty("Confirme sua senha"),
                                Validatorless.compare(newPasswordEC,
                                    "As senhas informadas não são iguais"),
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
                  label: "Mudar senha",
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
                                message: "Senha geral alterada com sucesso!");
                          } on Exception catch (error) {
                            HashPassSnackBar.show(
                              message:
                                  "Ocorreu um erro ao alterar a senha ($error), tente novamente",
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
}
