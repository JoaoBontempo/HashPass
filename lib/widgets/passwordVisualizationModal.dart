import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/passwordVisualizationProvider.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/widgets/data/copyButton.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';

class PasswordVisualizationModal extends StatelessWidget {
  const PasswordVisualizationModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordVisualizationProvider>(
      builder: (context, provider, _) {
        return provider.isAdLoaded
            ? Visibility(
                visible: provider.isAdLoaded,
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
                                text: provider.password.title,
                                fontWeight: FontWeight.bold,
                                size: 19,
                              ),
                            ),
                            IconButton(
                              onPressed: provider.closeModal,
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
                              text: provider.realPassword,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: Configuration.instance.hasTimer,
                                    child: SizedBox(
                                      width: Get.size.width * .6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TweenAnimationBuilder<double>(
                                            tween: Tween(begin: 0.0, end: 1.0),
                                            builder: (context, value, _) =>
                                                LinearProgressIndicator(
                                              value: value,
                                              valueColor: AlwaysStoppedAnimation<
                                                      Color>(
                                                  Get.theme
                                                      .toggleableActiveColor),
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
                                            padding:
                                                const EdgeInsets.only(top: 5),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      "${provider.timeCount.toInt()} segundos",
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
                                  CopyTextButton(
                                      textToCopy: provider.realPassword),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: provider.isBannerLoaded,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 10),
                                child: Container(
                                  width: Get.size.width,
                                  height: provider.isBannerLoaded
                                      ? provider.bannerAd.size.height.toDouble()
                                      : 0,
                                  color: Colors.transparent,
                                  child: provider.isBannerLoaded
                                      ? AdWidget(
                                          ad: provider.bannerAd,
                                        )
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
      },
    );
  }
}
