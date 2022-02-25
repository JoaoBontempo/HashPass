import 'package:flutter/material.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Widgets/validarChave.dart';

import '../Database/datasource.dart';
import '../Themes/colors.dart';
import '../Util/util.dart';

class HashPasshSplashPage extends StatefulWidget {
  const HashPasshSplashPage({Key? key}) : super(key: key);

  @override
  HashPasshSplashPageState createState() => HashPasshSplashPageState();
}

class HashPasshSplashPageState extends State<HashPasshSplashPage> {
  @override
  void initState() {
    Configuration.checarPrimeiraEntrada().then((value) {
      if (value) {
        Configuration.setDefaultConfig();
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/welcome",
          (_) => false,
        );
      } else {
        Configuration.getConfigs();
        Configuration.printConfigs();
        showDialog(
          context: context,
          builder: (_) => ValidarSenhaGeral(
            onValidate: (senha) {
              Navigator.of(context).pop();
              SenhaDBSource().getTodasSenhas().then((value) {
                Util.senhas.addAll(value);
                Navigator.pushReplacementNamed(
                  context,
                  "/index",
                );
              });
            },
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Theme.of(context).primaryColor == AppColors.SECONDARY_DARK ? "assets/images/logo-dark.png" : "assets/images/logo-light.png",
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
