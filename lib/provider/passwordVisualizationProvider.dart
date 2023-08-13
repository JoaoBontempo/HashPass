import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/ads.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordVisualizationProvider extends ChangeNotifier {
  final Password password;
  final String appKey;
  final BuildContext context;

  late bool existsCredential = password.credential.isNotEmpty;
  bool isBannerLoaded = false;
  bool isVideoLoaded = false;
  bool isAdLoaded = false;
  bool hasAd = false;
  String realPassword = '';
  double currentTimeProgress = 0;
  double totalShowTime = Configuration.instance.showPasswordTime;
  double timeCount = Configuration.instance.showPasswordTime;

  late Timer time;
  late BannerAd bannerAd;
  late InterstitialAd videoAd;

  PasswordVisualizationProvider({
    required this.password,
    required this.appKey,
    required this.context,
  }) {
    AdsHelper.getAdType().then((adType) {
      switch (adType) {
        case ADType.BANNER:
          bannerAd = BannerAd(
            size: AdSize.mediumRectangle,
            adUnitId: ADType.BANNER.id,
            listener: BannerAdListener(onAdLoaded: (ad) {
              isBannerLoaded = true;
            }, onAdFailedToLoad: (ad, error) {
              isBannerLoaded = false;
              ad.dispose();
            }),
            request: const AdRequest(),
          )..load().then((value) {
              _initPasswordDialog();
            });
          break;
        case ADType.VIDEO:
          InterstitialAd.load(
            adUnitId: ADType.VIDEO.id,
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: videoAdLoaded,
              onAdFailedToLoad: (error) {},
            ),
          );
          break;
        case ADType.NONE:
          _initPasswordDialog();
          break;
        default:
          break;
      }
    });
  }

  void _initPasswordDialog() {
    isAdLoaded = true;
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

  void videoAdLoaded(InterstitialAd ad) {
    ad.show();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _initPasswordDialog();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _initPasswordDialog();
      },
    );
  }

  void closeModal() {
    if (Configuration.instance.hasTimer) {
      time.cancel();
    }
    Get.back();
  }
}
