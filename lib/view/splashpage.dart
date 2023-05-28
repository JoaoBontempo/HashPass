import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/configuration.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/validarChave.dart';

class HashPasshSplashPage extends StatefulWidget {
  const HashPasshSplashPage({Key? key}) : super(key: key);

  @override
  HashPasshSplashPageState createState() => HashPasshSplashPageState();
}

class HashPasshSplashPageState extends State<HashPasshSplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verifyEntrance();
    });
  }

  void verifyEntrance() {
    if (!Configuration.instance.hasEntrance) {
      HashPassRouteManager.to(HashPassRoute.WELCOME, context);
    } else {
      authUser();
    }
  }

  void authUser() {
    Get.dialog(
      ValidarSenhaGeral(
        onValidate: (senha) {
          Password.findAll().then((passwords) {
            Util.senhas.addAll(passwords);
            HashPassRouteManager.to(HashPassRoute.INDEX, context);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HashPassTheme.getLogo(),
          const Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: CircularProgressIndicator(),
          ),
          TextButton(
            onPressed: () => authUser(),
            child: const HashPassLabel(
              paddingTop: 20,
              text: "Entrar no app",
            ),
          ),
        ],
      ),
    );
  }
}
