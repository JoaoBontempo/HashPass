import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/Themes/dark.dart';
import 'package:hashpass/Themes/light.dart';
import 'package:hashpass/View/cadastroemail.dart';
import 'package:hashpass/View/index.dart';
import 'package:hashpass/View/senhas.dart';
import 'package:hashpass/View/splashpage.dart';
import 'package:hashpass/View/welcomepage.dart';

import 'Model/configuration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    Configuration.getTema().then((value) {
      setState(() {
        _themeMode = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hash Pass',
      themeMode: _themeMode,
      theme: LightAppTheme(context).defaultTheme,
      darkTheme: DarkAppTheme(context).defaultTheme,
      initialRoute: "/",
      routes: {
        "/index": (_) => const IndexPage(),
        "/senhas": (_) => const MenuSenhas(),
        "/welcome": (_) => const AppWelcomePage(),
        "/email": (_) => const CadastroEmailPage(),
        "/": (_) => const HashPasshSplashPage(),
      },
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
