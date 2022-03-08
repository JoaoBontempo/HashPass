import 'package:flutter/material.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/View/change_mail.dart';
import 'package:hashpass/View/configuracoes.dart';
import 'package:hashpass/View/dados.dart';
import 'package:hashpass/View/index.dart';
import 'package:hashpass/View/mudarsenha.dart';
import 'package:hashpass/View/password_leak.dart';
import 'package:hashpass/View/sobre.dart';

import '../Themes/colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColorLight,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                Theme.of(context).primaryColor == AppColors.SECONDARY_DARK ? "assets/images/logo-dark.png" : "assets/images/logo-back-light.png",
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.lock_outline,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
            title: const Text('Mudar senha do app'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MudarSenhaPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mail_outline,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
            title: const Text('Alterar e-mail'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeMailView(
                    onMailChanged: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "E-mail alterado com sucesso!",
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.greenAccent,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.swap_vert,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
            title: const Text('Exportar/Importar dados'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuDados(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.security,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
            title: const Text('Verificação de vazamento'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PasswordLeakPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuConfiguracoes(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
            title: const Text('Sobre'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SobreAppPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
