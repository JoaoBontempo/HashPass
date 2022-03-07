import 'package:flutter/material.dart';
import 'package:hashpass/Database/datasource.dart';

import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Widgets/confirmdialog.dart';
import 'package:hashpass/Widgets/textfield.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import 'package:hashpass/Widgets/visualizar_senha.dart';
import 'package:validatorless/validatorless.dart';

import '../Model/hash_function.dart';
import '../Util/criptografia.dart';

class CardSenha extends StatefulWidget {
  const CardSenha({
    Key? key,
    required this.senha,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);
  final Senha senha;
  final Function(int) onDelete;
  final Function(int) onUpdate;

  @override
  CardSenhaState createState() => CardSenhaState();

  static CardSenhaState? of(BuildContext context) => context.findAncestorStateOfType<CardSenhaState>();
}

class CardSenhaState extends State<CardSenha> {
  List<HashFunction> algoritmos = Criptografia.algoritmos;
  late HashFunction algoritmoSelecionado = algoritmos[widget.senha.algoritmo];
  final senhaEC = TextEditingController();
  final credencialEC = TextEditingController();

  bool visiblePassword = true;
  late Icon isPasswordVisibleIcon;

  bool toDelete = true;
  String lastText = "";
  late String basePassword;
  final formKey = GlobalKey<FormState>();

  final Icon visiblePasswordIcon = const Icon(
    Icons.visibility,
    color: AppColors.ACCENT_LIGHT_2,
  );

  final Icon notVisiblePasswordIcon = const Icon(
    Icons.visibility_off,
    color: AppColors.ACCENT_LIGHT_2,
  );

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
    isPasswordVisibleIcon = visiblePasswordIcon;
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
              child: Text(
                widget.senha.titulo,
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold,
                ),
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
                borderColor: Theme.of(context).highlightColor,
                labelStyle: TextStyle(color: Colors.grey.shade300, fontSize: 17),
                validator: Validatorless.required("A credencial não pode estar vazia."),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 15, right: 2),
                    child: AppTextField(
                      label: widget.senha.criptografado ? "Senha base" : "Senha",
                      padding: 0,
                      labelStyle: TextStyle(color: Colors.grey.shade300, fontSize: 17),
                      validator: Validatorless.required("A senha não pode estar vazia."),
                      controller: senhaEC,
                      dark: true,
                      obscureText: true,
                      borderColor: Theme.of(context).highlightColor,
                      fontColor: Colors.grey.shade300,
                      onChange: (text) {
                        setState(() {
                          toDelete = true;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      if (toDelete) {
                        setState(() {
                          lastText = senhaEC.text;
                          toDelete = false;
                          senhaEC.text = "";
                        });
                      } else {
                        setState(() {
                          toDelete = true;
                          senhaEC.text = lastText;
                        });
                      }
                    },
                    icon: toDelete
                        ? const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                          )
                        : Icon(
                            Icons.history,
                            color: Theme.of(context).highlightColor,
                          ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: widget.senha.criptografado,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
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
                      dropdownColor: Theme.of(context).primaryColor == AppColors.SECONDARY_DARK ? Colors.grey.shade900 : AppColors.SECONDARY_LIGHT,
                      hint: const Text(
                        "Função Hash",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      icon: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                      ),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).highlightColor,
                      ),
                      value: algoritmoSelecionado.index,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .42,
                    child: CheckboxListTile(
                      side: const BorderSide(color: Colors.white),
                      activeColor: Theme.of(context).highlightColor,
                      checkColor: Colors.black,
                      title: Text(
                        "Avançado",
                        style: TextStyle(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      value: widget.senha.avancado,
                      onChanged: (isSelected) {
                        setState(() {
                          widget.senha.avancado = isSelected!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10, top: 8, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (_) => ValidarSenhaGeral(
                          onValidate: (chaveGeral) {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (_) => VisualizacaoSenhaModal(
                                chaveGeral: chaveGeral,
                                senha: widget.senha,
                                copyIconColor: Theme.of(context).hintColor,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: const Text("Visualizar senha"),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          showDialog(
                            context: context,
                            builder: (_) => AppConfirmDialog(
                              titulo: "Confirmar exclusão",
                              descricao: "Você tem certeza que deseja excluir esta senha? Esta ação não poderá ser desfeita.",
                              onAction: (confirmed) {
                                if (confirmed) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ValidarSenhaGeral(
                                      onValidate: (chaveGeral) async {
                                        Navigator.of(context).pop();
                                        int code = await SenhaDBSource().excluirSenha(widget.senha.id!);
                                        widget.onDelete(code);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                      IconButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          final formValido = formKey.currentState?.validate() ?? false;
                          if (formValido) {
                            showDialog(
                              context: context,
                              builder: (_) => AppConfirmDialog(
                                titulo: "Confirmar",
                                descricao: "Tem certeza que deseja atualizar os dados desta senha?",
                                onAction: (confirmed) {
                                  if (confirmed) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => ValidarSenhaGeral(
                                        onValidate: (chaveGeral) async {
                                          Navigator.of(context).pop();
                                          String senhaCripto = await Criptografia.criptografarSenha(senhaEC.text, chaveGeral);
                                          atualizarParametrosSenha(senhaEC.text, senhaCripto, credencialEC.text, algoritmoSelecionado.index);
                                          int code = await SenhaDBSource().atualizarSenha(widget.senha);
                                          widget.onUpdate(code);
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.save),
                        color: Theme.of(context).highlightColor,
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
