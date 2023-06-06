import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        return AppLocalizations.of(Get.context!)?.darkTheme ?? 'Dark';
      case ThemeMode.light:
        return AppLocalizations.of(Get.context!)?.lightTheme ?? 'Light';
      case ThemeMode.system:
        return AppLocalizations.of(Get.context!)?.autoTheme ?? 'Default';
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
