import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/util/appLanguage.dart';

class HashPassTheme with L10n {
  ThemeMode mode;
  HashPassTheme({
    required this.mode,
  });

  static final List<HashPassTheme> values =
      ThemeMode.values.map((mode) => HashPassTheme(mode: mode)).toList();

  static bool get isDarkMode => Get.theme.primaryColor == Colors.black;

  @override
  String toString() {
    switch (mode) {
      case ThemeMode.dark:
        return language.darkTheme;
      case ThemeMode.light:
        return language.lightTheme;
      case ThemeMode.system:
        return language.autoTheme;
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
