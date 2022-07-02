import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/DTO/dataExportDTO.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/View/index.dart';
import 'package:hashpass/Widgets/data/copyButton.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:share_plus/share_plus.dart';
import 'package:validatorless/validatorless.dart';

import '../Util/util.dart';
import '../Widgets/data/button.dart';

class MenuDados extends StatefulWidget {
  const MenuDados({Key? key}) : super(key: key);

  @override
  _MenuDadosState createState() => _MenuDadosState();
}

class _MenuDadosState extends State<MenuDados> {
  bool showExportProgress = false;
  final chaveEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool verifyPasswordInfoIntegrity(Senha password) {
    if (password.titulo.contains('Decrypt failure.') ||
        password.titulo.contains('Failed to get string encoded:') ||
        password.senhaBase.contains('Decrypt failure.') ||
        password.senhaBase.contains('Failed to get string encoded:') ||
        password.credencial.contains('Decrypt failure.') ||
        password.credencial.contains('Failed to get string encoded:')) {
      return false;
    } else {
      return true;
    }
  }

  void dataExport() async {
    DataExportDTO exportDTO = await Criptografia.exportarDados();
    String filePath = '${Directory.systemTemp.path}/hashpass.txt';
    final File file = File(filePath);
    await file.writeAsString(exportDTO.fileContent);
    await Share.shareFiles([filePath]);
    HashPassMessage.show(
      body: Column(
        children: [
          const HashPassLabel(
            text: "Seus dados foram exportados com sucesso! Você deverá usar a chave abaixo para importar seus dados.",
            size: 14.5,
          ),
          HashPassLabel(
            text: exportDTO.fileKey,
            paddingTop: 10,
            paddingBottom: 10,
            size: 14,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CopyTextButton(
              textToCopy: exportDTO.fileKey,
              label: "Copiar chave",
              labelSize: 14.5,
              widgetSize: 20,
            ),
          )
        ],
      ),
      title: "Dados exportados com sucesso!",
    );
  }

  void dataImport() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exportar/importar dados"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: Util.senhas.isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HashPassLabel(
                            text: "Exportação de dados",
                            fontWeight: FontWeight.bold,
                          ),
                          HashPassLabel(
                            paddingTop: 20,
                            text:
                                "Será enviado um arquivo, em formato .json, e uma chave criptográfica para o e-mail que você cadastrou no app. O arquivo terá suas informações "
                                "criptografadas e prontas para serem importadas. A chave é necessária para decifrar o conteúdo criptografado do arquivo.",
                            style: Get.theme.textTheme.headline1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: AppButton(
                              label: "Exportar dados",
                              width: Get.size.width * .5,
                              height: 35,
                              onPressed: () => dataExport(),
                            ),
                          ),
                          Visibility(
                            visible: showExportProgress,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: const [
                                  CircularProgressIndicator(
                                    strokeWidth: 5,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Exportando dados...",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        child: Text(
                          "Insira a chave criptográfica que foi enviada para seu e-mail e pressione o botão 'Importar dados'. "
                          "Selecione o arquivo que contém seus dados para que seja possível a importação. Certifique-se de que "
                          "você está usando a chave e o arquivo corretos. Após a importação, o arquivo será excluído automaticamente "
                          "do seu dispositivo. Será necessário permitir o acesso aos arquivos do dispositivo.",
                          style: Theme.of(context).textTheme.headline1,
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
                            var file;
                            if (formValido) {
                              try {
                                file = await FilePicker.platform.pickFiles(
                                  dialogTitle: "Selecione o arquivo enviado para seu e-mail",
                                  type: FileType.custom,
                                  allowedExtensions: ['json'],
                                  allowMultiple: false,
                                );
                              } catch (erro) {
                                file = await FilePicker.platform
                                    .pickFiles(
                                  dialogTitle: "Selecione o arquivo enviado para seu e-mail",
                                  type: FileType.any,
                                  allowMultiple: false,
                                )
                                    .onError((error, stackTrace) {
                                  if (error.toString().toLowerCase().contains('user did not allow reading external storage')) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Erro ao abrir arquivo",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        content: const Text("Para importar seus dados, é necessário permitir o acesso aos arquivos do "
                                            "dispositivo."),
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
                                });
                              }
                              if (file != null) {
                                try {
                                  File arquivo = File(file.files.first.path);
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
                                    if (!verifyPasswordInfoIntegrity(senha)) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text("Erro ao importar dados",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          content: const Text("Não foi decifrar as informações inseridas. \n\n"
                                              "* Verifique se a chave de exportação inserida está correta;\n"
                                              "* Verifique se a senha do aplicativo é a mesma que você utilizava antes."),
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
                                      return;
                                    }
                                    SenhaDBSource().inserirSenha(senha);
                                    Util.senhas.add(senha);
                                  }
                                  arquivo.delete();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const IndexPage()));
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
      ),
    );
  }
}
