import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/appContext.dart';
import 'package:hashpass/view/passwords.dart';
import 'package:hashpass/widgets/drawer.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDrawerOpen = false;
    return Consumer2<UserPasswordsProvider, Configuration>(
      builder: (context, passwordsProvider, configuration, _) => WillPopScope(
        onWillPop: () async {
          if (isDrawerOpen) {
            return true;
          }
          FocusManager.instance.primaryFocus?.unfocus();
          HashPassMessage.show(
            title: "Fechar o aplicativo?",
            message: "Tem certeza que deseja sair do HashPass?",
            type: MessageType.YESNO,
          ).then((action) {
            if (action == MessageResponse.YES) {
              exit(0);
            }
          });
          return false;
        },
        child: ChangeNotifierProvider<UserPasswordsProvider>.value(
          value: passwordsProvider,
          builder: (context, widget) => Scaffold(
            onDrawerChanged: (isOn) {
              FocusManager.instance.primaryFocus?.unfocus();
              isDrawerOpen = isOn;
            },
            drawer: const AppDrawer(),
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.helloWorld),
              actions: Configuration.instance.showHelpTooltips
                  ? <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.help,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          HashPassContext.scroller!
                              .animateTo(
                                0,
                                duration: const Duration(milliseconds: 750),
                                curve: Curves.linear,
                              )
                              .then(
                                (value) => {
                                  ShowCaseWidget.of(Get.context!).startShowCase(
                                    HashPassContext.keys!
                                        .where(
                                            (key) => key.currentState != null)
                                        .toList(),
                                  )
                                },
                              );
                        },
                      )
                    ]
                  : null,
            ),
            body: const PasswordsMenu(),
          ),
        ),
      ),
    );
  }
}
