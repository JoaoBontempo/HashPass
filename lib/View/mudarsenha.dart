import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Util/route.dart';
import 'package:hashpass/Util/util.dart';
import 'package:hashpass/Widgets/data/button.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/snackbar.dart';
import 'package:validatorless/validatorless.dart';
import '../Widgets/validarChave.dart';

class MudarSenhaPage extends StatefulWidget {
  const MudarSenhaPage({Key? key}) : super(key: key);

  @override
  State<MudarSenhaPage> createState() => _MudarSenhaPageState();
}

class _MudarSenhaPageState extends State<MudarSenhaPage> {
  bool showNewPassword = false;
  bool showConfirmPassword = true;
  final newPasswordEC = TextEditingController();
  final newPasswordTrim = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            Validatorless.required("Nenhuma senha foi informada"),
                            Validatorless.compare(newPasswordTrim, "A senha não pode conter espaços!"),
                            Validatorless.min(4, "A senha deve ter no mínimo 4 caracteres!"),
                          ],
                        ),
                        suffixIcon: showNewPassword ? Util.visiblePasswordIcon : Util.notVisiblePasswordIcon,
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
                              Validatorless.required("Confirme sua senha"),
                              Validatorless.compare(newPasswordEC, "As senhas informadas não são iguais"),
                            ],
                          ),
                          suffixIcon: showConfirmPassword ? Util.visiblePasswordIcon : Util.notVisiblePasswordIcon,
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
                  newPasswordTrim.text = newPasswordEC.text.replaceAll(" ", "");
                  if (Util.validateForm(formKey)) {
                    ValidarSenhaGeral.show(
                      onValidate: (oldKey) async {
                        if (await HashCrypt.alterarSenhaGeral(oldKey, newPasswordEC.text)) {
                          HashPassRoute.to("/index", context);
                          HashPassSnackBar.show(message: "Senha geral alterada com sucesso!");
                        } else {
                          HashPassSnackBar.show(
                            message: "Ocorreu um erro ao alterar a senha, tente novamente",
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
    );
  }
}
