import 'package:flutter/material.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';

class HashPasshSplashPage extends StatefulWidget {
  const HashPasshSplashPage({Key? key}) : super(key: key);

  @override
  HashPasshSplashPageState createState() => HashPasshSplashPageState();
}

class HashPasshSplashPageState extends HashPassState<HashPasshSplashPage> {
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
    AuthAppKey.auth(
      onValidate: (password) =>
          HashPassRouteManager.to(HashPassRoute.INDEX, context),
    );
  }

  @override
  Widget localeBuild(context, language) {
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
            onPressed: authUser,
            child: HashPassLabel(
              paddingTop: 20,
              text: language.enterApp,
            ),
          ),
        ],
      ),
    );
  }
}
