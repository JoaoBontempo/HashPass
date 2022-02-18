import 'package:flutter/material.dart';
import 'package:hashpass/View/configuracoes.dart';
import 'package:hashpass/View/dados.dart';
import 'package:hashpass/View/senhas.dart';
import 'package:hashpass/Widgets/bottom_navigation.dart';

import '../Model/configuration.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int paginaAtual = 0;

  @override
  void initState() {
    Configuration.checarPrimeiraEntrada().then((value) {
      if (value) {
        Configuration.addCheckPrimeiraEntrada();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Chave cadastrada!"),
            content: const Text("Sua chave foi cadastrada com sucesso! Não esqueça-a, "
                "pois não é possível recuperá-la! "
                "\n\nPara cadastrar uma nova senha, clique no botão '+' no canto inferior direito no menu 'Minhas senhas'"),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("HashPass - Suas senhas com criptografia!"),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: AppBottomNavgation(
        onItemSelected: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
      ),
      body: IndexedStack(
        index: paginaAtual,
        children: const [
          MenuSenhas(),
          MenuConfiguracoes(),
          MenuDados(),
        ],
      ),
    );
  }
}
