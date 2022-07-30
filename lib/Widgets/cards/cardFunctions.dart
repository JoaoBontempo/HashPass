import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/View/passwordRegister.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import 'package:hashpass/Widgets/visualizarSenha.dart';

class PasswordCardFunctions {
  static void copyPassword(Senha password, VoidCallback onCopy) {
    getBasePassword(
      password,
      (basePassword) => {
        Clipboard.setData(ClipboardData(text: basePassword)).then((value) => onCopy()),
      },
    );
  }

  static void toUpdatePassword(Senha password, Function(Senha, int) onUpdate) {
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

  static void getBasePassword(Senha password, Function(String) onGet, {bool getRealBase = false}) async {
    ValidarSenhaGeral.show(
      onValidate: (key) async {
        if (password.criptografado && !getRealBase) {
          onGet(await HashCrypt.applyAlgorithms(
            password.algoritmo,
            password.senhaBase,
            password.avancado,
            key,
          ));
        } else {
          onGet(await HashCrypt.decipherString(password.senhaBase, key) ?? "Ocorreu um erro ao recuperar sua senha");
        }
      },
    );
  }

  static void deletePassword(Senha password, Function(int) onDelete) {
    HashPassMessage.show(
      title: "Confirmar exclusão",
      message: "Você tem certeza que deseja excluir esta senha? Esta ação não poderá ser desfeita.",
      type: MessageType.YESNO,
    ).then((action) {
      if (action == MessageResponse.YES) {
        ValidarSenhaGeral.show(
          onValidate: (key) async {
            onDelete(await SenhaDBSource().excluirSenha(password.id!));
          },
        );
      }
    });
  }

  static void showPassword(Senha password) {
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
