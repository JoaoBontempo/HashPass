import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/widgets/configuration/cardStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/widgets/validarChave.dart';

enum ConfigurationKeys {
  PASSWORD_CARD_STYLE('cardStyle'),
  USE_BIOMETRIC_VALIDATION("biometria"),
  USE_TIMER('hasTimer'),
  TIMER_VALUE('timer'),
  VERIFY_PASSWORD_ON_INSERT('insertVerify'),
  VERIFY_PASSWORD_ON_UPDATE('updateVerify'),
  APP_ENTRANCE('hasEntrance'),
  USE_TOOLTIPS('tooltips'),
  THEME('theme');

  final String key;
  const ConfigurationKeys(this.key);
}

class Configuration extends ChangeNotifier {
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

  static void setDefaultConfig() {
    setConfigs(
      timer: 30,
      useTimer: true,
      insertVerify: true,
      updateVerify: true,
      tooltips: true,
      cardStyle: HashPassCardStyle(style: CardStyle.DEFAULT),
    );
  }

  static void setDatabaseVersion() {
    configs.setInt("sqlv", 1);
  }

  static Future<void> setConfigs({
    HashPassTheme? theme,
    double? timer,
    bool? useBiometricValidation,
    bool? useTimer,
    bool? insertVerify,
    bool? updateVerify,
    bool? tooltips,
    bool? entrance,
    HashPassCardStyle? cardStyle,
    Function(bool)? onBiometricChange,
  }) async {
    _setTheme(theme);
    _setBiometricValidation(useBiometricValidation, onBiometricChange);

    _setConfig<double>(ConfigurationKeys.TIMER_VALUE, timer);

    _setConfig<bool>(ConfigurationKeys.USE_TIMER, useTimer);
    _setConfig<bool>(ConfigurationKeys.USE_TIMER, useTimer);
    _setConfig<bool>(ConfigurationKeys.VERIFY_PASSWORD_ON_INSERT, insertVerify);
    _setConfig<bool>(ConfigurationKeys.VERIFY_PASSWORD_ON_UPDATE, updateVerify);
    _setConfig<bool>(ConfigurationKeys.USE_TOOLTIPS, tooltips);
    _setConfig<bool>(ConfigurationKeys.APP_ENTRANCE, entrance);

    _setConfig<int>(
        ConfigurationKeys.PASSWORD_CARD_STYLE, cardStyle?.style.index);

    await getHashPassConfiguration();
  }

  static Future<bool> _setTheme(HashPassTheme? theme) async {
    if (theme != null) {
      Get.changeThemeMode(theme.mode);
      return configs.setInt(ConfigurationKeys.THEME.key, theme.mode.index);
    }

    return Future(() => true);
  }

  static _setBiometricValidation(
      bool? useBiometricValidation, Function(bool)? onBiometricChange) async {
    if (useBiometricValidation != null) {
      if (Configuration.instance.isBiometria) {
        await configs.setBool(ConfigurationKeys.USE_BIOMETRIC_VALIDATION.key,
            useBiometricValidation);
        if (onBiometricChange != null) onBiometricChange(false);
      } else {
        await Get.dialog(
          ValidarSenhaGeral(
            onValidate: (senha) async {
              await HashCrypt.createGeneralKey(senha);
              await configs.setBool(
                  ConfigurationKeys.USE_BIOMETRIC_VALIDATION.key,
                  useBiometricValidation);
              if (onBiometricChange != null) onBiometricChange(true);
            },
            onInvalid: () {
              if (onBiometricChange != null) onBiometricChange(false);
            },
          ),
        );
      }
    }
  }

  static Future<bool> _setConfig<Type>(
    ConfigurationKeys key,
    Type? value,
  ) async {
    if (value != null) {
      switch (Type.runtimeType) {
        case int:
          return configs.setInt(key.key, value as int);
        case bool:
          return configs.setBool(key.key, value as bool);
        case double:
          return configs.setDouble(key.key, value as double);
        default:
          return Future(() => false);
      }
    }

    return Future(() => true);
  }

  static Future<Configuration> getHashPassConfiguration() async {
    if (!hasInit) configs = await SharedPreferences.getInstance();
    hasInit = true;

    instance = Configuration(
      hasEntrance: configs.getBool(ConfigurationKeys.APP_ENTRANCE.key) ?? false,
      theme: HashPassTheme.values.firstWhere(
        (theme) =>
            theme.mode.index ==
            (configs.getInt(ConfigurationKeys.THEME.key) ??
                ThemeMode.system.index),
        orElse: () => HashPassTheme(mode: ThemeMode.system),
      ),
      showPasswordTime:
          configs.getDouble(ConfigurationKeys.TIMER_VALUE.key) ?? 30,
      isBiometria:
          configs.getBool(ConfigurationKeys.USE_BIOMETRIC_VALIDATION.key) ??
              false,
      hasTimer: configs.getBool(ConfigurationKeys.USE_TIMER.key) ?? true,
      insertPassVerify:
          configs.getBool(ConfigurationKeys.VERIFY_PASSWORD_ON_INSERT.key) ??
              true,
      updatePassVerify:
          configs.getBool(ConfigurationKeys.VERIFY_PASSWORD_ON_UPDATE.key) ??
              true,
      showHelpTooltips:
          configs.getBool(ConfigurationKeys.USE_TOOLTIPS.key) ?? true,
      cardStyle: HashPassCardStyle.values.firstWhere(
        (cardStyle) =>
            cardStyle.style.index ==
            (configs.getInt(ConfigurationKeys.PASSWORD_CARD_STYLE.key) ??
                CardStyle.DEFAULT.index),
        orElse: () => HashPassCardStyle(style: CardStyle.DEFAULT),
      ),
    );
    return instance;
  }
}
