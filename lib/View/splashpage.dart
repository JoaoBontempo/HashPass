import 'package:flutter/material.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/View/index.dart';
import 'package:hashpass/View/welcomepage.dart';
import 'package:hashpass/Widgets/textfield.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppWelcomePage(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Autenticação necessária"),
            content: Form(
                child: AppTextField(
              label: "Senha do aplicativo:",
              padding: 10,
            )),
            actions: [
              TextButton(
                child: const Text("Validar"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndexPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_LIGHT,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo-light.png"),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
