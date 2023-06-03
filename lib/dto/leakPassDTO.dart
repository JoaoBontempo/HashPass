import 'package:flutter/material.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/util.dart';

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
      textStyle: TextStyle(
        color: _textColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      decoration: BoxDecoration(
        color: icon.color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: icon,
    );
  }

  Icon _getIcon(double? size) {
    return leakCount == LeakStatus.FAILURE.count
        ? Icon(
            Icons.warning,
            color: HashPassTheme.isDarkMode
                ? Colors.yellowAccent
                : Colors.yellow.shade700,
            size: size,
          )
        : leakCount == LeakStatus.VERIFIED.count
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

  LeakStatus get status => leakCount == LeakStatus.VERIFIED.count
      ? LeakStatus.VERIFIED
      : leakCount == LeakStatus.FAILURE.count
          ? LeakStatus.FAILURE
          : LeakStatus.LEAKED;

  Color get _textColor => leakCount > 0 ? Colors.white : Colors.black;

  String get message => leakCount == LeakStatus.FAILURE.count
      ? "Não foi possível verificar sua senha. Verifique sua conexão de internet ou tente novamente."
      : leakCount == LeakStatus.VERIFIED.count
          ? 'Sua senha tem grandes chances de não ter sido vazada!'
          : leakCount == 1
              ? 'Esta senha foi vazada pelo menos uma vez!'
              : 'Esta senha foi vazada pelo menos ${Util.formatInteger(leakCount)} vezes!';
}

enum LeakStatus {
  LEAKED(1),
  VERIFIED(0),
  FAILURE(-1);

  final int count;
  const LeakStatus(this.count);
}