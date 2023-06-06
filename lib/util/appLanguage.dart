import 'dart:ui';

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
      );
}
