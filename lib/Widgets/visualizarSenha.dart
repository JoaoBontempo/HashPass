import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Util/ads.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Widgets/data/copyButton.dart';
import 'package:hashpass/Widgets/interface/label.dart';

import '../Model/senha.dart';

class VisualizacaoSenhaModal extends StatefulWidget {
  const VisualizacaoSenhaModal({
    Key? key,
    required this.senha,
    required this.chaveGeral,
    required this.copyIconColor,
  }) : super(key: key);
  final Senha senha;
  final String chaveGeral;
  final Color copyIconColor;

  @override
  _VisualizacaoSenhaModalState createState() => _VisualizacaoSenhaModalState();
}

class _VisualizacaoSenhaModalState extends State<VisualizacaoSenhaModal> {
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
    switch (AdsHelper.getAdType()) {
      case 1:
        bannerAd = BannerAd(
          size: AdSize.mediumRectangle,
          adUnitId: 'ca-app-pub-3940256099942544/6300978111', //Util.adMobAppID,
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
      case 2:
        InterstitialAd.load(
          adUnitId: 'ca-app-pub-3940256099942544/1033173712',
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: videoAdLoaded,
            onAdFailedToLoad: (error) {
              debugPrint("Erro ao renderizar ad: $error");
            },
          ),
        );
        break;
      case 3:
        _initPasswordDialog();
        break;
    }
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
    if (widget.senha.criptografado) {
      HashCrypt.applyAlgorithms(
        widget.senha.algoritmo,
        widget.senha.senhaBase,
        widget.senha.avancado,
        widget.chaveGeral,
      ).then((value) {
        setState(() {
          senha = value;
        });
      });
    } else {
      HashCrypt.decipherString(
        widget.senha.senhaBase,
        widget.chaveGeral,
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
          setState(() {
            if (cont > 0) {
              tempo += 1 / tempoTotal;
              cont = cont - 1;
            }
          });
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
                  bottom: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HashPassLabel(
                          text: widget.senha.titulo,
                          fontWeight: FontWeight.bold,
                          size: 19,
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
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      LinearProgressIndicator(
                                        value: tempo,
                                        valueColor: AlwaysStoppedAnimation<Color>(Get.theme.toggleableActiveColor),
                                        backgroundColor: AppColors.ACCENT_LIGHT.withOpacity(0.3),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.timer,
                                                color: Theme.of(context).hintColor,
                                                size: 12,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Text(
                                                  "${cont.toInt()} segundos",
                                                  style: TextStyle(
                                                    color: Theme.of(context).hintColor,
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
                              height: isBannerLoaded ? bannerAd.size.height.toDouble() : 0,
                              color: Colors.transparent,
                              child: isBannerLoaded ? AdWidget(ad: bannerAd) : null,
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
