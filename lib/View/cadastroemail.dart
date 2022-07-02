import 'package:flutter/material.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Widgets/verificar_token.dart';

import '../Model/configuration.dart';

class CadastroEmailPage extends StatefulWidget {
  const CadastroEmailPage({Key? key}) : super(key: key);

  @override
  State<CadastroEmailPage> createState() => _CadastroEmailPageState();
}

class _CadastroEmailPageState extends State<CadastroEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Image.asset(
                Theme.of(context).primaryColor == AppColors.SECONDARY_DARK ? "assets/images/logo-dark.png" : "assets/images/logo-light.png",
                width: MediaQuery.of(context).size.width * .5,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Text(
                      "Quase lá!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "\nSerá necessário cadastrar um e-mail e vericá-lo para que "
                      "seja possível, se necessário, alterar sua senha geral futuramente.",
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
              VerificarTokenWidget(
                isFirstTime: true,
                onValidate: (destinatario) async {
                  bool cadastrouEmail = true;
                  if (cadastrouEmail) {
                    Navigator.pushReplacementNamed(
                      context,
                      "/index",
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
