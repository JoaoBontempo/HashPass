import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/widgets/configuration/cardStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/security/cryptography.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ConfigurationKeys {
  PASSWORD_CARD_STYLE('cardStyle'),
  USE_BIOMETRIC_VALIDATION("biometria"),
  USE_TIMER('hasTimer'),
  TIMER_VALUE('timer'),
  VERIFY_PASSWORD_ON_INSERT('insertVerify'),
  VERIFY_PASSWORD_ON_UPDATE('updateVerify'),
  APP_ENTRANCE('hasEntrance'),
  USE_TOOLTIPS('tooltips'),
  LANGUAGE('language'),
  APP_VERSION('appVersion'),
  THEME('theme'),
  USE_DESKTOP('useDesktop');

  final String key;
  const ConfigurationKeys(this.key);
}

class Configuration with ChangeNotifier {
  static late SharedPreferences configs;
  static late Configuration instance;
  SharedPreferences preferencesManager;

  Locale language;
  bool hasEntrance;
  HashPassTheme theme;
  HashPassCardStyle cardStyle;
  double showPasswordTime;
  bool isBiometria;
  bool hasTimer;
  bool insertPassVerify;
  bool updatePassVerify;
  bool showHelpTooltips;
  bool useDesktop;

  Configuration({
    required this.preferencesManager,
    required this.hasEntrance,
    required this.theme,
    required this.showPasswordTime,
    required this.isBiometria,
    required this.hasTimer,
    required this.insertPassVerify,
    required this.updatePassVerify,
    required this.showHelpTooltips,
    required this.cardStyle,
    required this.language,
    required this.useDesktop,
  });

  Future<void> setDefaultConfig() async {
    await setConfigs(
      language: _getDeviceDefaultSupportedLocale,
      timer: 30,
      useTimer: true,
      insertVerify: true,
      updateVerify: true,
      tooltips: true,
    );
  }

  Future<void> setConfigs({
    HashPassTheme? theme,
    double? timer,
    bool? useBiometricValidation,
    bool? useTimer,
    bool? insertVerify,
    bool? updateVerify,
    bool? tooltips,
    bool? entrance,
    bool? useDesktop,
    HashPassCardStyle? cardStyle,
    Locale? language,
    Function(bool)? onBiometricChange,
  }) async {
    await _setAppLanguage(language);
    await _setBiometricValidation(useBiometricValidation, onBiometricChange);
    await _setTheme(theme);
    await _setConfig<double>(ConfigurationKeys.TIMER_VALUE, timer);
    await _setConfig<bool>(ConfigurationKeys.USE_TIMER, useTimer);
    await _setConfig<bool>(
        ConfigurationKeys.VERIFY_PASSWORD_ON_INSERT, insertVerify);
    await _setConfig<bool>(
        ConfigurationKeys.VERIFY_PASSWORD_ON_UPDATE, updateVerify);
    await _setConfig<bool>(ConfigurationKeys.USE_TOOLTIPS, tooltips);
    await _setConfig<bool>(ConfigurationKeys.APP_ENTRANCE, entrance);
    await _setConfig<bool>(ConfigurationKeys.USE_DESKTOP, useDesktop);
    await _setConfig<int>(
        ConfigurationKeys.PASSWORD_CARD_STYLE, cardStyle?.style.index);
    await _setConfig<String>(
        ConfigurationKeys.LANGUAGE, language?.languageCode);

    this.theme = theme ?? this.theme;
    hasTimer = useTimer ?? hasTimer;
    showPasswordTime = timer ?? showPasswordTime;
    isBiometria = useBiometricValidation ?? isBiometria;
    insertPassVerify = insertVerify ?? insertPassVerify;
    updatePassVerify = updateVerify ?? updatePassVerify;
    showHelpTooltips = tooltips ?? showHelpTooltips;
    hasEntrance = entrance ?? hasEntrance;
    this.cardStyle = cardStyle ?? this.cardStyle;
    instance = this;
    this.language = language ?? this.language;
    this.useDesktop = useDesktop ?? this.useDesktop;
    notifyListeners();
  }

  Future<bool> _setAppLanguage(Locale? language) {
    if (language != null) {
      Get.updateLocale(language);
      return _setConfig<String>(
          ConfigurationKeys.LANGUAGE, language.languageCode);
    }

    return Future(() => true);
  }

  Future<bool> _setTheme(HashPassTheme? theme) async {
    if (theme != null) {
      Get.changeThemeMode(theme.mode);
      return preferencesManager.setInt(
          ConfigurationKeys.THEME.key, theme.mode.index);
    }

    return Future(() => true);
  }

  _setBiometricValidation(
      bool? useBiometricValidation, Function(bool)? onBiometricChange) async {
    if (useBiometricValidation != null) {
      if (isBiometria) {
        await preferencesManager.setBool(
          ConfigurationKeys.USE_BIOMETRIC_VALIDATION.key,
          useBiometricValidation,
        );
        if (onBiometricChange != null) onBiometricChange(false);
      } else {
        await Get.dialog(
          AuthAppKey(
            onValidate: (senha) async {
              await HashCrypt.createGeneralKey(senha);
              await preferencesManager.setBool(
                ConfigurationKeys.USE_BIOMETRIC_VALIDATION.key,
                useBiometricValidation,
              );
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

  Future<bool> _setConfig<ConfigurationType>(
    ConfigurationKeys key,
    ConfigurationType? value,
  ) async {
    if (value != null) {
      switch (value.runtimeType) {
        case String:
          return preferencesManager.setString(key.key, value as String);
        case int:
          return preferencesManager.setInt(key.key, value as int);
        case bool:
          return preferencesManager.setBool(key.key, value as bool);
        case double:
          return preferencesManager.setDouble(key.key, value as double);
        default:
          return Future(() => false);
      }
    }

    return Future(() => true);
  }

  static Locale get _getDeviceDefaultSupportedLocale =>
      AppLocalizations.supportedLocales.firstWhere(
        (locale) =>
            locale.languageCode ==
            (Get.deviceLocale?.languageCode ??
                AppLocalizations.supportedLocales.first.languageCode),
        orElse: () => AppLocalizations.supportedLocales.firstWhere(
          (locale) => locale.languageCode == 'en',
        ),
      );

  static Future<Configuration> getHashPassConfiguration() async {
    SharedPreferences configs = await SharedPreferences.getInstance();

    Configuration.configs = configs;
    Configuration.instance = Configuration(
      language: AppLocalizations.supportedLocales.firstWhere(
          (locale) =>
              locale.languageCode ==
              configs.getString(
                ConfigurationKeys.LANGUAGE.key,
              ),
          orElse: () => _getDeviceDefaultSupportedLocale),
      preferencesManager: configs,
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
      useDesktop: configs.getBool(ConfigurationKeys.USE_DESKTOP.key) ?? false,
    );
    return instance;
  }
}
