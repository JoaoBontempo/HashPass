import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/view/passwordRegister.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:hashpass/widgets/validarChave.dart';
import 'package:hashpass/widgets/visualizarSenha.dart';

class PasswordCardFunctions {
  static void copyPassword(Password password, VoidCallback onCopy) {
    getBasePassword(
      password,
      (basePassword) => {
        Clipboard.setData(ClipboardData(text: basePassword))
            .then((value) => onCopy()),
      },
    );
  }

  static void toUpdatePassword(
      Password password, Function(Password, int) onUpdate) {
    getBasePassword(
      password,
      (basePassword) => Get.to(
        NewPasswordPage(
          password: password,
          basePassword: basePassword,
          onUpdate: (_password, code) {
            onUpdate(_password, code);
            Get.back();
          },
        ),
      ),
      getRealBase: true,
    );
  }

  static void getBasePassword(Password password, Function(String) onGet,
      {bool getRealBase = false}) async {
    ValidarSenhaGeral.show(
      onValidate: (key) async {
        if (password.useCriptography && !getRealBase) {
          onGet(await HashCrypt.applyAlgorithms(
            password.hashAlgorithm,
            password.basePassword,
            password.isAdvanced,
            key,
          ));
        } else {
          onGet(await HashCrypt.decipherString(password.basePassword, key) ??
              "Ocorreu um erro ao recuperar sua senha");
        }
      },
    );
  }

  static void deletePassword(Password password, Function(Password) onDelete) {
    HashPassMessage.show(
      title: "Confirmar exclusão",
      message:
          "Você tem certeza que deseja excluir esta senha? Esta ação não poderá ser desfeita.",
      type: MessageType.YESNO,
    ).then((action) {
      if (action == MessageResponse.YES) {
        ValidarSenhaGeral.show(
          onValidate: (key) async {
            if (await password.delete()) onDelete(password);
          },
        );
      }
    });
  }

  static void showPassword(Password password) {
    ValidarSenhaGeral.show(
      onValidate: (key) {
        Get.dialog(
          VisualizacaoSenhaModal(
            chaveGeral: key,
            senha: password,
            copyIconColor: Get.theme.hintColor,
          ),
        );
      },
    );
  }
}
