import 'package:circular_progress_bar_with_lines/circular_progress_bar_with_lines.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/hashPassDesktopProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/data/button.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';

class DesktopConnectionPage extends HashPassStatelessWidget {
  const DesktopConnectionPage({super.key});

  @override
  Widget localeBuild(context, language) =>
      Consumer3<UserPasswordsProvider, Configuration, HashPassDesktopProvider>(
        builder: (context, userPasswordsProvider, configuration, desktop, _) =>
            Scaffold(
          appBar: AppBar(
            title: Text(language.desktopConnection),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: desktop.isConnected
                  ? [
                      HashPassLabel(
                        text: language.connectionStablished,
                        fontWeight: FontWeight.bold,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.circleCheck,
                              size: Get.width * .3,
                              color: Colors.greenAccent,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: HashPassLabel(
                                text: "IP: ${desktop.serverIp}",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        label: language.restart,
                        width: Get.width * 0.5,
                        height: 35,
                        onPressed: desktop.reconnect,
                      )
                    ]
                  : desktop.connectionFailure
                      ? [
                          HashPassLabel(
                            text: language.connectionFailure,
                            fontWeight: FontWeight.bold,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 36),
                            child: Icon(
                              Icons.cancel_outlined,
                              size: Get.width * .3,
                              color: Colors.redAccent,
                            ),
                          ),
                          AppButton(
                            label: language.simpleTryAgain,
                            width: Get.width * 0.5,
                            height: 35,
                            onPressed: desktop.reconnect,
                          )
                        ]
                      : [
                          HashPassLabel(
                            text: language.stablishingConnection,
                            fontWeight: FontWeight.bold,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 36),
                            child: CircularProgressBarWithLines(
                              linesAmount: 255,
                              radius: 100,
                              linesWidth: 1.5,
                              linesLength: 35,
                              percent: (desktop.currentRange / 255) * 100,
                              centerWidgetBuilder: (context) => HashPassLabel(
                                text: desktop.serverIp,
                                fontWeight: FontWeight.bold,
                              ),
                              linesColor: HashPassTheme.isDarkMode
                                  ? Colors.black87
                                  : AppColors.ACCENT_LIGHT,
                            ),
                          ),
                          AppButton(
                            label: language.cancel,
                            width: Get.width * 0.5,
                            height: 35,
                            onPressed: desktop.cancel,
                          )
                        ],
            ),
          ),
        ),
      );
}
