import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/dto/leakPassDTO.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:hashpass/widgets/interface/snackbar.dart';

abstract class PasswordProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final credentialController = TextEditingController();
  bool enablePasswordDelete = true;
  bool isDeletingPassword = false;
  bool hidePassword = true;
  late PasswordLeakDTO leakInformation =
      PasswordLeakDTO(leakCount: password.leakCount);
  final Password password;
  late bool isVerifiedPassword = password.leakCount == 0;
  late bool passwordHasBeenVerified = password.leakCount != -1;

  PasswordProvider(this.password);

  @protected
  void verifyPasswordLeak({bool savePassword = false}) {
    HashCrypt.verifyPassowordLeak(password.basePassword).then(
      (response) {
        password.leakCount = response.leakCount;
        leakInformation = response;
        passwordHasBeenVerified = true;
        isVerifiedPassword = response.leakCount == 0;

        if (savePassword) password.save();
        notifyListeners();
      },
    );
  }

  void handlePasswordTextFieldChanges(String text) {
    enablePasswordDelete = !(text.isEmpty || text.trim() == '');
    if (!enablePasswordDelete || text.length < 4) {
      isDeletingPassword = true;
      passwordHasBeenVerified = false;
      notifyListeners();
      return;
    } else {
      isDeletingPassword = false;
    }

    if (Configuration.instance.updatePassVerify) verifyPasswordLeak();
  }

  void setAlgorithm(HashAlgorithm algorithm) {
    password.hashAlgorithm = algorithm;
    notifyListeners();
  }

  void setAdvanced(bool isAdvanced) {
    password.isAdvanced = isAdvanced;
    notifyListeners();
  }

  void setUseCriptography(bool useCriptography) {
    password.useCriptography = useCriptography;
    notifyListeners();
  }

  void changePasswordVisibility() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  void deletePassword(UserPasswordsProvider userPasswordsProvider) {
    HashPassMessage.show(
      title: "Confirmar exclusão",
      message:
          "Você tem certeza que deseja excluir esta senha? Esta ação não poderá ser desfeita.",
      type: MessageType.YESNO,
    ).then((action) {
      if (action == MessageResponse.YES) {
        AuthAppKey.auth(
          onValidate: (key) async {
            if (await password.delete()) {
              userPasswordsProvider.removePassword(password);
              HashPassSnackBar.show(message: 'Senha excluída com sucesso!');
            } else {
              HashPassSnackBar.show(
                message: 'Ocorreu um erro ao excluir a senha',
                type: SnackBarType.ERROR,
              );
            }
          },
        );
      }
    });
  }

  void savePassword(BuildContext context) async {
    if (await validatePassword()) {
      AuthAppKey.auth(
        onValidate: (key) async {
          await password.save();
          notifyListeners();
        },
      );
    }
  }

  Future<bool> validatePassword() async {
    Get.focusScope!.unfocus();
    if (Util.validateForm(formKey)) {
      if (Configuration.instance.updatePassVerify && !isVerifiedPassword) {
        MessageResponse userAction = await HashPassMessage.show(
          message: leakInformation.status == LeakStatus.LEAKED
              ? "A senha que você está tentando salvar já foi vazada! Você deseja salvá-la mesmo assim?"
              : "Não foi possível verificar sua senha, pois não há conexão com a internet. Deseja salvar sua senha mesmo assim?",
          title: leakInformation.status == LeakStatus.LEAKED
              ? "Senha vazada"
              : "Senha não verificada",
          type: MessageType.YESNO,
        );

        return userAction == MessageResponse.YES;
      }

      if (password.isNew) {
        MessageResponse userAction = await HashPassMessage.show(
          title: "Confirmar",
          message: "Tem certeza que deseja atualizar os dados desta senha?",
          type: MessageType.YESNO,
        );

        return userAction == MessageResponse.YES;
      }

      return true;
    } else {
      return Future(() => false);
    }
  }
}
