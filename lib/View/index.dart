import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hashpass/View/senhas.dart';
import 'package:hashpass/Widgets/drawer.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';

import '../Model/configuration.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int paginaAtual = 0;
  bool isDrawerOpen = false;

  @override
  void initState() {
    if (!Configuration.instance.hasEntrance) {
      HashPassMessage.show(
        title: "Tudo certo!",
        message: "Sua senha geral do HashPass foi cadastrada com sucesso!. \n\nNão esqueça sua senha geral, "
            "pois não é possível recuperá-la! "
            "\n\n"
            "Para cadastrar uma nova senha, clique no botão ( + )  no canto inferior direito do menu principal.",
      );
      Configuration.setConfigs(entrance: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          return true;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        HashPassMessage.show(
          title: "Fechar o aplicativo?",
          message: "Tem certeza que deseja sair do HashPass?",
          type: MessageType.YESNO,
        ).then((action) {
          if (action == MessageResponse.YES) {
            exit(0);
          }
        });
        return false;
      },
      child: Scaffold(
        onDrawerChanged: (isOn) {
          FocusManager.instance.primaryFocus?.unfocus();
          isDrawerOpen = isOn;
        },
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Minhas senhas"),
        ),
        body: const MenuSenhas(),
      ),
    );
  }
}
