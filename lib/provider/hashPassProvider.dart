import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class HashPassProvider extends ChangeNotifier {
  @protected
  AppLocalizations get language => AppLocalizations.of(Get.context!)!;
}
