import 'package:flutter/material.dart';

class HashPassRoute {
  static void to(
    String route,
    BuildContext context, {
    destroyPreviousPages = false,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (_) => false,
    );
  }
}
