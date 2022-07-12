import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/util.dart';
import 'package:hashpass/Widgets/data/checkBox.dart';
import 'package:hashpass/Widgets/data/dropDown.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import 'package:hashpass/Widgets/visualizarSenha.dart';
import 'package:validatorless/validatorless.dart';
import '../Model/hashFunction.dart';
import '../Util/cryptography.dart';

class CardSenha extends StatefulWidget {
  const CardSenha({
    Key? key,
    required this.senha,
    required this.onDelete,
    required this.onUpdate,
    required this.onCopy,
  }) : super(key: key);
  final Senha senha;
  final Function(int) onDelete;
  final Function(int) onUpdate;
  final Function() onCopy;

  @override
  CardSenhaState createState() => CardSenhaState();

  static CardSenhaState? of(BuildContext context) => context.findAncestorStateOfType<CardSenhaState>();
}

class CardSenhaState extends State<CardSenha> {
  final formKey = GlobalKey<FormState>();
  final senhaEC = TextEditingController();
  final credencialEC = TextEditingController();

  late HashFunction algoritmoSelecionado = HashCrypt.algoritmos[widget.senha.algoritmo];

  late Icon verifyPassIcon = Util.notLeakedIcon;

  late String basePassword;
  String lastText = "";
  String isLeakedMessage = 'Sua senha tem grandes chances de não ter sido vazada!';

  bool toDelete = true;
  bool isDeleting = false;
  bool hasPasswordVerification = false;
  bool isVerifiedPassword = true;
  bool hidePassword = true;

  void atualizarParametrosSenha(String lastPassword, String newPassword, String credential, int algorithm) {
    widget.senha.algoritmo = algorithm;
    widget.senha.credencial = credential;
    if (lastPassword != basePassword) {
      widget.senha.senhaBase = newPassword;
      basePassword = newPassword;
      senhaEC.text = newPassword;
    }
  }

