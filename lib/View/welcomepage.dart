import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Themes/theme.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Util/route.dart';
import 'package:hashpass/Util/util.dart';
import 'package:hashpass/Widgets/data/button.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:validatorless/validatorless.dart';

class AppWelcomePage extends StatefulWidget {
  const AppWelcomePage({Key? key}) : super(key: key);

  @override
  _AppWelcomePageState createState() => _AppWelcomePageState();
}

class _AppWelcomePageState extends State<AppWelcomePage> {
  final senhaEC = TextEditingController();
  final passwordTrimCompare = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: HashPassTheme.getLogo(
                  width: Get.width * 0.5,
                ),
              ),
              const HashPassLabel(
                text: "Seja bem-vindo ao HashPass!",
                size: 20,
              ),
              const HashPassLabel(
                text: "HashPass é um aplicativo criado para guardar suas senhas de forma segura. "
                    "Para isso, será necessário criar uma senha geral para o app, pois suas senhas serão "
                    "armazenadas com criptografia simétrica, sendo assim, uma única senha é responsável "
                    "por recuperar todas suas senhas. "
                    "\n\n"
                    "Não será possível recuperar esta senha, portanto, guarde sua senha geral e "
                    "não esqueça ou compartilhe esta senha de forma alguma."
                    "\n"
                    "\nVocê poderá acessá-la com sua biometria posteriormente, caso seu dispositivo suporte esse recurso.",
                paddingTop: 15,
                paddingLeft: 20,
                paddingRight: 20,
                textAlign: TextAlign.justify,
              ),
              Form(
                key: formKey,
                child: AppTextField(
                  label: "Informe uma senha geral",
                  padding: 20,
                  validator: Validatorless.multiple([
                    Validatorless.required("Este campo não pode estar vazio"),
                    Validatorless.compare(passwordTrimCompare, "A senha não pode conter espaços")
                  ]),
                  controller: senhaEC,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 25,
                ),
                child: AppButton(
                  label: "Continuar",
                  width: MediaQuery.of(context).size.width * .5,
                  height: 35,
                  onPressed: () async {
                    passwordTrimCompare.text = senhaEC.text.trim();
                    if (Util.validateForm(formKey)) {
                      if (await HashCrypt.adicionarHashValidacao(senhaEC.text)) {
                        HashPassRoute.to("/index", context);
                      } else {
                        HashPassMessage.show(
                          message: "Um erro desconhecido ocorreu ao cadastrar sua senha geral. Por favor, tente novamente.",
                          title: "Ocorreu um erro",
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
    );
  }
}
