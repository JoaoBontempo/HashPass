import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/DTO/leakPassDTO.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Util/http.dart';
import 'package:hashpass/Util/util.dart';
import 'package:hashpass/Widgets/animations/booleanHide.dart';
import 'package:hashpass/Widgets/data/button.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:hashpass/Widgets/leakPassMessage.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
import 'package:validatorless/validatorless.dart';

class PasswordLeakPage extends StatefulWidget {
  const PasswordLeakPage({Key? key}) : super(key: key);

  @override
  State<PasswordLeakPage> createState() => _PasswordLeakPageState();
}

class _PasswordLeakPageState extends State<PasswordLeakPage> {
  final passwordEC = TextEditingController();
  late LeakStatus lastStatus;
  bool showMessage = false;
  late PasswordLeakDTO passwordInfo;
  String lastPass = '';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    passwordInfo = PasswordLeakDTO(leakCount: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar senha'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const HashPassLabel(
                  text: 'Informe uma senha para que ela seja verificada '
                      'em bases de dados de senhas que já foram vazadas na internet. ',
                  textAlign: TextAlign.justify,
                  paddingBottom: 20,
                ),
                AppTextField(
                  icon: Icons.lock_outline,
                  label: 'Digite a senha ',
                  obscureText: true,
                  controller: passwordEC,
                  validator: Validatorless.required('Nenhuma senha foi informada'),
                  padding: 0,
                  onChange: (text) => setState(() {
                    showMessage = false;
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: AnimatedBooleanContainer(
                    show: showMessage,
                    child: PasswordLeakMessage(
                      passwordInfo: passwordInfo,
                    ),
                  ),
                ),
                AppButton(
                  label: 'Verificar senha',
                  width: Get.size.width * .5,
                  height: 35,
                  onPressed: () async {
                    if (Util.validateForm(formKey)) {
                      if (!await HTTPRequest.checkUserConnection()) {
                        HashPassMessage.show(
                          message: "Não foi possível verificar sua conexão de internet",
                          title: "Ocorreu um erro",
                        );

                        setState(() {
                          showMessage = false;
                        });
                        return;
                      }
                      if (lastPass == passwordEC.text && lastStatus != LeakStatus.FAILURE) {
                        return;
                      }
                      lastPass = passwordEC.text;

                      PasswordLeakDTO response = await HashCrypt.verifyPassowordLeak(passwordEC.text.trim());
                      lastStatus = response.status;

                      setState(() {
                        showMessage = true;
                        passwordInfo = response;
                      });
                    } else {
                      setState(() {
                        showMessage = false;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
