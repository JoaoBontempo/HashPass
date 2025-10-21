import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hashpass/l10n/app_localizations.dart';

class HashPassProvider extends ChangeNotifier {
  @protected
  AppLocalizations get language => AppLocalizations.of(Get.context!)!;
}
