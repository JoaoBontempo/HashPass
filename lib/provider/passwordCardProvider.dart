import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hashpass/dto/leakPassDTO.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/view/passwordRegister.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:hashpass/widgets/visualizarSenha.dart';

class PasswordManagerProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final credentialController = TextEditingController();
  bool enablePasswordDelete = true;
  bool isDeletingPassword = false;
  bool hidePassword = true;
  String lastText = '';

  final Password password;
  final bool isHelpExample;
  late bool isVerifiedPassword = password.leakCount == 0;
  late bool passwordHasBeenVerified = password.leakCount != -1;
  late PasswordLeakDTO leakInformation =
      PasswordLeakDTO(leakCount: password.leakCount);

  PasswordManagerProvider({
    required this.password,
    this.isHelpExample = false,
  }) {
    credentialController.text = password.credential;
    passwordController.text = password.basePassword;

    if (password.leakCount == -1) {
      _verifyPasswordLeak(savePassword: true);
    }
  }

  void _verifyPasswordLeak({bool savePassword = false}) {
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

  void copyPassword(VoidCallback onCopy) {
    getBasePassword(
      (basePassword) => {
        Clipboard.setData(ClipboardData(text: basePassword))
            .then((_) => onCopy()),
      },
    );
  }

  void toUpdatePassword(Function(Password, int) onUpdate) {
    getBasePassword(
      (basePassword) => Get.to(
        NewPasswordPage(
          password: password,
          basePassword: basePassword,
          onUpdate: (_password, code) {
            Get.back();
            notifyListeners();
          },
        ),
      ),
      getRealBase: true,
    );
  }

  void getBasePassword(
    Function(String) onGet, {
    bool getRealBase = false,
  }) async {
    AuthAppKey.auth(
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

  void deletePassword(Function(Password) onDelete) {
    HashPassMessage.show(
      title: "Confirmar exclusão",
      message:
          "Você tem certeza que deseja excluir esta senha? Esta ação não poderá ser desfeita.",
      type: MessageType.YESNO,
    ).then((action) {
      if (action == MessageResponse.YES) {
        AuthAppKey.auth(
          onValidate: (key) async {
            if (await password.delete()) onDelete(password);
          },
        );
      }
    });
  }

  void showPassword() {
    AuthAppKey.auth(
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

  void _savePassword() {
    AuthAppKey.auth(
      onValidate: (key) async {
        _setPasswordValues(key);
        await password.save();
        passwordHasBeenVerified = false;
        notifyListeners();
      },
    );
  }

  void _setPasswordValues(String appKey) async {
    password.credential = credentialController.text;
    if (password.basePassword != passwordController.text) {
      String newPassword =
          await HashCrypt.cipherString(passwordController.text, appKey);
      password.basePassword =
          await HashCrypt.cipherString(passwordController.text, appKey);
      passwordController.text = newPassword;
    }
  }

  void setAlgorithm(HashAlgorithm algorithm) {
    password.hashAlgorithm = algorithm;
    notifyListeners();
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

    if (Configuration.instance.updatePassVerify) _verifyPasswordLeak();
  }

  void restorePasswordHistory() {
    enablePasswordDelete = true;
    passwordController.text = lastText;
    passwordHasBeenVerified = (lastText.length > 4 || lastText.isNotEmpty);
    notifyListeners();
  }

  void deletePasswordFromTextField() {
    lastText = passwordController.text;
    enablePasswordDelete = false;
    passwordController.text = "";
    passwordHasBeenVerified = false;
    notifyListeners();
  }

  void updatePassword() {
    Get.focusScope!.unfocus();
    if (Util.validateForm(formKey)) {
      if (Configuration.instance.updatePassVerify && !isVerifiedPassword) {
        HashPassMessage.show(
          message: leakInformation.status == LeakStatus.LEAKED
              ? "A senha que você está tentando salvar já foi vazada! Você deseja salvá-la mesmo assim?"
              : "Não foi possível verificar sua senha, pois não há conexão com a internet. Deseja salvar sua senha mesmo assim?",
          title: leakInformation.status == LeakStatus.LEAKED
              ? "Senha vazada"
              : "Senha não verificada",
          type: MessageType.YESNO,
        ).then((action) {
          if (action == MessageResponse.YES) _savePassword();
        });
      }

      HashPassMessage.show(
        title: "Confirmar",
        message: "Tem certeza que deseja atualizar os dados desta senha?",
        type: MessageType.YESNO,
      ).then((action) {
        if (action == MessageResponse.YES) _savePassword();
      });
    }
  }
}
