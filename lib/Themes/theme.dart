import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Themes/colors.dart';

class HashPassTheme {
  ThemeMode mode;
  HashPassTheme({
    required this.mode,
  });

  static final List<HashPassTheme> values = ThemeMode.values.map((mode) => HashPassTheme(mode: mode)).toList();
  static final bool isDarkMode = Get.theme.primaryColor == AppColors.SECONDARY_DARK;

  @override
  String toString() {
    switch (mode) {
      case ThemeMode.dark:
        return "Escuro";
      case ThemeMode.light:
        return "Padrão";
      case ThemeMode.system:
        return "Automático (Sistema)";
    }
  }
}
