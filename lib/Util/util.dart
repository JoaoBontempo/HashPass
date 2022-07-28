import 'package:flutter/material.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Widgets/cardSenha.dart';

class Util {
  static const String APP_VERSION = "1.1.0";
  static const int SQL_VERSION = 3;

  static UnderlineInputBorder bordaPadrao(Color cor) {
    return UnderlineInputBorder(
        borderSide: BorderSide(
      color: cor,
    ));
  }

  static const String adMobAppID = 'ca-app-pub-2117228224971128~4230023543';

  static Icon get visiblePasswordIcon => Icon(
        Icons.visibility,
        color: Colors.grey.shade400,
      );

  static Icon get notVisiblePasswordIcon => Icon(
        Icons.visibility_off,
        color: Colors.grey.shade400,
      );

  static const Icon leakedIcon = Icon(
    Icons.warning,
    color: Colors.redAccent,
    size: 16,
  );

  static const Icon notLeakedIcon = Icon(
    Icons.verified_user,
    color: Colors.greenAccent,
    size: 16,
  );

  static bool isInFilter = false;

  static String formatInteger(int number) {
    String numberFormat = '';
    String numberStr = number.toString();
    if (numberStr.length > 3) {
      int dotAmount = numberStr.length % 2 == 0 ? numberStr.length ~/ 3 - 1 : numberStr.length ~/ 3;
      if (dotAmount == 0) {
        dotAmount += 1;
      }
      int firstDotIndex = numberStr.length - 3 * dotAmount;
      debugPrint('DotAmount: $dotAmount | FirstDot: $firstDotIndex | Number: $number');
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

  static bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  static List<CardSenhaState> teste = <CardSenhaState>[];

  static List<Senha> senhas = <Senha>[];
}
