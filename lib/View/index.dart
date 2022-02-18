import 'package:flutter/material.dart';
import 'package:hashpass/View/configuracoes.dart';
import 'package:hashpass/View/dados.dart';
import 'package:hashpass/View/senhas.dart';
import 'package:hashpass/Widgets/bottom_navigation.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int paginaAtual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HashPass - Suas senhas com criptografia!"),
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
        children: [
          MenuSenhas(),
          MenuConfiguracoes(),
          MenuDados(),
        ],
      ),
    );
  }
}
