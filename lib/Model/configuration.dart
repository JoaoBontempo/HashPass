import 'package:flutter/cupertino.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuration {
  bool darkMode;
  double showPasswordTime;
  Configuration({
    required this.darkMode,
    required this.showPasswordTime,
  });

  static Future<bool> addCheckPrimeiraEntrada() async {
    final configs = await SharedPreferences.getInstance();
    bool hasEntrada = await configs.setBool("hasEntrada", true);
    Criptografia.adicionarHashValidacao();
    return hasEntrada;
  }

  static Future<bool> adicionarPrimeiraChave(String chaveGeral) async {
    bool chaveAdicionada = await Criptografia.criarChaveGeral(chaveGeral);
    return chaveAdicionada;
  }

  static Future<bool> checarPrimeiraEntrada() async {
    final configs = await SharedPreferences.getInstance();

    bool? hasEntrada = configs.getBool("hasEntrada");
    debugPrint("Já entrou? $hasEntrada");
    return hasEntrada == null;
  }
}
