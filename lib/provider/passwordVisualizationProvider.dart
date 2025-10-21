import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/security/cryptography.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordVisualizationProvider extends ChangeNotifier {
  final Password password;
  final String appKey;
  final BuildContext context;

  late bool existsCredential = password.credential.isNotEmpty;
  String realPassword = '';
  double currentTimeProgress = 0;
  double totalShowTime = Configuration.instance.showPasswordTime;
  double timeCount = Configuration.instance.showPasswordTime;

  late Timer time;

  PasswordVisualizationProvider({
    required this.password,
    required this.appKey,
    required this.context,
  }) {
    _initPasswordDialog();
  }

  void _initPasswordDialog() {
    notifyListeners();
    if (password.useCriptography) {
      HashCrypt.applyAlgorithms(
        password.hashAlgorithm,
        password.basePassword,
        password.isAdvanced,
        appKey,
      ).then((value) {
        realPassword = value;
        notifyListeners();
      });
    } else {
      HashCrypt.decipherString(
        password.basePassword,
        appKey,
      ).then(
        (value) {
          realPassword = value ??
              AppLocalizations.of(context)?.decipherFailure ??
              'An error ocurred. Please, try again.';
          notifyListeners();
        },
      );
    }

    if (Configuration.instance.hasTimer) {
      time = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (timeCount > 0) {
            currentTimeProgress += 1 / totalShowTime;
            timeCount -= 1;
            notifyListeners();
          }
          if (currentTimeProgress >= 0.99) {
            Navigator.of(context, rootNavigator: true).pop();
            time.cancel();
          }
        },
      );
    }
  }

  void closeModal() {
    if (Configuration.instance.hasTimer) {
      time.cancel();
    }
    Get.back();
  }
}
