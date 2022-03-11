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

  static String formatInteger(int number) {
    String numberFormat = '';
    String numberStr = number.toString();
    if (numberStr.length > 3) {
      int dotAmount = numberStr.length % 2 == 0 ? numberStr.length ~/ 3 - 1 : numberStr.length ~/ 3;
      int firstDotIndex = numberStr.length - 3 * dotAmount;
      for (int index = 0, indexCount = 0; index < numberStr.length; index++, indexCount++) {
        if (index == firstDotIndex) {
          numberFormat += '.';
          indexCount = 0;
        }
        if (indexCount == 3) {
          numberFormat += '.';
        }
        numberFormat += numberStr[index];
      }
      return numberFormat;
    } else {
      return numberStr;
    }
  }

  static List<CardSenhaState> teste = <CardSenhaState>[];

  static List<Senha> senhas = <Senha>[];
}
