import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Model/hashFunction.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Widgets/data/button.dart';
import 'package:hashpass/Widgets/confirmdialog.dart';
import 'package:hashpass/Widgets/data/checkBox.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import 'package:validatorless/validatorless.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({Key? key, required this.onCadastro}) : super(key: key);
  final Function(Senha) onCadastro;

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  List<HashFunction> algoritmos = HashCrypt.algoritmos;
  late HashFunction? algoritmoSelecionado;
  bool isAvancado = false;
  final tituloEC = TextEditingController();
  final credencialEC = TextEditingController();
  final senhaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCriptografado = false;

  final Icon leakedIcon = const Icon(
    Icons.warning,
    color: Colors.redAccent,
  );

  final Icon notLeakedIcon = const Icon(
    Icons.verified_user,
    color: Colors.greenAccent,
  );

  late Icon verifyPassIcon;
  bool hasPasswordVerification = false;
  bool isVerifiedPassword = false;
  String isLeakedMessage = '';
  bool isDeleting = false;

  bool hidePassword = true;
  String hidePasswordLabel = 'Mostrar senha';

  @override
  void initState() {
    verifyPassIcon = leakedIcon;
    algoritmoSelecionado = algoritmos[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        return await HashPassMessage.show(
              title: "Confirmar",
              message: "Tem certeza que deseja cancelar o cadastro da senha?",
              type: MessageType.YESNO,
            ) ==
            MessageResponse.YES;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nova senha"),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: HashPassLabel(
                      text: "Cadastrar nova senha",
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AppTextField(
                      label: "Título",
                      padding: 0,
                      controller: tituloEC,
                      validator: Validatorless.multiple([
                        Validatorless.required("O título é obrigatório"),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AppTextField(
                      label: "Usuário/e-mail/CPF/credencial",
                      padding: 0,
                      controller: credencialEC,
                      validator: Validatorless.multiple([
                        Validatorless.required("A credencial é obrigatória"),
                      ]),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: AppTextField(
                          label: "Senha",
                          padding: 0,
                          obscureText: hidePassword,
                          controller: senhaEC,
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required("A senha é obrigatória"),
                              Validatorless.min(4, 'A senha é pequena demais'),
                            ],
                          ),
                          onChange: (password) {
                            if (password.isEmpty || password.length < 4) {
                              isDeleting = true;
                              setState(() {
                                hasPasswordVerification = false;
                              });
                              return;
                            } else {
                              isDeleting = false;
                            }
                            HashCrypt.verifyPassowordLeak(password).then(
                              (response) {
                                if (isDeleting) {
                                  return;
                                }
                                setState(
                                  () {
                                    hasPasswordVerification = true;
                                    isLeakedMessage = response.message;
                                    verifyPassIcon = response.leakCount == 0 ? notLeakedIcon : leakedIcon;
                                    isVerifiedPassword = response.leakCount == 0;
                                  },
                                );
                              },
                            );
                          },
                          suffixIcon: hasPasswordVerification && Configuration.instance.insertPassVerify
                              ? Tooltip(
                                  margin: EdgeInsets.only(left: 20, right: MediaQuery.of(context).size.width * .15 + 20, top: 5),
                                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: const Duration(seconds: 3),
                                  message: isLeakedMessage,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: verifyPassIcon,
                                  ),
                                  textStyle: TextStyle(
                                    color: verifyPassIcon.color == Colors.greenAccent ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: verifyPassIcon.color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                            hidePasswordLabel = hidePassword ? 'Mostrar senha' : 'Ocultar senha';
                          });
                        },
                        child: HashPassLabel(
                          text: hidePasswordLabel,
                          size: 11,
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: Get.size.width * .7,
                          child: HashPassCheckBox(
                            onChange: (isSelected) {
                              setState(() {
                                isCriptografado = isSelected;
                              });
                            },
                            value: isCriptografado,
                            label: "Senha com criptografia Hash",
                          ),
                        ),
                        Tooltip(
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 10),
                          message: "Ao marcar esta caixa, sua senha real será a "
                              "combinação entre uma senha base e um algoritmo hash.",
                          child: Visibility(
                            visible: Configuration.instance.showHelpTooltips,
                            child: const Icon(
                              Icons.help_outline,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isCriptografado,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Função Hash:",
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: DropdownButton<int>(
                                items: algoritmos.map<DropdownMenuItem<int>>((HashFunction algoritmo) {
                                  return DropdownMenuItem<int>(
                                    value: algoritmo.index,
                                    child: Text(algoritmo.label),
                                  );
                                }).toList(),
                                onChanged: (idSelecionado) {
                                  setState(() {
                                    algoritmoSelecionado = algoritmos.firstWhere((algoritmo) => algoritmo.index == idSelecionado);
                                  });
                                },
                                hint: const Text(
                                  "Algoritmo hash",
                                  style: TextStyle(color: AppColors.ACCENT_LIGHT),
                                  textAlign: TextAlign.center,
                                ),
                                icon: RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(Icons.chevron_right, color: Theme.of(context).toggleableActiveColor),
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: Theme.of(context).textTheme.bodyText2,
                                underline: Container(
                                  height: 2,
                                  color: Theme.of(context).toggleableActiveColor,
                                ),
                                value: algoritmoSelecionado?.index,
                              ),
                            ),
                          ],
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text("Modo de criptografia:"),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .35,
                                  child: RadioListTile(
                                    title: Text(
                                      "Modo normal",
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                    value: false,
                                    groupValue: isAvancado,
                                    onChanged: (value) {
                                      setState(() {
                                        isAvancado = value as bool;
                                      });
                                    },
                                  ),
                                ),
                                Tooltip(
                                  margin: EdgeInsets.only(left: 20, right: MediaQuery.of(context).size.width * .5, top: 5),
                                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: const Duration(seconds: 10),
                                  message: "Sua senha final será a senha base com o algoritmo hash aplicado.",
                                  child: Visibility(
                                    visible: Configuration.instance.showHelpTooltips,
                                    child: const Icon(
                                      Icons.help_outline,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .41,
                                  child: RadioListTile(
                                    title: Text(
                                      "Modo Avançado",
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                    value: true,
                                    groupValue: isAvancado,
                                    onChanged: (value) {
                                      setState(() {
                                        isAvancado = value as bool;
                                      });
                                    },
                                  ),
                                ),
                                Tooltip(
                                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .5, right: 20, top: 5),
                                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: const Duration(seconds: 5),
                                  message: "Além do algoritmo hash, sua senha real terá uma criptografia simétrica adicional.",
                                  child: Visibility(
                                    visible: Configuration.instance.showHelpTooltips,
                                    child: const Icon(
                                      Icons.help_outline,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 25),
                    child: AppButton(
                      label: "Cadastrar senha",
                      width: MediaQuery.of(context).size.width * .5,
                      height: 35,
                      onPressed: () async {
                        tituloEC.text = tituloEC.text.trim();
                        senhaEC.text = senhaEC.text.trim();
                        credencialEC.text = credencialEC.text.trim();
                        final formValido = formKey.currentState?.validate() ?? false;
                        if (Configuration.instance.insertPassVerify && !isVerifiedPassword) {
                          return;
                        }
                        if (formValido) {
                          showDialog(
                            context: context,
                            builder: (_) => ValidarSenhaGeral(
                              onValidate: (chaveGeral) async {
                                Navigator.of(context).pop();
                                Senha senha = Senha(
                                  titulo: tituloEC.text,
                                  credencial: credencialEC.text,
                                  senhaBase: await HashCrypt.cipherString(senhaEC.text, chaveGeral),
                                  avancado: isAvancado,
                                  algoritmo: algoritmoSelecionado == null ? 0 : algoritmoSelecionado!.index,
                                  criptografado: isCriptografado,
                                );
                                senha = await SenhaDBSource().inserirSenha(senha);
                                Navigator.of(context).pushNamed("/index");
                                widget.onCadastro(senha);
                              },
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
