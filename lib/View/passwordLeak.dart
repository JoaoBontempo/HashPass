import 'package:flutter/material.dart';
import 'package:hashpass/DTO/leakPassDTO.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Util/util.dart';
import 'package:hashpass/Widgets/data/button.dart';
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
  bool showMessage = false;
  late PasswordLeakDTO passwordInfo;
  String lastPass = '';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    passwordInfo = PasswordLeakDTO(message: 'Sua senha tem grandes chances de não ter sido vazada!', leakCount: 0);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'Informe uma senha para que ela seja verificada '
                  'em bases de dados de senhas que já foram vazadas na internet. ',
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppTextField(
                  label: 'Digite a senha ',
                  obscureText: true,
                  controller: passwordEC,
                  validator: Validatorless.required('Nenhuma senha foi informada'),
                  padding: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Visibility(
                  visible: showMessage,
                  child: PasswordLeakMessage(
                    passwordInfo: passwordInfo,
                  ),
                ),
              ),
              AppButton(
                label: 'Verificar senha',
                width: MediaQuery.of(context).size.width * .5,
                height: 35,
                onPressed: () async {
                  if (Util.validateForm(formKey)) {
                    if (lastPass == passwordEC.text) {
                      return;
                    }
                    lastPass = passwordEC.text;
                    PasswordLeakDTO response = await HashCrypt.verifyPassowordLeak(passwordEC.text);
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
    );
  }
}