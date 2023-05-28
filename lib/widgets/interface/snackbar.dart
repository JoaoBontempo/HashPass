import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/widgets/interface/label.dart';

class HashPassSnackBar {
  static void show({
    required message,
    SnackBarType type = SnackBarType.SUCCESS,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        duration: duration,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        content: HashPassLabel(
          text: message,
          color: type == SnackBarType.ERROR ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: type == SnackBarType.ERROR
            ? Colors.redAccent
            : type == SnackBarType.SUCCESS
                ? Colors.greenAccent
                : Colors.yellow,
      ),
    );
  }
}

enum SnackBarType {
  ERROR,
  WARNING,
  SUCCESS,
}
