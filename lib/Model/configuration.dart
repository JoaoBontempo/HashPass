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
      cardStyle: HashPassCardStyle(style: CardStyle.DEFAULT),
    );
  }

  static void setDatabaseVersion({int version = HashPassDB.SQL_VERSION}) {
    configs.setInt("sqlv", version);
  }

  static Future<void> setConfigs({
    HashPassTheme? theme,
    double? timer,
    bool? biometria,
    bool? hasTimer,
    bool? insertVerify,
    bool? updateVerify,
    bool? tooltips,
    bool? entrance,
    HashPassCardStyle? cardStyle,
    Function(bool)? onBiometricChange,
  }) async {
    if (theme != null) {
      Get.changeThemeMode(theme.mode);
      await configs.setInt("theme", theme.mode.index);
    }
    if (timer != null) await configs.setDouble("timer", timer);
    if (biometria != null) {
      if (Configuration.instance.isBiometria) {
        await configs.setBool("biometria", biometria);
        if (onBiometricChange != null) onBiometricChange(false);
      } else {
        await Get.dialog(
          ValidarSenhaGeral(
            onValidate: (senha) async {
              await HashCrypt.createDefaultKey(senha);
              await configs.setBool("biometria", biometria);
              if (onBiometricChange != null) onBiometricChange(true);
            },
            onInvalid: () {
              if (onBiometricChange != null) onBiometricChange(false);
            },
          ),
        );
      }
    }
    if (hasTimer != null) await configs.setBool("hasTimer", hasTimer);
    if (insertVerify != null) await configs.setBool("insertVerify", insertVerify);
    if (updateVerify != null) await configs.setBool("updateVerify", updateVerify);
    if (tooltips != null) await configs.setBool("tooltips", tooltips);
    if (entrance != null) await configs.setBool("hasEntrance", entrance);
    if (cardStyle != null) await configs.setInt("cardStyle", cardStyle.style.index);
    await getConfigs();
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
        (cardStyle) => cardStyle.style.index == (configs.getInt("cardStyle") ?? CardStyle.DEFAULT.index),
        orElse: () => HashPassCardStyle(style: CardStyle.DEFAULT),
      ),
    );
    return instance;
  }
}
