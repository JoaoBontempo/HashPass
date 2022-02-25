import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/Widgets/textfield.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import 'package:validatorless/validatorless.dart';

import '../Util/util.dart';
import '../Widgets/button.dart';

class MenuDados extends StatefulWidget {
  const MenuDados({Key? key}) : super(key: key);

  @override
  _MenuDadosState createState() => _MenuDadosState();
}

class _MenuDadosState extends State<MenuDados> {
  bool showExportProgress = false;
  final chaveEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exportar/importar dados"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Exportação de dados",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: AppButton(
                      label: "Exportar dados",
                      width: MediaQuery.of(context).size.width * .5,
                      height: 35,
                      onPressed: () async {
                        setState(() {
                          showExportProgress = true;
                        });
                        showDialog(
                          context: context,
                          builder: (_) => ValidarSenhaGeral(onValidate: (senha) async {
                            String response = await Criptografia.exportarDados();
                            if (response == 'Dados exportados com sucesso!') {
                              setState(() {
                                showExportProgress = false;
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Dados exportados!"),
                                    content: const Text("Seus dados foram exportados com sucesso! Verifique o e-mail "
                                        "que você cadastrou no app, inclusive a caixa de span. Foram enviado um arquivo "
                                        "e uma chave criptográfica para que você possa importar seus dados."),
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
                              });
                            } else {
                              setState(() {
                                showExportProgress = false;
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Ocorreu um erro"),
                                    content: Text("Um erro inesperado ocorreu ao exportar seus dados. Por favor, tente novamente \n\n"
                                        "Mensagem de erro: $response"),
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
                              });
                            }
                          }),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: showExportProgress,
                    child: const CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: Divider(),
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Importação de dados",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AppTextField(
                        label: "Insira a chave de exportação",
                        padding: 0,
                        controller: chaveEC,
                        validator: Validatorless.required("Este campo é obrigatório"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: AppButton(
                        label: "Importar dados",
                        width: MediaQuery.of(context).size.width * .5,
                        height: 35,
                        onPressed: () async {
                          final formValido = formKey.currentState?.validate() ?? false;
                          if (formValido) {
                            final file = await FilePicker.platform.pickFiles(
                              dialogTitle: "Selecione o arquivo enviado para seu e-mail",
                              type: FileType.custom,
                              allowedExtensions: ['json'],
                            );
                            if (file != null) {
                              try {
                                File arquivo = File(file.files.first.path!);
                                String jsonString = await arquivo.readAsString();
                                jsonString = jsonString.replaceAll("\\", "");
                                jsonString = jsonString.replaceAll('"{', "{");
                                jsonString = jsonString.replaceAll('}"', "}");
                                List<Senha> senhas = Senha.serializeList(jsonString);
                                for (Senha senha in senhas) {
                                  senha.titulo = (await Criptografia.decifrarSenha(
                                    senha.titulo,
                                    chaveEC.text,
                                  ))!;
                                  senha.credencial = (await Criptografia.decifrarSenha(
                                    senha.credencial,
                                    chaveEC.text,
                                  ))!;
                                  senha.senhaBase = (await Criptografia.decifrarSenha(
                                    senha.senhaBase,
                                    chaveEC.text,
                                  ))!;
                                  SenhaDBSource().inserirSenha(senha);
                                  Util.senhas.add(senha);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Dados importados com sucesso!",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                );
                              } on Exception catch (erro) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Ocorreu um erro"),
                                    content: const Text("Um erro inesperado ocorreu ao importar seus dados. Por favor, tente novamente \n\n"
                                        "* Verifique se a chave inserida está correta"
                                        "\n* Verifique se o arquivo selecionado é o correto para esta chave"),
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
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Importação cancelada. Nenhum arquivo foi selecionado",
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
