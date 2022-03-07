import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hashpass/View/senhas.dart';
import 'package:hashpass/Widgets/confirmdialog.dart';
import 'package:hashpass/Widgets/drawer.dart';

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
    Configuration.checarPrimeiraEntrada().then((value) {
      if (value) {
        Configuration.addCheckPrimeiraEntrada();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Tudo certo!"),
            content: const Text("Sua senha e seu e-mail foram cadastrados com sucesso. \n\nNão esqueça sua senha, "
                "pois não é possível recuperá-la! "
                "\n\nPara cadastrar uma nova senha, clique no botão ( + )  no canto inferior direito do menu principal."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
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
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          return true;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        showDialog(
          context: context,
          builder: (_) => AppConfirmDialog(
            titulo: "Fechar o aplicativo?",
            descricao: "Tem certeza que deseja sair do HashPass?",
            onAction: (confirmed) {
              if (confirmed) {
                exit(0);
              }
            },
          ),
        );
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
