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

  final novaSenhaEC = TextEditingController();

  final formKey = GlobalKey<FormState>();

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
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: AppTextField(
                          label: "Nova senha",
                          padding: 0,
                          controller: novaSenhaEC,
                          validator: Validatorless.required("Nenhuma senha foi informada"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                        child: AppTextField(
                          label: "Confirmar nova senha",
                          padding: 0,
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required("Confirme sua senha"),
                              Validatorless.compare(novaSenhaEC, "As senhas informadas não são iguais"),
                            ],
                          ),
                        ),
                      ),
                      AppButton(
                        label: "Mudar senha",
                        width: MediaQuery.of(context).size.width * .4,
                        height: 35,
                        onPressed: () {
                          final formValido = formKey.currentState?.validate() ?? false;
                          if (formValido) {
                            showDialog(
                              context: context,
                              builder: (_) => ValidarSenhaGeral(
                                onValidate: (chaveAntiga) async {
                                  bool alterou = await Criptografia.alterarSenhaGeral(chaveAntiga, novaSenhaEC.text);

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
