import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Themes/theme.dart';
import 'package:hashpass/Util/route.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import '../Database/datasource.dart';
import '../Util/util.dart';

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
      Configuration.setDefaultConfig();
      HashPassRoute.to("/welcome", context);
    } else {
      authUser();
    }
  }

  void authUser() {
    Get.dialog(
      ValidarSenhaGeral(
        onValidate: (senha) {
          SenhaDBSource().getTodasSenhas().then((senhas) {
            Util.senhas.addAll(senhas);
            HashPassRoute.to("/index", context);
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
          const CircularProgressIndicator(),
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
