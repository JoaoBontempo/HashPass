import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/Themes/theme.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Util/route.dart';
import 'package:hashpass/Util/util.dart';
import 'package:hashpass/Widgets/animations/animatedOpacityList.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacitytList(
                widgets: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: HashPassTheme.getLogo(
                      width: Get.width * 0.5,
                    ),
                  ),
                  HashPassLabel(
                    text: "Seja bem-vindo ao HashPass!",
                    fontWeight: FontWeight.bold,
                    size: 20,
                    color: Get.theme.hintColor,
                  ),
                  const WelcomeDescription(
                    description: "HashPass é um aplicativo criado para guardar suas senhas de forma segura. "
                        "Para isso, será necessário criar uma senha geral para o app, pois suas senhas serão "
                        "armazenadas com criptografia simétrica, sendo assim, uma única senha é responsável "
                        "por recuperar todas suas senhas. ",
                  ),
                  const WelcomeDescription(
                    description: "Não será possível recuperar esta senha, portanto, guarde sua senha geral e "
                        "não esqueça ou compartilhe esta senha de forma alguma.",
                  ),
                  const WelcomeDescription(
                    description: "Você poderá acessá-la com sua biometria posteriormente, caso seu dispositivo suporte esse recurso.",
                  ),
                  Form(
                    key: formKey,
                    child: AppTextField(
                      icon: FontAwesomeIcons.lock,
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
                      width: Get.size.width * .5,
                      height: 35,
                      onPressed: () async {
                        passwordTrimCompare.text = senhaEC.text.trim();
                        if (Util.validateForm(formKey)) {
                          if (await HashCrypt.adicionarHashValidacao(senhaEC.text)) {
                            HashPassRoute.to("/chooseConfig", context);
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
                duration: 750,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeDescription extends StatelessWidget {
  const WelcomeDescription({
    Key? key,
    required this.description,
  }) : super(key: key);
  final String description;

  @override
  Widget build(BuildContext context) {
    return HashPassLabel(
      text: description,
      size: 15,
      paddingTop: 15,
      paddingLeft: 20,
      paddingRight: 20,
      textAlign: TextAlign.justify,
    );
  }
}
