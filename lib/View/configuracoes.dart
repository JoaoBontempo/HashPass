import 'package:flutter/material.dart';

class MenuConfiguracoes extends StatefulWidget {
  const MenuConfiguracoes({Key? key}) : super(key: key);

  @override
  _MenuConfiguracoesState createState() => _MenuConfiguracoesState();
}

class _MenuConfiguracoesState extends State<MenuConfiguracoes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Este é o menu de configurações!"),
    );
  }
}
