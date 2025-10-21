import 'package:flutter/material.dart';
import 'package:hashpass/l10n/app_localizations.dart';
import 'package:get/get.dart';

class HashPassStatelessWidget extends StatelessWidget {
  const HashPassStatelessWidget({super.key});

  AppLocalizations get appLanguage => AppLocalizations.of(Get.context!)!;

  Widget localeBuild(BuildContext context, AppLocalizations language) =>
      const Placeholder();

  @override
  Widget build(BuildContext context) =>
      localeBuild(context, AppLocalizations.of(context)!);
}

class HashPassState<HashPassWidget extends StatefulWidget>
    extends State<HashPassWidget> {
  AppLocalizations get appLanguage => AppLocalizations.of(Get.context!)!;
  Widget localeBuild(BuildContext context, AppLocalizations language) =>
      const Placeholder();

  @override
  Widget build(BuildContext context) =>
      localeBuild(context, AppLocalizations.of(context)!);
}
