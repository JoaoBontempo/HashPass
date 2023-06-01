import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/widgets/interface/label.dart';

class SetEntrancePage extends StatefulWidget {
  const SetEntrancePage({Key? key}) : super(key: key);

  @override
  State<SetEntrancePage> createState() => _SetEntrancePageState();
}

class _SetEntrancePageState extends State<SetEntrancePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: Get.size.height * .5,
            width: Get.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HashPassLabel(
                  text: "Tudo certo!",
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
                      Configuration.setConfigs(entrance: true);
                      Configuration.setDatabaseVersion();
                      HashPassRouteManager.to(HashPassRoute.INDEX, context);
                    },
                    child: const HashPassLabel(
                      text: "COMEÇAR",
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
