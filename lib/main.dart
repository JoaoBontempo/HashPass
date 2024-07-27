import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/provider/hashPassDesktopProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/themes/dark.dart';
import 'package:hashpass/themes/light.dart';
import 'package:hashpass/view/entrance/chooseConfig.dart';
import 'package:hashpass/view/entrance/entranceSet.dart';
import 'package:hashpass/view/entrance/setFirstConfig.dart';
import 'package:hashpass/view/index.dart';
import 'package:hashpass/view/passwords.dart';
import 'package:hashpass/view/splashpage.dart';
import 'package:hashpass/view/entrance/welcomepage.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'provider/configurationProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await MobileAds.instance.initialize();
  await Configuration.getHashPassConfiguration();
  HashPassDesktopProvider.instance = HashPassDesktopProvider();
  runApp(const HashPassApp());
}

class HashPassApp extends StatelessWidget {
  const HashPassApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserPasswordsProvider()),
        ChangeNotifierProvider.value(value: Configuration.instance),
        ChangeNotifierProvider.value(value: HashPassDesktopProvider.instance),
      ],
      child: ShowCaseWidget(
        builder: (context) => Builder(
          builder: (context) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Configuration.instance.language,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            title: 'HashPass',
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
      ),
    );
  }
}
