import 'package:flutter/material.dart';

class AppColors {
  static Color Black(double opacity) {
    return const Color(0xFF000000).withOpacity(opacity);
  }

  static const Color PRIMARY_LIGHT = Color(0xFFe3ffff);
  static const Color SECONDARY_LIGHT = Color(0xFF000552);
  static const Color ACCENT_LIGHT = Color(0xFF0062ff);
  static const Color ACCENT_LIGHT_2 = Color(0xFF4ff9ff);

  static const Color PRIMARY_DARK = Color.fromARGB(255, 255, 255, 255);
  static const Color SECONDARY_DARK = Color(0xFF202029);
  static const Color ACCENT_DARK = Color.fromARGB(255, 80, 80, 80);
  static const Color ACCENT_DARK_2 = Color.fromARGB(255, 96, 206, 204);
}
