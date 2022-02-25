import 'package:flutter/material.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Widgets/card_senha.dart';

class Util {
  static UnderlineInputBorder bordaPadrao(Color cor) {
    return UnderlineInputBorder(
        borderSide: BorderSide(
      color: cor,
    ));
  }

  static List<CardSenhaState> teste = <CardSenhaState>[];

  static List<Senha> senhas = <Senha>[];
}
