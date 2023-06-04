import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/http.dart';
import 'package:hashpass/view/configuration.dart';
import 'package:hashpass/view/importExportData.dart';
import 'package:hashpass/view/changeAppKey.dart';
import 'package:hashpass/view/passwordLeak.dart';
import 'package:hashpass/view/about.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPasswordsProvider>(
      builder: (context, passwordProvider, widget) => Drawer(
        backgroundColor: Get.theme.primaryColorLight,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: HashPassTheme.getLogo(),
              ),
            ),
            HashPassDrawerButton(
              icon: Icons.lock_outline,
              title: "Mudar senha geral",
              onTap: () {
                Get.back();
                Get.to(const ChangeAppKeyPage());
              },
            ),
            HashPassDrawerButton(
              icon: Icons.swap_vert,
              title: "Exportar/Importar dados",
              onTap: () {
                Get.back();
                Get.to(
                  ChangeNotifierProvider<UserPasswordsProvider>.value(
                    value: passwordProvider,
                    builder: ((context, child) => const ImportExportDataPage()),
                  ),
                );
              },
            ),
            HashPassDrawerButton(
              icon: Icons.security,
              title: "Verificação de vazamento",
              onTap: () async {
                if (await HTTPRequest.checkUserConnection()) {
                  Get.back();
                  Get.to(const PasswordLeakPage());
                } else {
                  HashPassMessage.show(
                      message:
                          "Não é possível utilizar a verificação de vazamento sem conexão com a internet.");
                }
              },
            ),
            HashPassDrawerButton(
              icon: Icons.settings,
              title: "Configurações",
              onTap: () {
                Get.back();
                Get.to(const ConfigurationPage());
              },
            ),
            HashPassDrawerButton(
              icon: Icons.library_books,
              title: "Política de privacidade",
              onTap: () => launch(
                  "https://joaobontempo.github.io/HashPassWebsite/hashpass-website/"),
            ),
            HashPassDrawerButton(
              icon: Icons.info_outline,
              title: "Sobre",
              onTap: () {
                Get.back();
                Get.to(const AboutPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HashPassDrawerButton extends StatelessWidget {
  const HashPassDrawerButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Get.theme.textTheme.bodyText2?.color,
      ),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}
