import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:validatorless/validatorless.dart';
import 'package:hashpass/Widgets/textfield.dart';

import '../Util/criptografia.dart';

class ValidarSenhaGeral extends StatefulWidget {
  const ValidarSenhaGeral({
    Key? key,
    required this.onValidate,
  }) : super(key: key);
  final Function(String) onValidate;
  @override
  _ValidarSenhaGeralState createState() => _ValidarSenhaGeralState();
}

class _ValidarSenhaGeralState extends State<ValidarSenhaGeral> {
  final senhaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool chaveInvalida = false;
  int tentativas = 3;
  late bool aceitaDigital;
  final bool isBiometria = Configuration.isBiometria;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    if (isBiometria) {
      auth
          .authenticate(
        localizedReason: "O desbloqueio é necessário para recuperar a senha do aplicativo",
        androidAuthStrings: const AndroidAuthMessages(
          signInTitle: "Autenticação necessária",
          biometricHint: "Validação de identidade",
        ),
      )
          .then(
        (biometriaValida) {
          if (biometriaValida) {
            Criptografia.validarChaveInserida(null).then((value) {
              if (value) {
                widget.onValidate(Criptografia.recuperarBaseChaveGeral());
              }
            });
          } else {
            exit(0);
          }
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isBiometria
        ? Container()
        : AlertDialog(
            title: const Text("Autenticação necessária"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: AppTextField(
                    label: "Senha do aplicativo:",
                    padding: 10,
                    controller: senhaEC,
                    validator: Validatorless.multiple([
                      Validatorless.required("A senha não foi informada!"),
                    ]),
                  ),
                ),
                Visibility(
                  visible: chaveInvalida,
                  child: Text(
                    "Chave inválida! Você possui mais $tentativas tentativas!",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Validar"),
                onPressed: () async {
                  final formValido = formKey.currentState?.validate() ?? false;
                  if (formValido) {
                    bool chaveValida = await Criptografia.validarChaveInserida(senhaEC.text);
                    if (chaveValida) {
                      widget.onValidate(senhaEC.text);
                    } else {
                      setState(() {
                        tentativas--;
                        if (tentativas == 0) {
                          exit(0);
                        }
                        chaveInvalida = !chaveValida;
                      });
                    }
                  }
                },
              ),
            ],
          );
  }
}