  @override
  void initState() {
    credencialEC.text = widget.senha.credencial;
    senhaEC.text = widget.senha.senhaBase;
    basePassword = widget.senha.senhaBase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: HashPassLabel(
                text: widget.senha.titulo,
                color: Get.theme.highlightColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: AppTextField(
                label: "Usuário/e-mail/credencial",
                padding: 0,
                controller: credencialEC,
                dark: true,
                fontColor: Colors.grey.shade300,
                borderColor: Get.theme.highlightColor,
                labelStyle: TextStyle(color: Colors.grey.shade300, fontSize: 17),
                validator: Validatorless.required("A credencial não pode estar vazia."),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 15, right: 20),
                      child: AppTextField(
                        label: widget.senha.criptografado ? "Senha base" : "Senha",
                        padding: 0,
                        labelStyle: TextStyle(color: Colors.grey.shade300, fontSize: 17),
                        validator: Validatorless.multiple(
                          [
                            Validatorless.required("A senha não pode estar vazia."),
                            Validatorless.min(4, 'A senha é curta demais!'),
                          ],
                        ),
                        controller: senhaEC,
                        dark: true,
                        obscureText: true,
                        borderColor: Get.theme.highlightColor,
                        fontColor: Colors.grey.shade300,
                        onChange: (text) {
                          setState(() {
                            toDelete = true;
                            if (text.isEmpty) {
                              hasPasswordVerification = false;
                            }
                          });
                          if (text.isEmpty || text.length < 4) {
                            isDeleting = true;
                            setState(() {
                              hasPasswordVerification = false;
                            });
                            return;
                          } else {
                            isDeleting = false;
                          }
                          if (Configuration.instance.updatePassVerify) {
                            HashCrypt.verifyPassowordLeak(text).then(
                              (response) {
                                if (isDeleting) {
                                  return;
                                }
                                setState(
                                  () {
                                    hasPasswordVerification = true;
                                    isLeakedMessage = response.message;
                                    verifyPassIcon = response.leakCount == 0 ? Util.notLeakedIcon : Util.leakedIcon;
                                    isVerifiedPassword = response.leakCount == 0;
                                  },
                                );
                              },
                            );
                          }
                        },
                        suffixIcon: toDelete
                            ? const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              )
                            : Icon(
                                Icons.history,
                                color: Get.theme.highlightColor,
                              ),
                        suffixIconClick: () {
                          if (toDelete) {
                            setState(() {
                              lastText = senhaEC.text;
                              toDelete = false;
                              senhaEC.text = "";
                              hasPasswordVerification = false;
                            });
                          } else {
                            setState(() {
                              toDelete = true;
                              senhaEC.text = lastText;
                              if (lastText.length > 4 || lastText.isNotEmpty) {
                                hasPasswordVerification = true;
                              }
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ValidarSenhaGeral.show(
                                onValidate: (key) {
                                  if (widget.senha.criptografado) {
                                    HashCrypt.applyAlgorithms(
                                      widget.senha.algoritmo,
                                      widget.senha.senhaBase,
                                      widget.senha.avancado,
                                      key,
                                    ).then((value) {
                                      Clipboard.setData(ClipboardData(text: value));
                                    });
                                  } else {
                                    HashCrypt.decipherString(widget.senha.senhaBase, key).then(
                                      (value) {
                                        Clipboard.setData(ClipboardData(text: value));
                                      },
                                    );
                                  }
                                  Get.back();
                                  widget.onCopy();
                                },
                              );
                            },
                            child: const HashPassLabel(
                              text: "Copiar senha",
                              size: 11,
                            ),
                          ),
                          Visibility(
                            visible: Configuration.instance.updatePassVerify && senhaEC.text.length > 4,
                            child: Tooltip(
                              margin: const EdgeInsets.only(left: 20, right: 20),
                              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                              triggerMode: TooltipTriggerMode.tap,
                              height: 20,
                              showDuration: const Duration(seconds: 5),
                              message: isLeakedMessage,
                              child: verifyPassIcon,
                              textStyle: TextStyle(
                                color: verifyPassIcon.color == Colors.greenAccent ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              decoration: BoxDecoration(
                                color: verifyPassIcon.color,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Visibility(
              visible: widget.senha.criptografado,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HashPassDropDown<HashFunction>(
                      itens: HashCrypt.algoritmos,
                      onChange: (function) {
                        setState(() {
                          algoritmoSelecionado = HashCrypt.algoritmos.firstWhere(
                            (algoritmo) => algoritmo.index == function.index,
                          );
                        });
                      },
                      hintText: "Função hash",
                      selectedItem: algoritmoSelecionado,
                    ),
                    HashPassCheckBox(
                      onChange: (isSelected) => widget.senha.avancado = isSelected,
                      value: widget.senha.avancado,
                      label: "Avançado",
                      labelSize: 14,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 8, bottom: 15, left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      ValidarSenhaGeral.show(
                        onValidate: (key) {
                          Get.dialog(
                            VisualizacaoSenhaModal(
                              chaveGeral: key,
                              senha: widget.senha,
                              copyIconColor: Theme.of(context).hintColor,
                            ),
                          );
                        },
                      );
                    },
                    child: HashPassLabel(
                      text: "VISUALIZAR SENHA",
                      size: 12,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.focusScope!.unfocus();
                          HashPassMessage.show(
                            title: "Confirmar exclusão",
                            message: "Você tem certeza que deseja excluir esta senha? Esta ação não poderá ser desfeita.",
                            type: MessageType.YESNO,
                          ).then((action) {
                            if (action == MessageResponse.YES) {
                              ValidarSenhaGeral.show(
                                onValidate: (key) async {
                                  int code = await SenhaDBSource().excluirSenha(widget.senha.id!);
                                  widget.onDelete(code);
                                },
                              );
                            }
                          });
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                      IconButton(
                        onPressed: () async {
                          debugPrint((!isVerifiedPassword).toString());
                          debugPrint((Configuration.instance.updatePassVerify).toString());
                          Get.focusScope!.unfocus();
                          if (!isVerifiedPassword && Configuration.instance.updatePassVerify) {
                            return;
                          }
                          if (Util.validateForm(formKey)) {
                            HashPassMessage.show(
                              title: "Confirmar",
                              message: "Tem certeza que deseja atualizar os dados desta senha?",
                              type: MessageType.YESNO,
                            ).then((action) {
                              if (action == MessageResponse.YES) {
                                Get.dialog(
                                  ValidarSenhaGeral(
                                    onValidate: (key) async {
                                      atualizarParametrosSenha(
                                        senhaEC.text,
                                        await HashCrypt.cipherString(senhaEC.text, key),
                                        credencialEC.text,
                                        algoritmoSelecionado.index,
                                      );
                                      int code = await SenhaDBSource().atualizarSenha(widget.senha);
                                      widget.onUpdate(code);
                                      setState(() {
                                        hasPasswordVerification = false;
                                      });
                                    },
                                  ),
                                );
                              }
                            });
                          }
                        },
                        icon: const Icon(Icons.save),
                        color: Get.theme.highlightColor,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
