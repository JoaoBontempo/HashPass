import 'package:hashpass/l10n/app_localizations.dart';
import 'package:get/get.dart';

enum CardStyle { DEFAULT, SIMPLE }

class HashPassCardStyle {
  CardStyle style;
  HashPassCardStyle({
    required this.style,
  });

  static final List<HashPassCardStyle> values =
      CardStyle.values.map((style) => HashPassCardStyle(style: style)).toList();

  @override
  String toString() {
    switch (style) {
      case CardStyle.SIMPLE:
        return AppLocalizations.of(Get.context!)!.simple;
      case CardStyle.DEFAULT:
        return AppLocalizations.of(Get.context!)!.default_;
    }
  }
}
