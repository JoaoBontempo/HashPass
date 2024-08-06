import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/appLanguage.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/animations/booleanHide.dart';
import 'package:hashpass/widgets/configuration/booleanConfig.dart';
import 'package:hashpass/widgets/configuration/cardStyle.dart';
import 'package:hashpass/widgets/configuration/dropdownConfiguration.dart';
import 'package:hashpass/widgets/configuration/multiBooleanWidgetConfig.dart';
import 'package:hashpass/widgets/configuration/radioConfig.dart';
import 'package:hashpass/widgets/configuration/secondaryBooleanConfig.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends HashPassState<ConfigurationPage> {
  double timer = Configuration.instance.showPasswordTime;
  bool hasBiometricValidation = false;
  late bool isBiometric = Configuration.instance.isBiometria;
  final timerEC = TextEditingController();

  @override
  void initState() {
    timerEC.text = timer.toInt().toString();
    final LocalAuthentication auth = LocalAuthentication();
    auth.isDeviceSupported().then((value) {
      setState(() {
        hasBiometricValidation = value;
      });
    });
    super.initState();
  }

  void setTimerValue(Configuration configuration, String value) {
    String oldTimerValue = configuration.showPasswordTime.toInt().toString();

    if (value.isEmpty) {
      timerEC.text = oldTimerValue;
      return;
    }

    double timer = double.parse(value);

    if (timer == 0) {
      timerEC.text = oldTimerValue;
      return;
    }

    configuration.setConfigs(
      timer: timer,
    );
  }

  @override
  Widget localeBuild(context, language) => Consumer<Configuration>(
        builder: (context, configuration, widget) => WillPopScope(
          onWillPop: () async {
            HashPassRouteManager.to(HashPassRoute.INDEX, context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(language.settings),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  children: [
                    DropDownConfiguration<HashPassLanguage>(
                      selectedValue:
                          HashPassLanguage.fromLocale(configuration.language),
                      onChange: (language) =>
                          configuration.setConfigs(language: language.locale),
                      label: language.language,
                      icon: Icons.language_outlined,
                      values: HashPassLanguage.values,
                    ),
                    const HashPassConfigDivider(),
                    BooleanConfigWidget(
                      useState: false,
                      isVisible: hasBiometricValidation,
                      onChange: (useBiometricValidation) {
                        configuration.setConfigs(
                          useBiometricValidation: useBiometricValidation,
                          onBiometricChange: (isBiometricConfig) => setState(
                            () => isBiometric = isBiometricConfig,
                          ),
                        );
                      },
                      description: language.biometricConfigDescription,
                      label: language.biometricConfigTitle,
                      icon: Icons.fingerprint,
                      value: isBiometric,
                    ),
                    const HashPassConfigDivider(),
                    BooleanConfigWidget(
                      onChange: (checked) =>
                          configuration.setConfigs(useDesktop: checked),
                      description: language.useDesktopDescription,
                      label: language.useDesktopTitle,
                      icon: Icons.desktop_windows_outlined,
                      value: configuration.useDesktop,
                    ),
                    const HashPassConfigDivider(),
                    HashPassRadioConfig<HashPassTheme>(
                      label: language.theme,
                      selectedValue: configuration.theme,
                      values: HashPassTheme.values,
                      onSelect: (selectedTheme) =>
                          configuration.setConfigs(theme: selectedTheme),
                      icon: Icons.brightness_6_outlined,
                    ),
                    const HashPassConfigDivider(),
                    BooleanConfigWidget(
                      onChange: (checked) =>
                          configuration.setConfigs(useTimer: checked),
                      description: language.timerConfigDescription,
                      label: language.timerConfigTitle,
                      icon: Icons.timer_outlined,
                      value: configuration.hasTimer,
                    ),
                    AnimatedBooleanContainer(
                      useWidth: false,
                      show: configuration.hasTimer,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 25),
                              child: Row(
                                children: [
                                  Text(
                                    "${language.timerDurationConfigTitle}: ",
                                    style: const TextStyle(fontSize: 13.5),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .15,
                                      height: 25,
                                      child: AppTextField(
                                        maxLength: 3,
                                        label: "",
                                        onKeyboardAction: (value) =>
                                            setTimerValue(configuration, value),
                                        onSave: (value) =>
                                            setTimerValue(configuration, value),
                                        controller: timerEC,
                                        padding: 0,
                                        fontSize: 14,
                                        textAlign: TextAlign.center,
                                        formatter: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                  const Text("s"),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 10,
                                  right: 20,
                                  bottom: 25,
                                ),
                                child: Text(
                                  language.timerDurationConfigDescription,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const HashPassConfigDivider(),
                    MultiBooleanWConfig(
                      headerLabel: language.passworkLeakMenu,
                      headerDescription: language.passworkLeakConfigDescription,
                      configurations: [
                        SecondaryBooleanConfigWidget(
                          onChange: (checked) =>
                              configuration.setConfigs(insertVerify: checked),
                          description:
                              language.insertPasswordLeakVerificationConfig,
                          label: language.registerVerifyTitle,
                          value: configuration.insertPassVerify,
                        ),
                        SecondaryBooleanConfigWidget(
                          onChange: (checked) =>
                              configuration.setConfigs(updateVerify: checked),
                          description:
                              language.updatePasswordLeakVerificationConfig,
                          label: language.updateVerificationTitle,
                          value: configuration.updatePassVerify,
                        ),
                      ],
                      headerIcon: Icons.security_outlined,
                    ),
                    const HashPassConfigDivider(),
                    BooleanConfigWidget(
                      onChange: (checked) =>
                          configuration.setConfigs(tooltips: checked),
                      description: language.helpConfigDescription,
                      label: language.helpConfigTitle,
                      icon: Icons.help_outline,
                      value: configuration.showHelpTooltips,
                    ),
                    const HashPassConfigDivider(),
                    HashPassRadioConfig<HashPassCardStyle>(
                      label: language.cardStyleConfigTitle,
                      description: language.cardStyleConfigDescription,
                      selectedValue: configuration.cardStyle,
                      values: HashPassCardStyle.values,
                      onSelect: (selectedStyle) {
                        if (selectedStyle.style == CardStyle.SIMPLE) {
                          HashPassMessage.show(
                            message: language.simpleCardShowcase,
                            title:
                                "${language.cardStyleConfigTitle}: ${language.simple}",
                          );
                        }
                        configuration.setConfigs(cardStyle: selectedStyle);
                      },
                      icon: Icons.subtitles_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class HashPassConfigDivider extends StatelessWidget {
  const HashPassConfigDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Divider(),
    );
  }
}
