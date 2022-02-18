import 'package:flutter/material.dart';
import 'package:hashpass/Model/senha.dart';

class Util {
  static UnderlineInputBorder bordaPadrao(Color cor) {
    return UnderlineInputBorder(
        borderSide: BorderSide(
      color: cor,
    ));
  }

  static List<Senha> senhas = <Senha>[];
}
