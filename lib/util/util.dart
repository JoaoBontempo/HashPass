import 'package:flutter/material.dart';
import 'package:hashpass/model/password.dart';

class Util {
  static const String APP_VERSION = "1.1.0";

  static UnderlineInputBorder defaultBorder(Color cor) {
    return UnderlineInputBorder(
        borderSide: BorderSide(
      color: cor,
    ));
  }

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
      int dotAmount = numberStr.length % 2 == 0
          ? numberStr.length ~/ 3 - 1
          : numberStr.length ~/ 3;
      if (dotAmount == 0) {
        dotAmount += 1;
      }
      int firstDotIndex = numberStr.length - 3 * dotAmount;
      for (int index = 0, indexCount = 0;
          index < numberStr.length;
          index++, indexCount++) {
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

  static bool isDeleting = false;

  static List<Password> senhas = <Password>[];
}