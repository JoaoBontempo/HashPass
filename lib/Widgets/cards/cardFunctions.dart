import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import 'package:hashpass/Widgets/visualizarSenha.dart';

class PasswordCardFunctions {
  static void copyPassword(Senha password, VoidCallback onCopy) {
    ValidarSenhaGeral.show(
      onValidate: (key) {
        if (password.criptografado) {
          HashCrypt.applyAlgorithms(
            password.algoritmo,
            password.senhaBase,
            password.avancado,
            key,
          ).then((value) {
            Clipboard.setData(ClipboardData(text: value)).then((value) => onCopy());
            return;
          });
        } else {
          HashCrypt.decipherString(password.senhaBase, key).then(
            (value) {
              Clipboard.setData(ClipboardData(text: value)).then((value) => onCopy());
              return;
            },
          );
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
