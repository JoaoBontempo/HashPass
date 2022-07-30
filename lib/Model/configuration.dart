import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Database/sql.dart';
import 'package:hashpass/Widgets/configuration/cardStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hashpass/Themes/theme.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Widgets/validarChave.dart';

class Configuration {
  static late SharedPreferences configs;
  static late Configuration instance;
  static bool hasInit = false;

  bool hasEntrance;
  HashPassTheme theme;
  HashPassCardStyle cardStyle;
  double showPasswordTime;
  bool isBiometria;
  bool hasTimer;
  bool insertPassVerify;
  bool updatePassVerify;
  bool showHelpTooltips;

  Configuration({
    required this.hasEntrance,
    required this.theme,
    required this.showPasswordTime,
    required this.isBiometria,
    required this.hasTimer,
    required this.insertPassVerify,
    required this.updatePassVerify,
    required this.showHelpTooltips,
    required this.cardStyle,
  });

  static void printConfigs() {
    debugPrint('Theme: ${Configuration.instance.theme} theme | Timer: ${Configuration.instance.showPasswordTime} | '
        'Biometria: ${Configuration.instance.isBiometria} | hasTimer: ${Configuration.instance.hasTimer}'
        ' | Insert pass verify: ${Configuration.instance.insertPassVerify} | Update pass verify: ${Configuration.instance.updatePassVerify} | '
        'Tooltips: ${Configuration.instance.showHelpTooltips} | Entrance: ${Configuration.instance.hasEntrance}');
  }

  static Future<bool> adicionarPrimeiraChave(String chaveGeral) async {
    bool chaveAdicionada = await HashCrypt.createDefaultKey(chaveGeral);
    return chaveAdicionada;
  }

  static void setDefaultConfig() {
    setConfigs(
      timer: 30,
      hasTimer: true,
      insertVerify: true,
      updateVerify: true,
      tooltips: true,
    );
  }

  static void setDatabaseVersion({int version = HashPassDB.SQL_VERSION}) {
    configs.setInt("sqlv", version);
  }

  static void setConfigs({
    HashPassTheme? theme,
    double? timer,
    bool? biometria,
    bool? hasTimer,
    bool? insertVerify,
    bool? updateVerify,
    bool? tooltips,
    bool? entrance,
    HashPassCardStyle? cardStyle,
  }) async {
    if (theme != null) {
      Get.changeThemeMode(theme.mode);
      configs.setInt("theme", theme.mode.index);
    }
    if (timer != null) configs.setDouble("timer", timer);
    if (biometria != null) {
      if (Configuration.instance.isBiometria) {
        configs.setBool("biometria", biometria);
      } else {
        await Get.dialog(
          ValidarSenhaGeral(
            onValidate: (senha) async {
              await HashCrypt.createDefaultKey(senha);
              configs.setBool("biometria", biometria);
            },
          ),
        );
      }
    }
    if (hasTimer != null) configs.setBool("hasTimer", hasTimer);
    if (insertVerify != null) configs.setBool("insertVerify", insertVerify);
    if (updateVerify != null) configs.setBool("updateVerify", updateVerify);
    if (tooltips != null) configs.setBool("tooltips", tooltips);
    if (entrance != null) configs.setBool("hasEntrance", entrance);
    if (cardStyle != null) configs.setInt("cardStyle", cardStyle.style.index);
    getConfigs();
  }

  static Future<Configuration> getConfigs() async {
    if (!hasInit) configs = await SharedPreferences.getInstance();
    hasInit = true;

    instance = Configuration(
      hasEntrance: configs.getBool("hasEntrance") ?? false,
      theme: HashPassTheme.values.firstWhere(
        (theme) => theme.mode.index == (configs.getInt("theme") ?? ThemeMode.system.index),
        orElse: () => HashPassTheme(mode: ThemeMode.system),
      ),
      showPasswordTime: configs.getDouble("timer") ?? 30,
      isBiometria: configs.getBool("biometria") ?? false,
      hasTimer: configs.getBool("hasTimer") ?? true,
      insertPassVerify: configs.getBool("insertVerify") ?? true,
      updatePassVerify: configs.getBool("updateVerify") ?? true,
      showHelpTooltips: configs.getBool("tooltips") ?? true,
      cardStyle: HashPassCardStyle.values.firstWhere(
        (cardStyle) => cardStyle.style.index == (configs.getInt("cardStyle") ?? CardStyle.DEFAULT),
        orElse: () => HashPassCardStyle(style: CardStyle.DEFAULT),
      ),
    );
    return instance;
  }
}
