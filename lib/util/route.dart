import 'package:flutter/material.dart';

enum HashPassRoute {
  WELCOME('/welcome'),
  CHOOSE_CONFIGURATION('/chooseConfig'),
  FIRST_CONFIGURATION('/firstConfig'),
  ENTRANCE('/setEntrance'),
  INDEX('/index');

  final String path;
  const HashPassRoute(this.path);
}

class HashPassRouteManager {
  static void to(
    HashPassRoute route,
    BuildContext context, {
    destroyPreviousPages = false,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route.path,
      (_) => false,
    );
  }
}
