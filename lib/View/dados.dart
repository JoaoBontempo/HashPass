import 'package:flutter/material.dart';

class MenuDados extends StatefulWidget {
  const MenuDados({Key? key}) : super(key: key);

  @override
  _MenuDadosState createState() => _MenuDadosState();
}

class _MenuDadosState extends State<MenuDados> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Este é o menu de dados!"),
    );
  }
}
