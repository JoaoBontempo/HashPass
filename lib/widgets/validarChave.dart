import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/util/validator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hashpass/widgets/data/textfield.dart';

import '../util/cryptography.dart';

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
    this.onInvalid,
    required this.onValidate,
  }) : super(key: key);
  final Function(String) onValidate;
  final Function? onInvalid;
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

  @override
  void initState() {
    final LocalAuthentication auth = LocalAuthentication();
    if (Configuration.instance.isBiometria && !widget.onlyText) {
      try {
        auth
            .authenticate(
          localizedReason:
              "O desbloqueio é necessário para recuperar a senha do aplicativo",
          options: const AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
            biometricOnly: true,
          ),
        )
            .then(
          (biometriaValida) {
            Get.back();
            if (biometriaValida) {
              HashCrypt.isValidGeneralKey(null).then((value) {
                if (value) {
                  widget.onValidate(HashCrypt.getGeneralKeyBase());
                }
              });
            } else if (widget.onInvalid != null) {
              widget.onInvalid!();
            }
          },
        );
      } on Exception catch (error) {
        print(error);
      }
    }
    super.initState();
  }

  void validateTextKey() async {
    senhaEC.text = senhaEC.text.trim();
    if (Util.validateForm(formKey)) {
      bool chaveValida = await HashCrypt.isValidGeneralKey(senhaEC.text);
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
                    onKeyboardAction: (text) => validateTextKey(),
                    icon: Icons.lock_outlined,
                    maxLength: 50,
                    label: widget.lastKeyLabel
                        ? "Informe sua senha antiga:"
                        : "Senha do aplicativo:",
                    padding: 10,
                    controller: senhaEC,
                    validator:
                        HashPassValidator.empty("A senha não foi informada!"),
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
                  onPressed: () => validateTextKey()),
            ],
          );
  }
}