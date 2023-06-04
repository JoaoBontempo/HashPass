import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/util/ads.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/widgets/data/copyButton.dart';
import 'package:hashpass/widgets/interface/label.dart';

import '../model/password.dart';

class PasswordVisualizationModal extends StatefulWidget {
  const PasswordVisualizationModal({
    Key? key,
    required this.password,
    required this.appKey,
    required this.copyIconColor,
  }) : super(key: key);
  final Password password;
  final String appKey;
  final Color copyIconColor;

  @override
  _PasswordVisualizationModalState createState() =>
      _PasswordVisualizationModalState();
}

class _PasswordVisualizationModalState
    extends State<PasswordVisualizationModal> {
  double tempo = 0;
  double tempoTotal = Configuration.instance.showPasswordTime;
  late Timer time;
  double cont = Configuration.instance.showPasswordTime;
  String senha = "";
  bool isBannerLoaded = false;
  bool isVideoLoaded = false;
  bool isAdLoaded = false;
  bool hasAd = false;

  late BannerAd bannerAd;
  late InterstitialAd videoAd;

  @override
  void initState() {
    AdsHelper.getAdType().then((adType) {
      switch (adType) {
        case ADType.BANNER:
          bannerAd = BannerAd(
            size: AdSize.mediumRectangle,
            adUnitId: ADType.BANNER.id,
            listener: BannerAdListener(onAdLoaded: (ad) {
              setState(() {
                isBannerLoaded = true;
              });
            }, onAdFailedToLoad: (ad, error) {
              debugPrint("Erro ao carregar o banner: ${error.message}");
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
              onAdFailedToLoad: (error) {
                debugPrint("Erro ao renderizar ad: $error");
              },
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
    super.initState();
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
        debugPrint("Erro ao renderizar ad: $error");
        _initPasswordDialog();
      },
    );
  }

  void _initPasswordDialog() {
    setState(() {
      isAdLoaded = true;
    });
    if (widget.password.useCriptography) {
      HashCrypt.applyAlgorithms(
        widget.password.hashAlgorithm,
        widget.password.basePassword,
        widget.password.isAdvanced,
        widget.appKey,
      ).then((value) {
        setState(() {
          senha = value;
        });
      });
    } else {
      HashCrypt.decipherString(
        widget.password.basePassword,
        widget.appKey,
      ).then(
        (value) {
          setState(() {
            senha = value!;
          });
        },
      );
    }

    if (Configuration.instance.hasTimer) {
      time = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (cont > 0) {
            setState(() {
              tempo += 1 / tempoTotal;
              cont = cont - 1;
            });
          }
          if (tempo >= 0.99) {
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

  @override
  Widget build(BuildContext context) {
    return isAdLoaded
        ? Visibility(
            visible: isAdLoaded,
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 15,
                  right: 5,
                  bottom: 25,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: HashPassLabel(
                            overflow: TextOverflow.clip,
                            text: widget.password.title,
                            fontWeight: FontWeight.bold,
                            size: 19,
                          ),
                        ),
                        IconButton(
                          onPressed: () => closeModal(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HashPassLabel(
                          text: senha,
                          size: 15,
                          paddingRight: 15,
                          paddingTop: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                            bottom: 10,
                            right: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: Configuration.instance.hasTimer,
                                child: SizedBox(
                                  width: Get.size.width * .6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        builder: (context, value, _) =>
                                            LinearProgressIndicator(
                                          value: value,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(Get
                                                  .theme.toggleableActiveColor),
                                          backgroundColor: AppColors
                                              .ACCENT_LIGHT
                                              .withOpacity(0.3),
                                        ),
                                        duration: Duration(
                                          seconds: Configuration
                                              .instance.showPasswordTime
                                              .toInt(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.timer_outlined,
                                                color: Get.theme.hintColor,
                                                size: 12,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  "${cont.toInt()} segundos",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              CopyTextButton(textToCopy: senha),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isBannerLoaded,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, right: 10),
                            child: Container(
                              width: Get.size.width,
                              height: isBannerLoaded
                                  ? bannerAd.size.height.toDouble()
                                  : 0,
                              color: Colors.transparent,
                              child: isBannerLoaded
                                  ? AdWidget(ad: bannerAd)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
  }
}
