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
        (language) => language.locale.countryCode == locale.countryCode,
        orElse: () => HashPassLanguage.ENGLISH_US,
      );
}

class l10nClass {
  AppLocalizations get language => AppLocalizations.of(Get.context!)!;
}
