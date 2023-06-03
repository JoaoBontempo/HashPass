import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/widgets/animations/animatedOpacityList.dart';
import 'package:hashpass/widgets/data/button.dart';
import 'package:hashpass/widgets/data/checkBox.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool privacyPolicy = false;

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
                    description:
                        "HashPass é um aplicativo criado para guardar suas senhas de forma segura. "
                        "Para isso, será necessário criar uma senha geral para o app, pois suas senhas serão "
                        "armazenadas com criptografia simétrica, sendo assim, uma única senha é responsável "
                        "por recuperar todas suas senhas. ",
                  ),
                  const WelcomeDescription(
                    description:
                        "Não será possível recuperar esta senha, portanto, guarde sua senha geral e "
                        "não esqueça ou compartilhe esta senha de forma alguma.",
                  ),
                  const WelcomeDescription(
                    description:
                        "Você poderá acessá-la com sua biometria posteriormente, caso seu dispositivo suporte esse recurso.",
                  ),
                  Form(
                    key: formKey,
                    child: AppTextField(
                      icon: Icons.lock_outline,
                      label: "Informe uma senha geral",
                      maxLength: 50,
                      padding: 20,
                      validator: Validatorless.multiple([
                        HashPassValidator.empty(
                            "Este campo não pode estar vazio"),
                        Validatorless.compare(passwordTrimCompare,
                            "A senha não pode conter espaços"),
                        Validatorless.min(
                            4, "A senha deve ter no mínimo 4 caracteres!"),
                      ]),
                      controller: senhaEC,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: HashPassCheckBox(
                      onChange: (checked) => setState(() {
                        privacyPolicy = checked;
                      }),
                      value: privacyPolicy,
                      customLabel: Row(
                        children: [
                          const HashPassLabel(
                            text: "Concordo com os termos da ",
                            size: 12,
                          ),
                          GestureDetector(
                            child: HashPassLabel(
                                text: "Política de privacidade",
                                color: Get.theme.highlightColor,
                                size: 12),
                            onTap: () => launch(
                                "https://joaobontempo.github.io/HashPassWebsite/hashpass-website/"),
                          )
                        ],
                      ),
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
                        if (!privacyPolicy) {
                          HashPassMessage.show(
                            title: "Política de privacidade",
                            message:
                                "Para continuar, é necessário concordar com os termos da política de privacidade do aplicativo.",
                            type: MessageType.OK,
                          );
                        } else {
                          passwordTrimCompare.text = senhaEC.text.trim();
                          if (Util.validateForm(formKey)) {
                            if (await HashCrypt.setGeneralKeyValidationMessage(
                                senhaEC.text)) {
                              HashPassRouteManager.to(
                                  HashPassRoute.CHOOSE_CONFIGURATION, context);
                            } else {
                              HashPassMessage.show(
                                message:
                                    "Um erro desconhecido ocorreu ao cadastrar sua senha geral. Por favor, tente novamente.",
                                title: "Ocorreu um erro",
                              );
                            }
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