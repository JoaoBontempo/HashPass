import 'package:flutter/material.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/Widgets/button.dart';
import 'package:hashpass/Widgets/textfield.dart';
import 'package:validatorless/validatorless.dart';
import '../Widgets/validarChave.dart';
import '../Widgets/verificar_token.dart';

class MudarSenhaPage extends StatefulWidget {
  const MudarSenhaPage({Key? key}) : super(key: key);

  @override
  State<MudarSenhaPage> createState() => _MudarSenhaPageState();
}

class _MudarSenhaPageState extends State<MudarSenhaPage> {
  bool mostrarTrocaSenha = false;
  bool mostrarWidgetConfirmacao = true;

  final newPasswordEC = TextEditingController();
  final newPasswordTrim = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late Icon visibilityIcon;

  bool hidePassword = true;

  final visibleIcon = const Icon(
    Icons.visibility,
    color: Colors.grey,
  );

  final noVisibleIcon = const Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );

  @override
  void initState() {
    visibilityIcon = noVisibleIcon;
    super.initState();
  }

  void changeVisibilityState() {
    setState(() {
      hidePassword = !hidePassword;
      visibilityIcon = hidePassword ? visibleIcon : noVisibleIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alterar senha geral"),
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Visibility(
                visible: mostrarWidgetConfirmacao,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: const [
                      Text(
                        "Para alterar sua senha geral, é necessário validar o e-mail que foi cadastrado no app.",
                        textAlign: TextAlign.justify,
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: mostrarWidgetConfirmacao,
                child: VerificarTokenWidget(
                  isFirstTime: false,
                  onValidate: (destinatario) {
                    setState(() {
                      mostrarWidgetConfirmacao = false;
                      mostrarTrocaSenha = true;
                    });
                  },
                ),
              ),
              Visibility(
                visible: mostrarTrocaSenha,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Alterar senha",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .85,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 20, right: 5, left: 20),
                              child: AppTextField(
                                label: "Nova senha",
                                padding: 0,
                                obscureText: hidePassword,
                                controller: newPasswordEC,
                                validator: Validatorless.multiple(
                                  [
                                    Validatorless.required("Nenhuma senha foi informada"),
                                    Validatorless.compare(newPasswordTrim, "A senha não pode conter espaços!")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: GestureDetector(
                              onTap: () {
                                changeVisibilityState();
                              },
                              child: visibilityIcon,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                        child: AppTextField(
                          label: "Confirmar nova senha",
                          padding: 0,
                          obscureText: true,
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required("Confirme sua senha"),
                              Validatorless.compare(newPasswordEC, "As senhas informadas não são iguais"),
                            ],
                          ),
                        ),
                      ),
                      AppButton(
                        label: "Mudar senha",
                        width: MediaQuery.of(context).size.width * .4,
                        height: 35,
                        onPressed: () {
                          newPasswordTrim.text = newPasswordEC.text.replaceAll(" ", "");
                          final formValido = formKey.currentState?.validate() ?? false;
                          if (formValido) {
                            showDialog(
                              context: context,
                              builder: (_) => ValidarSenhaGeral(
                                onlyText: true,
                                lastKeyLabel: true,
                                onValidate: (chaveAntiga) async {
                                  bool alterou = await Criptografia.alterarSenhaGeral(chaveAntiga, newPasswordEC.text);

                                  if (alterou) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      "/index",
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Senha geral alterada com sucesso!",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        backgroundColor: Colors.greenAccent,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Ocorreu um erro ao alterar a senha, tente novamente",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
