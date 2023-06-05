// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/passwordVisualizationProvider.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/widgets/data/copyButton.dart';
import 'package:hashpass/widgets/interface/label.dart';

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
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
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
                                paddingRight: 10,
                              ),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              onPressed: provider.closeModal,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (provider.password.credential.isNotEmpty)
                          PasswordInformationVisualization(
                            information: provider.password.credential,
                            icon: Icons.person,
                            label: 'Credencial',
                          ),
                        PasswordInformationVisualization(
                          information: provider.realPassword,
                          icon: Icons.lock_open,
                          label: 'Senha',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                            bottom: 10,
                          ),
                          child: Visibility(
                            visible: Configuration.instance.hasTimer,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, _) =>
                                      LinearProgressIndicator(
                                    value: value,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Get.theme.toggleableActiveColor),
                                    backgroundColor:
                                        AppColors.ACCENT_LIGHT.withOpacity(0.3),
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
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "${provider.timeCount.toInt()} segundos",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
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
                        Visibility(
                          visible: provider.isBannerLoaded,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
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

class PasswordInformationVisualization extends StatelessWidget {
  final String information;
  final IconData icon;
  final String label;

  const PasswordInformationVisualization({
    Key? key,
    required this.information,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: Colors.grey,
              ),
              HashPassLabel(
                text: label,
                paddingLeft: 10,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width * .8,
                  child: HashPassLabel(
                    text: information,
                    size: 14,
                    paddingRight: 5,
                  ),
                ),
                CopyTextButton(
                  textToCopy: information,
                  widgetSize: 17,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
