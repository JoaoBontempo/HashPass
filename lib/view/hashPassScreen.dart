import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HashPassScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showHelpIcon;
  final VoidCallback? onRequestHelp;
  const HashPassScreen({
    super.key,
    required this.title,
    required this.body,
    this.showHelpIcon = false,
    this.onRequestHelp,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: showHelpIcon
              ? <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
                    onPressed: onRequestHelp,
                  )
                ]
              : null,
        ),
        body: SizedBox(
          height: Get.height,
          child: Center(
            child: SingleChildScrollView(
              child: body,
            ),
          ),
        ),
      );
}
