import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import 'package:hashpass/Widgets/button.dart';
import 'package:hashpass/Widgets/textfield.dart';

import '../Model/configuration.dart';
import '../Model/verificar_usuario_dto.dart';
import '../Util/http.dart';

class VerificarTokenWidget extends StatefulWidget {
  const VerificarTokenWidget({
    Key? key,
    required this.isFirstTime,
    required this.onValidate,
  }) : super(key: key);
  final bool isFirstTime;
  final Function(String) onValidate;

  @override
  _VerificarTokenWidgetState createState() => _VerificarTokenWidgetState();
}

class _VerificarTokenWidgetState extends State<VerificarTokenWidget> {
  final emailEC = TextEditingController();
  final compareTokenEC = TextEditingController();

  final formEmailKey = GlobalKey<FormState>();
  final formTokenKey = GlobalKey<FormState>();

  String token = "";

  late VerificarUsuarioDTO dto;

  bool sendMailFormVisible = true;
  bool sendTokenFormVisible = false;

  bool showProgress = false;

  String? emailCadastrado = Configuration.getEmail();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: sendMailFormVisible,
          child: Form(
            key: formEmailKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: AppTextField(
                    label: "Informe o e-mail",
                    padding: 0,
                    controller: emailEC,
                    validator: widget.isFirstTime
                        ? Validatorless.multiple(
                            [
                              Validatorless.required("Nenhum e-mail foi informado."),
                              Validatorless.email("O e-mail informado não é válido."),
                            ],
                          )
                        : Validatorless.multiple(
                            [
                              Validatorless.required("Nenhum e-mail foi informado."),
                              Validatorless.email("O e-mail informado não é válido."),
                              Validatorless.compare(emailEC, emailCadastrado!),
                            ],
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: AppButton(
                      label: "Enviar e-mail de confirmação",
                      width: MediaQuery.of(context).size.width * .7,
                      height: 35,
                      onPressed: () async {
                        final formValido = formEmailKey.currentState?.validate() ?? false;
                        if (formValido) {
                          dto = VerificarUsuarioDTO(destinatario: emailEC.text);
                          token = dto.construirToken();
                          token = dto.token!;
                          setState(() {
                            showProgress = true;
                          });
                          String response = await HTTPRequest.postRequest("/token", dto.toJson());
                          setState(() {
                            showProgress = true;
                            debugPrint("Enviou o e-mail!");
                          });
                          if (response == "Email enviado com sucesso!") {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Token enviado!"),
                                content: Text("Um e-mail foi enviado para ${emailEC.text} contendo um token de validação."
                                    "\n\n* Verifique sua caixa de span"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              ),
                            );
                            setState(() {
                              sendMailFormVisible = false;
                              sendTokenFormVisible = true;
                            });
                          } else {
                            debugPrint(response);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Ocorreu um erro ao enviar o e-mail. Tente novamente!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: showProgress,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: sendTokenFormVisible,
          child: Form(
            key: formTokenKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: AppTextField(
                    label: "Insira o token",
                    padding: 0,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required("Nenhum token foi informado!"),
                        Validatorless.compare(compareTokenEC, "O token informado está incorreto!"),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30),
                    child: AppButton(
                      label: "Confirmar token",
                      width: MediaQuery.of(context).size.width * .6,
                      height: 35,
                      onPressed: () async {
                        compareTokenEC.text = token;
                        final formValido = formTokenKey.currentState?.validate() ?? false;

                        if (formValido) {
                          widget.onValidate(dto.destinatario);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "O token inserido está incorreto!",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
