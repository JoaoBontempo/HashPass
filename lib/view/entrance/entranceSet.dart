import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';

class SetEntrancePage extends StatefulWidget {
  const SetEntrancePage({Key? key}) : super(key: key);

  @override
  State<SetEntrancePage> createState() => _SetEntrancePageState();
}

class _SetEntrancePageState extends HashPassState<SetEntrancePage> {
  double buttonOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        buttonOpacity = 1;
      }),
    );
  }

  @override
  Widget localeBuild(context, language) => Consumer<Configuration>(
        builder: (context, configuration, widget) => Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                height: Get.size.height * .5,
                width: Get.size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HashPassLabel(
                      text: language.appReady,
                      size: 30,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.hintColor,
                    ),
                    HashPassTheme.getLogo(
                      width: Get.width * 0.5,
                    ),
                    AnimatedOpacity(
                      opacity: buttonOpacity,
                      duration: const Duration(milliseconds: 1750),
                      child: TextButton(
                        onPressed: () {
                          configuration.setConfigs(entrance: true);
                          configuration.setDatabaseVersion();
                          HashPassRouteManager.to(HashPassRoute.INDEX, context);
                        },
                        child: HashPassLabel(
                          text: language.start.toUpperCase(),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
