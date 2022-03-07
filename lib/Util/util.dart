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

  static const String adMobAppID = 'ca-app-pub-2117228224971128~4230023543';

  static bool isInFilter = false;

  static void removePassword(Senha pswd) {
    for (int index = 0, length = senhas.length; index < length; index++) {
      if (senhas[index].id == pswd.id) {
        senhas.removeAt(index);
        return;
      }
    }
  }

  static List<CardSenhaState> teste = <CardSenhaState>[];

  static List<Senha> senhas = <Senha>[];
}
