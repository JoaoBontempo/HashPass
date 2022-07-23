import 'package:flutter/material.dart';

import '../Util/util.dart';

class PasswordLeakDTO {
  int leakCount;
  PasswordLeakDTO({
    required this.leakCount,
  });

  Widget getLeakWidget({double? size}) {
    Icon icon = _getIcon(size);

    return Tooltip(
      margin: const EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      triggerMode: TooltipTriggerMode.tap,
      height: 20,
      showDuration: const Duration(seconds: 5),
      message: message,
      child: icon,
      textStyle: TextStyle(
        color: _textColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      decoration: BoxDecoration(
        color: icon.color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Icon _getIcon(double? size) {
    return leakCount == -1
        ? Icon(
            Icons.warning,
            color: Colors.yellowAccent,
            size: size,
          )
        : leakCount == 0
            ? Icon(
                Icons.verified_user,
                size: size,
                color: Colors.greenAccent,
              )
            : Icon(
                Icons.warning,
                size: size,
                color: Colors.redAccent,
              );
  }

  LeakStatus get status => leakCount == 0
      ? LeakStatus.VERIFIED
      : leakCount == -1
          ? LeakStatus.FAILURE
          : LeakStatus.LEAKED;

  Color get _textColor => leakCount > 0 ? Colors.white : Colors.black;

  String get message => leakCount == -1
      ? "Não foi possível verificar sua senha. Verifique sua conexão de internet."
      : leakCount == 0
          ? 'Sua senha tem grandes chances de não ter sido vazada!'
          : leakCount == 1
              ? 'Esta senha foi vazada pelo menos uma vez!'
              : 'Esta senha foi vazada pelo menos ${Util.formatInteger(leakCount)} vezes!';
}

enum LeakStatus { LEAKED, VERIFIED, FAILURE }
