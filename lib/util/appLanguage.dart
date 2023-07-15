import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

enum HashPassLanguage {
  ENGLISH_US('English (US)', Locale('en', 'US')),
  PORTUGUESE_BRAZIL('Português (Brasil)', Locale('pt', 'BR'));

  final String description;
  final Locale locale;

  const HashPassLanguage(this.description, this.locale);

  @override
  String toString() => description;

  static HashPassLanguage fromLocale(Locale locale) =>
      HashPassLanguage.values.firstWhere(
        (language) => language.locale.languageCode == locale.languageCode,
        orElse: () => HashPassLanguage.ENGLISH_US,
      );
}

class L10n {
  AppLocalizations get language => AppLocalizations.of(Get.context!)!;
  static AppLocalizations get appLanguage => AppLocalizations.of(Get.context!)!;
}
