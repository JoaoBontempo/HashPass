import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/hashPassDesktopProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/util/appContext.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/view/passwords.dart';
import 'package:hashpass/widgets/drawer.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class IndexPage extends HashPassStatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  void startHelpShowcase() => HashPassContext.scroller!
      .animateTo(
        0,
        duration: const Duration(milliseconds: 750),
        curve: Curves.linear,
      )
      .then(
        (value) => {
          ShowCaseWidget.of(Get.context!).startShowCase(
            HashPassContext.keys!
                .where((key) => key.currentState != null)
                .toList(),
          )
        },
      );

  @override
  Widget localeBuild(context, language) {
    bool isDrawerOpen = false;
    return Consumer3<UserPasswordsProvider, Configuration,
        HashPassDesktopProvider>(
      builder: (context, passwordsProvider, configuration, desktop, _) =>
          WillPopScope(
        onWillPop: () async {
          if (isDrawerOpen) {
            return true;
          }
          FocusManager.instance.primaryFocus?.unfocus();
          HashPassMessage.show(
            title: language.closeAppConfirmationTitle,
            message: language.closeAppConfirmationMessage,
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
              title: const Text('HashPass'),
              actions: Configuration.instance.showHelpTooltips &&
                      passwordsProvider.getPasswords().isNotEmpty
                  ? <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.help,
                          color: Colors.white,
                        ),
                        onPressed: startHelpShowcase,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.desktop_windows_outlined,
                          color: desktop.isConnected
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                        onPressed: desktop.connect,
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
