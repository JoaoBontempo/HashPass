import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/appLanguage.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/animations/animatedOpacityList.dart';
import 'package:hashpass/widgets/configuration/booleanConfig.dart';
import 'package:hashpass/widgets/configuration/cardStyle.dart';
import 'package:hashpass/widgets/configuration/dropdownConfiguration.dart';
import 'package:hashpass/widgets/configuration/radioConfig.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';

class FirstConfigScreen extends HashPassStatelessWidget {
  const FirstConfigScreen({Key? key}) : super(key: key);

  @override
  Widget localeBuild(context, language) => Consumer<Configuration>(
        builder: (context, configuration, widget) => Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: Colors.grey.shade300,
                          size: 27,
                        ),
                        Expanded(
                          child: HashPassLabel(
                            paddingLeft: 20,
                            text: language.initialSettings,
                            size: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedOpacitytList(
                  widgets: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: DropDownConfiguration<HashPassLanguage>(
                        selectedValue:
                            HashPassLanguage.fromLocale(configuration.language),
                        onChange: (language) =>
                            configuration.setConfigs(language: language.locale),
                        label: language.language,
                        icon: Icons.language_outlined,
                        values: HashPassLanguage.values,
                      ),
                    ),
                    BooleanConfigWidget(
                      description: language.timerConfigDescription,
                      label: language.timerConfigTitle,
                      icon: Icons.timer_outlined,
                      onChange: (checked) =>
                          configuration.setConfigs(useTimer: checked),
                      value: configuration.hasTimer,
                    ),
                    BooleanConfigWidget(
                      description:
                          language.updateAndInsertLeakConfigDescription,
                      label: language.passworkLeakMenu,
                      icon: Icons.security_outlined,
                      onChange: (checked) => configuration.setConfigs(
                        insertVerify: checked,
                        updateVerify: checked,
                      ),
                      value: configuration.insertPassVerify &&
                          configuration.updatePassVerify,
                    ),
                    BooleanConfigWidget(
                      onChange: (checked) => configuration.setConfigs(
                        tooltips: checked,
                      ),
                      description: language.helpConfigDescription,
                      label: language.helpConfigTitle,
                      icon: Icons.help_outline_outlined,
                      value: configuration.showHelpTooltips,
                    ),
                    HashPassRadioConfig<HashPassCardStyle>(
                      label: language.cardStyleConfigTitle,
                      description: language.cardStyleConfigDescription,
                      selectedValue: configuration.cardStyle,
                      values: HashPassCardStyle.values,
                      onSelect: (selectedStyle) => configuration.setConfigs(
                        cardStyle: selectedStyle,
                      ),
                      icon: Icons.subtitles_outlined,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => HashPassRouteManager.to(
                              HashPassRoute.ENTRANCE, context),
                          child: HashPassLabel(
                            paddingRight: 20,
                            text: language.next.toUpperCase(),
                          ),
                        ),
                      ),
                    ),
                  ],
                  duration: 850,
                ),
              ],
            ),
          ),
        ),
      );
}
