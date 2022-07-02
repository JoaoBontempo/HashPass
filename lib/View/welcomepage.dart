import 'package:flutter/material.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/Widgets/data/button.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Image.asset(
                    Theme.of(context).primaryColor == AppColors.SECONDARY_DARK ? "assets/images/logo-dark.png" : "assets/images/logo-light.png",
                    width: MediaQuery.of(context).size.width * .5,
                  ),
                ),
                const Text(
                  "Seja bem-vindo ao HashPass!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: Text(
                    "HashPass é um aplicativo criado para guardar suas senhas de forma segura. "
                    "Para isso, será necessário criar uma senha geral para o app, pois suas senhas serão "
                    "armazenadas com criptografia simétrica, sendo assim, uma única senha é responsável "
                    "por recuperar todas suas senhas. "
                    "\n\n"
                    "Não será possível recuperar esta senha, portanto, guarde sua senha geral e "
                    "não esqueça ou compartilhe esta senha de forma alguma."
                    "\n"
                    "\nVocê poderá acessá-la com sua biometria posteriormente, caso seu dispositivo suporte esse recurso.",
                    textAlign: TextAlign.justify,
                  ),
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
                      final formValido = formKey.currentState?.validate() ?? false;
                      if (formValido) {
                        bool validacaoCriada = await Criptografia.adicionarHashValidacao(senhaEC.text);
                        if (validacaoCriada) {
                          Navigator.pushReplacementNamed(
                            context,
                            "/email",
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
