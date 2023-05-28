import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/themes/colors.dart';

class HashPassTheme {
  ThemeMode mode;
  HashPassTheme({
    required this.mode,
  });

  static final List<HashPassTheme> values =
      ThemeMode.values.map((mode) => HashPassTheme(mode: mode)).toList();

  static bool get isDarkMode =>
      Get.theme.primaryColor == AppColors.SECONDARY_DARK;

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

  static Image getLogo({double? width}) {
    return Image.asset(
      HashPassTheme.isDarkMode
          ? "assets/images/logo-dark.png"
          : "assets/images/logo-light.png",
      width: width,
    );
  }
}
