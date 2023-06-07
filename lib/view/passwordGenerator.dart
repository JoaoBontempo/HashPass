import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/passwordGeneratorProvider.dart';
import 'package:hashpass/provider/passwordRegisterProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/view/hashPassScreen.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/view/passwordRegister.dart';
import 'package:hashpass/widgets/animations/booleanHide.dart';
import 'package:hashpass/widgets/cards/hashPassCard.dart';
import 'package:hashpass/widgets/data/button.dart';
import 'package:hashpass/widgets/data/copyButton.dart';
import 'package:hashpass/widgets/data/switch.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';

class PasswordGeneratorScreen extends HashPassStatelessWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  Widget localeBuild(context, language) =>
      Consumer2<PasswordGeneratorProvider, UserPasswordsProvider>(
        builder: (context, provider, passwordsProvider, widget) =>
            HashPassScreen(
          title: language.passwordGeneratorMenu,
          showHelpIcon: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                HashPassCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      children: [
                        HashPassLabel(
                          text: language.passwordDetails,
                          fontWeight: FontWeight.bold,
                        ),
                        Slider(
                          min: 4,
                          max: 100,
                          value: provider.parameters.size.toDouble(),
                          onChanged: (value) => provider.setParameters(
                            size: value.toInt(),
                          ),
                        ),
                        HashPassLabel(
                          text:
                              "${language.passwordSize}: ${provider.parameters.size}",
                          size: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            HashPassSwitch(
                              onChange: (checked) =>
                                  provider.setParameters(symbols: checked),
                              value: provider.parameters.useSpecialChar,
                              label: language.symbols,
                            ),
                            HashPassSwitch(
                              onChange: (checked) =>
                                  provider.setParameters(lowerCase: checked),
                              value: provider.parameters.useLowerCase,
                              label: language.lowercases,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            HashPassSwitch(
                              onChange: (checked) =>
                                  provider.setParameters(numbers: checked),
                              value: provider.parameters.useNumbers,
                              label: language.numbers,
                            ),
                            HashPassSwitch(
                              onChange: (checked) =>
                                  provider.setParameters(upperCase: checked),
                              value: provider.parameters.useUpperCase,
                              label: language.uppercases,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppTextField(
                            label: language.charBlackList,
                            controller: provider.blackListController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedBooleanContainer(
                  show: provider.generatedPassword.trim().isEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppButton(
                      label: language.generatePassword,
                      width: Get.width,
                      height: 35,
                      onPressed: provider.generatePassword,
                    ),
                  ),
                ),
                AnimatedBooleanContainer(
                  show: provider.generatedPassword.trim().isNotEmpty,
                  child: HashPassCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HashPassLabel(
                          text: language.generatedPassword,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: Get.height * .09,
                          child: Center(
                            child: HashPassLabel(
                              text: provider.generatedPassword,
                              paddingLeft: 15,
                              paddingRight: 15,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              color: Colors.grey,
                              onPressed: () {
                                Password generatedPassword = Password();
                                generatedPassword.setTrueBasePassword(
                                  provider.generatedPassword,
                                );
                                Get.to(
                                  ChangeNotifierProvider<
                                      PasswordRegisterProvider>(
                                    create: (context) =>
                                        PasswordRegisterProvider(
                                            generatedPassword,
                                            passwordsProvider),
                                    builder: (context, widget) =>
                                        const NewPasswordPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.save_outlined),
                            ),
                            CopyTextButton(
                              textToCopy: provider.generatedPassword,
                            ),
                            IconButton(
                              color: Colors.grey,
                              onPressed: provider.generatePassword,
                              icon: const Icon(Icons.replay_outlined),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
