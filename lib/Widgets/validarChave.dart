import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:validatorless/validatorless.dart';
import 'package:hashpass/Widgets/data/textfield.dart';

import '../Util/cryptography.dart';

class ValidarSenhaGeral extends StatefulWidget {
  static void show({
    bool lastKeyLabel = false,
    bool onlyText = false,
    required Function(String) onValidate,
  }) {
    Get.dialog(
      ValidarSenhaGeral(
        onValidate: (key) => onValidate(key),
        onlyText: onlyText,
        lastKeyLabel: lastKeyLabel,
      ),
    );
  }

  const ValidarSenhaGeral({
    Key? key,
    this.onlyText = false,
    this.lastKeyLabel = false,
    required this.onValidate,
  }) : super(key: key);
  final Function(String) onValidate;
  final bool onlyText;
  final bool lastKeyLabel;
  @override
  _ValidarSenhaGeralState createState() => _ValidarSenhaGeralState();
}

class _ValidarSenhaGeralState extends State<ValidarSenhaGeral> {
  final senhaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool chaveInvalida = false;
  int tentativas = 3;
  late bool aceitaDigital;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    if (Configuration.instance.isBiometria && !widget.onlyText) {
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
          Get.back();
          if (biometriaValida) {
            HashCrypt.validarChaveInserida(null).then((value) {
              if (value) {
                widget.onValidate(HashCrypt.recuperarBaseChaveGeral());
              }
            });
          }
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Configuration.instance.isBiometria && !widget.onlyText
        ? Container()
        : AlertDialog(
            title: const Text("Autenticação necessária"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: AppTextField(
                    icon: FontAwesomeIcons.lock,
                    label: widget.lastKeyLabel ? "Informe sua senha antiga:" : "Senha do aplicativo:",
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
                  senhaEC.text = senhaEC.text.trim();
                  final formValido = formKey.currentState?.validate() ?? false;
                  if (formValido) {
                    bool chaveValida = await HashCrypt.validarChaveInserida(senhaEC.text);
                    if (chaveValida) {
                      Get.back();
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
