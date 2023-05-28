import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/themes/dark.dart';
import 'package:hashpass/themes/light.dart';
import 'package:hashpass/view/entrance/chooseConfig.dart';
import 'package:hashpass/view/entrance/entranceSet.dart';
import 'package:hashpass/view/entrance/setFirstConfig.dart';
import 'package:hashpass/view/index.dart';
import 'package:hashpass/view/passwords.dart';
import 'package:hashpass/view/splashpage.dart';
import 'package:hashpass/view/entrance/welcomepage.dart';
import 'package:showcaseview/showcaseview.dart';

import 'model/configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  MobileAds.instance.initialize();
  await Configuration.getHashPassConfiguration();
  runApp(const HashPassApp());
}

class HashPassApp extends StatefulWidget {
  const HashPassApp({Key? key}) : super(key: key);

  @override
  State<HashPassApp> createState() => _HashPassAppState();

  static _HashPassAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HashPassAppState>();
}

class _HashPassAppState extends State<HashPassApp> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) => GetMaterialApp(
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          title: 'Hash Pass',
          themeMode: Configuration.instance.theme.mode,
          theme: LightAppTheme(context).defaultTheme,
          darkTheme: DarkAppTheme(context).defaultTheme,
          initialRoute: "/",
          routes: {
            "/": (_) => const HashPasshSplashPage(),
            "/welcome": (_) => const AppWelcomePage(),
            "/chooseConfig": (_) => const ChooseConfigScreen(),
            "/firstConfig": (_) => const FirstConfigScreen(),
            "/setEntrance": (_) => const SetEntrancePage(),
            "/index": (_) => const IndexPage(),
            "/senhas": (_) => const PasswordsMenu(),
          },
        ),
      ),
    );
  }
}
