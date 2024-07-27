import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/dto/dataExportDTO.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/security/cryptography.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/view/index.dart';
import 'package:hashpass/widgets/data/button.dart';
import 'package:hashpass/widgets/data/copyButton.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:hashpass/widgets/interface/snackbar.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportDataPage extends StatefulWidget {
  const ImportExportDataPage({Key? key}) : super(key: key);

  @override
  _ImportExportDataPageState createState() => _ImportExportDataPageState();
}

class _ImportExportDataPageState extends HashPassState<ImportExportDataPage> {
  bool showExportProgress = false;
  final chaveEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool verifyPasswordInfoIntegrity(Password password) {
    if (password.title.contains('Decrypt failure.') ||
        password.title.contains('Failed to get string encoded:') ||
        password.basePassword.contains('Decrypt failure.') ||
        password.basePassword.contains('Failed to get string encoded:') ||
        password.credential.contains('Decrypt failure.') ||
        password.credential.contains('Failed to get string encoded:')) {
      return false;
    } else {
      return true;
    }
  }

  void dataExport() async {
    AuthAppKey.auth(
      onValidate: (key) async {
        DataExportDTO exportDTO = await HashCrypt.exportData(key);
        String filePath = '${Directory.systemTemp.path}/hashpass.txt';
        final File file = File(filePath);
        await file.writeAsString(exportDTO.fileContent);
        await Share.shareFiles([filePath]);
        HashPassMessage.show(
          body: Column(
            children: [
              HashPassLabel(
                text: appLanguage.dataExportSuccessMessage,
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
                  label: appLanguage.copyToken,
                  labelSize: 14.5,
                  widgetSize: 20,
                ),
              )
            ],
          ),
          title: appLanguage.dataExportSuccessTitle,
        );
      },
    );
  }

  Future<FilePickerResult?> getFile({
    FileType type = FileType.any,
    List<String>? types,
  }) async {
    try {
      FilePickerResult? file = await FilePicker.platform
          .pickFiles(
        dialogTitle: appLanguage.chooseImportFile,
        type: FileType.custom,
        allowedExtensions: types,
        allowMultiple: false,
      )
          .onError(
        (error, stackTrace) {
          if (error.toString().toLowerCase().contains(
                'user did not allow reading external storage',
              )) {
            HashPassMessage.show(
              message: appLanguage.fileAccessRequired,
              title: appLanguage.accessDenied,
            );
          } else {
            HashPassMessage.show(
              message: error.toString(),
              title: appLanguage.unknowErrorToOpenFile,
            );
          }
          return null;
        },
      );
      return file;
    } catch (_) {
      HashPassMessage.show(
        message: appLanguage.unknowErrorToOpenFileManager,
        title: appLanguage.errorOcurred,
      );
      return null;
    }
  }

  void dataImport(UserPasswordsProvider provider) async {
    FilePickerResult? file;
    if (Util.validateForm(formKey)) {
      AuthAppKey.auth(onValidate: (appKey) async {
        try {
          file = await getFile(type: FileType.custom, types: ['txt']);
        } catch (erro) {
          file = await getFile();
        }
        if (file != null) {
          try {
            File arquivo = File(file!.files.first.path!);
            List<String> fileLines = await arquivo.readAsLines();
            List<Password> passwords = await HashCrypt.importPasswords(
              fileLines.join(','),
              chaveEC.text,
              appKey,
            );
            for (Password password in passwords) {
              await password.save();
              provider.addPassword(password);
            }
            Get.to(const IndexPage());
            HashPassSnackBar.show(message: appLanguage.dataImportSuccessTitle);
          } on Exception catch (_) {
            HashPassMessage.show(
              message: appLanguage.dataImportErrorMessage,
              title: appLanguage.errorOcurred,
            );
          }
        } else {
          HashPassSnackBar.show(
            message: appLanguage.dataImportCanceled,
            type: SnackBarType.ERROR,
          );
        }
      });
    }
  }

  @override
  Widget localeBuild(context, language) => Consumer<UserPasswordsProvider>(
        builder: (context, provider, defaultWidget) => Scaffold(
          appBar: AppBar(
            title: Text(language.exportImportDataMenu),
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
                          visible: provider.getPasswords().isNotEmpty,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HashPassLabel(
                                text: language.dataExport,
                                fontWeight: FontWeight.bold,
                              ),
                              HashPassLabel(
                                paddingTop: 20,
                                text: language.dataExportExplanation,
                                style: Get.theme.textTheme.titleLarge,
                              ),
                              HashPassLabel(
                                paddingTop: 15,
                                text: language.doNotShareToken.toUpperCase(),
                                size: 10,
                                color: Colors.redAccent,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: AppButton(
                                  label: language.export,
                                  width: Get.size.width * .5,
                                  height: 35,
                                  onPressed: () => dataExport(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(),
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashPassLabel(
                            text: language.dataImport,
                            fontWeight: FontWeight.bold,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              language.dataImportExplanation,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: AppTextField(
                              icon: Icons.vpn_key_outlined,
                              label: language.insertExportToken,
                              padding: 0,
                              controller: chaveEC,
                              validator: HashPassValidator.empty(
                                language.emptyFieldMessage,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: AppButton(
                              label: language.import,
                              width: MediaQuery.of(context).size.width * .5,
                              height: 35,
                              onPressed: () => dataImport(provider),
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
        ),
      );
}
