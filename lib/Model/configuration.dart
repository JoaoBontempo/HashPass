import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hashpass/Util/criptografia.dart';

class Configuration {
  static late int darkMode;
  static late double showPasswordTime;
  static late bool isBiometria;
  static late SharedPreferences configs;

  static void printConfigs() {
    debugPrint("DarkMode: $darkMode | Timer: $showPasswordTime | Biometria: $isBiometria");
  }

  static Future<bool> addCheckPrimeiraEntrada() async {
    return await configs.setBool("hasEntrada", true);
  }

  static Future<bool> adicionarPrimeiraChave(String chaveGeral) async {
    bool chaveAdicionada = await Criptografia.criarChaveGeral(chaveGeral);
    return chaveAdicionada;
  }

  static void setDefaultConfig() {
    setConfigs(3, 30, false);
  }

  static Future<ThemeMode> getTema() async {
    final configs = await SharedPreferences.getInstance();
    darkMode = configs.getInt("theme")!;
    switch (darkMode) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      case 3:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  static void setConfigs(int theme, double timer, bool biometria) {
    configs.setInt("theme", theme);
    configs.setDouble("timer", timer);
    configs.setBool("biometria", biometria);
    getConfigs();
  }

  static void getConfigs() {
    int? theme = configs.getInt("theme");
    darkMode = theme ?? 1;

    double? timer = configs.getDouble("timer");
    showPasswordTime = timer ?? 30;

    bool? auth = configs.getBool("biometria");
    isBiometria = auth ?? false;
  }

  static Future<bool> adicionarEmail(String email) {
    return configs.setString("email", email);
  }

  static String? getEmail() {
    return configs.getString("email");
  }

  static Future<bool> checarPrimeiraEntrada() async {
    configs = await SharedPreferences.getInstance();
    bool? hasEntrada = configs.getBool("hasEntrada");
    debugPrint("Já entrou? $hasEntrada");
    return hasEntrada == null;
  }
}
