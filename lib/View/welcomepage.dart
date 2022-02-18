import 'package:flutter/material.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/View/index.dart';
import 'package:hashpass/Widgets/button.dart';
import 'package:hashpass/Widgets/textfield.dart';
import 'package:validatorless/validatorless.dart';

class AppWelcomePage extends StatefulWidget {
  const AppWelcomePage({Key? key}) : super(key: key);

  @override
  _AppWelcomePageState createState() => _AppWelcomePageState();
}

class _AppWelcomePageState extends State<AppWelcomePage> {
  final senhaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.PRIMARY_LIGHT,
        body: Column(
          children: [
            Image.asset(
              "assets/images/logo-light.png",
              width: MediaQuery.of(context).size.width * .5,
            ),
            const Text("Seja bem-vindo ao HashPass!"),
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Text(
                "HashPass é um aplicativo criado para guardar suas senhas de forma segura! "
                "Para isso, será necessário criar uma senha geral do aplicativo, pois suas senhas serão "
                "armazenadas com criptografia simétrica, sendo assim, uma única senha geral é responsável "
                "por recuperar todas suas senhas! "
                "\n\n"
                "Não será possível recuperar esta senha, portanto, guarde sua senha geral e,"
                "não esqueça ou compartilhe esta senha de forma alguma!"
                "\n"
                "\nVocê poderá acessá-las com sua digital posteriormente, caso prefira!",
                textAlign: TextAlign.justify,
              ),
            ),
            Form(
              key: formKey,
              child: AppTextField(
                label: "Informe uma senha geral",
                padding: 20,
                validator: Validatorless.required("Este campo não pode estar vazio"),
                controller: senhaEC,
              ),
            ),
            AppButton(
              label: "Continuar",
              width: MediaQuery.of(context).size.width * .5,
              height: 35,
              onPressed: () async {
                final formValido = formKey.currentState?.validate() ?? false;
                if (formValido) {
                  bool isAdicionada = await Configuration.adicionarPrimeiraChave(senhaEC.text);
                  if (isAdicionada) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndexPage(),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ));
  }
}
