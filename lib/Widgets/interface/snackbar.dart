import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class HashPassSnackBar {
  static void show({
    Color? textColor,
    required message,
    Color background = Colors.greenAccent,
  }) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: HashPassLabel(
          text: message,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: background,
      ),
    );
  }
}
