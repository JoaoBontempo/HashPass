import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/DTO/dataExportDTO.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/View/index.dart';
import 'package:hashpass/Widgets/data/copyButton.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:hashpass/Widgets/interface/snackbar.dart';
import 'package:hashpass/Widgets/validarChave.dart';
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
    ValidarSenhaGeral.show(onValidate: (key) async {
      DataExportDTO exportDTO = await HashCrypt.exportData(key);
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
    });
  }

  Future<FilePickerResult?> getFile({
    FileType type = FileType.any,
    List<String>? types,
  }) async {
    try {
      FilePickerResult? file = await FilePicker.platform
          .pickFiles(
        dialogTitle: "Selecione o arquivo para importação",
        type: FileType.custom,
        allowedExtensions: types,
        allowMultiple: false,
      )
          .onError(
        (error, stackTrace) {
          if (error.toString().toLowerCase().contains('user did not allow reading external storage')) {
            HashPassMessage.show(
              message: "Para importar seus dados, é necessário permitir o acesso aos arquivos do "
                  "dispositivo.",
              title: "Acesso negado",
            );
          } else {
            HashPassMessage.show(
              message: error.toString(),
              title: "Erro desconhecido ao abrir o arquivo",
            );
          }
        },
      );
      return file;
    } catch (erro) {
      throw erro;
    }
  }

  void dataImport() async {
    FilePickerResult? file;
    if (Util.validateForm(formKey)) {
      ValidarSenhaGeral.show(onValidate: (appKey) async {
        try {
          file = await getFile(type: FileType.custom, types: ['txt']);
        } catch (erro) {
          file = await getFile();
        }
        if (file != null) {
          try {
            File arquivo = File(file!.files.first.path!);
            List<String> fileLines = await arquivo.readAsLines();
            List<Senha> senhas = await HashCrypt.importPasswords(
              fileLines.join(','),
              chaveEC.text,
              appKey,
            );
            for (Senha senha in senhas) {
              SenhaDBSource().inserirSenha(senha);
              Util.senhas.add(senha);
            }
            Get.to(const IndexPage());
            HashPassSnackBar.show(message: "Dados importados com sucesso!");
          } on Exception catch (erro) {
            HashPassMessage.show(
              message: "Um erro inesperado ocorreu ao importar seus dados. Por favor, tente novamente \n\n"
                  "* Verifique se a chave inserida está correta"
                  "\n* Verifique se o arquivo selecionado é o correto para esta chave"
                  "\n* Verifique se sua chave geral do app é a mesma de quando você exportou os arquivos",
              title: "Ocorreu um erro",
            );
          }
        } else {
          HashPassSnackBar.show(
            message: "Importação cancelada. Nenhum arquivo foi selecionado",
            type: SnackBarType.ERROR,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exportar/importar dados"),
      ),
      body: SingleChildScrollView(
        reverse: false,
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
                            text: 'Será gerado um arquivo contendo suas senhas, criptografado com uma chave gerada aleatoriamente.'
                                'Você poderá exportar este arquivo para o lugar de sua preferência e copiar a chave aleatória que foi gerada. '
                                'A chave será necessária para decifrar o conteúdo do arquivo criptografado do arquivo na importação de dados.',
                            style: Get.theme.textTheme.headline1,
                          ),
                          const HashPassLabel(
                            paddingTop: 15,
                            text: 'NÃO COMPARTILHE SUA CHAVE E NÃO ENVIE O ARQUIVO PARA NINGUÉM!',
                            size: 10,
                            color: Colors.redAccent,
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
                          "Insira a chave criptográfica que foi gerada ao exportar os dados e pressione o botão 'Importar dados'. "
                          "Selecione o arquivo que contém seus dados para que seja possível a importação. Certifique-se de que "
                          "você está usando a chave e o arquivo corretos e que sua chave geral do HashPass é a mesma de quando você exportou os dados. "
                          "Será necessário permitir o acesso aos arquivos do dispositivo.",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: AppTextField(
                          icon: Icons.vpn_key_outlined,
                          label: "Insira a chave de exportação",
                          padding: 0,
                          controller: chaveEC,
                          validator: Validatorless.required("A chave é obrigatória!"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: AppButton(
                          label: "Importar dados",
                          width: MediaQuery.of(context).size.width * .5,
                          height: 35,
                          onPressed: () => dataImport(),
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
