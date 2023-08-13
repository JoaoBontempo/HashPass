import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/interface/label.dart';

class HashPassMessage extends HashPassStatelessWidget {
  static Future<MessageResponse> show({
    String message = "",
    String title = "",
    Widget? body,
    MessageType type = MessageType.OK,
  }) async {
    MessageResponse response = MessageResponse.CLOSE;
    await Get.dialog(
      HashPassMessage(
        title: title,
        message: message,
        type: type,
        onAction: (action) {
          Get.back();
          response = action;
        },
        body: body,
      ),
      barrierDismissible: false,
    );
    return response;
  }

  const HashPassMessage({
    Key? key,
    required this.title,
    required this.message,
    required this.type,
    required this.onAction,
    this.body,
  }) : super(key: key);
  final String title;
  final String message;
  final MessageType type;
  final Function(MessageResponse) onAction;
  final Widget? body;

  Widget _getButtons(MessageType type) {
    return type == MessageType.OK
        ? TextButton(
            onPressed: () => onAction(MessageResponse.OK),
            child: const HashPassLabel(text: 'OK'),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => onAction(MessageResponse.NO),
                child: HashPassLabel(
                  text: appLanguage.no.toUpperCase(),
                ),
              ),
              TextButton(
                onPressed: () => onAction(MessageResponse.YES),
                child: HashPassLabel(
                  text: appLanguage.yes.toUpperCase(),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: title.isNotEmpty,
              child: HashPassLabel(
                text: title,
                fontWeight: FontWeight.bold,
                paddingBottom: 15,
              ),
            ),
            Visibility(
              visible: body == null,
              child: HashPassLabel(
                paddingLeft: 5,
                paddingRight: 5,
                text: message,
                size: 14.5,
              ),
            ),
            Visibility(
              visible: body != null,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: body ?? Container(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _getButtons(type),
            ),
          ],
        ),
      ),
    );
  }
}

enum MessageType {
  OK,
  YESNO,
}

enum MessageResponse {
  YES,
  NO,
  OK,
  CLOSE,
}
