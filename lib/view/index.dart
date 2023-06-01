import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/passwordsProvider.dart';
import 'package:hashpass/util/appContext.dart';
import 'package:hashpass/view/passwords.dart';
import 'package:hashpass/widgets/drawer.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int paginaAtual = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
      child: ChangeNotifierProvider<PasswordProvider>(
        create: (context) => PasswordProvider(),
        builder: (context, widget) => Scaffold(
          onDrawerChanged: (isOn) {
            FocusManager.instance.primaryFocus?.unfocus();
            isDrawerOpen = isOn;
          },
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: const Text("Minhas senhas"),
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
                                      .where((key) => key.currentState != null)
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
    );
  }
}
