import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/animations/animatedOpacityList.dart';
import 'package:hashpass/widgets/data/button.dart';
import 'package:hashpass/widgets/data/checkBox.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validatorless/validatorless.dart';

class AppWelcomePage extends StatefulWidget {
  const AppWelcomePage({Key? key}) : super(key: key);

  @override
  _AppWelcomePageState createState() => _AppWelcomePageState();
}

class _AppWelcomePageState extends HashPassState<AppWelcomePage> {
  final senhaEC = TextEditingController();
  final passwordTrimCompare = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool privacyPolicy = false;

  @override
  Widget localeBuild(context, language) => Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacitytList(
                  widgets: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: HashPassTheme.getLogo(
                        width: Get.width * 0.5,
                      ),
                    ),
                    HashPassLabel(
                      text: language.welcome,
                      fontWeight: FontWeight.bold,
                      size: 20,
                      color: Get.theme.hintColor,
                    ),
                    WelcomeDescription(
                      description: language.welcomeParagraphOne,
                    ),
                    WelcomeDescription(
                      description: language.welcomeParagraphTwo,
                    ),
                    WelcomeDescription(
                      description: language.welcomeParagraphThree,
                    ),
                    Form(
                      key: formKey,
                      child: AppTextField(
                        icon: Icons.lock_outline,
                        label: language.insertGeneralKey,
                        maxLength: 50,
                        padding: 20,
                        validator: Validatorless.multiple([
                          HashPassValidator.empty(
                            language.emptyFieldMessage,
                          ),
                          Validatorless.compare(
                            passwordTrimCompare,
                            language.passwordShouldNotHaveSpacesMessage,
                          ),
                          Validatorless.min(
                            4,
                            language.passwordMinimumSizeMessage,
                          ),
                        ]),
                        controller: senhaEC,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: HashPassCheckBox(
                        onChange: (checked) => setState(() {
                          privacyPolicy = checked;
                        }),
                        value: privacyPolicy,
                        customLabel: Row(
                          children: [
                            HashPassLabel(
                              text: language.agreeWithTerms,
                              size: 12,
                            ),
                            GestureDetector(
                              child: HashPassLabel(
                                text: language.privacyPolicy.toUpperCase(),
                                color: Get.theme.highlightColor,
                                size: 12,
                              ),
                              onTap: () => launch(
                                  "https://joaobontempo.github.io/HashPassWebsite/hashpass-website/"),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 25,
                      ),
                      child: AppButton(
                        label: language.next.toUpperCase(),
                        width: Get.size.width * .5,
                        height: 35,
                        onPressed: () async {
                          if (!privacyPolicy) {
                            HashPassMessage.show(
                              title: language.privacyPolicy,
                              message: language.shouldAgreePolicy,
                              type: MessageType.OK,
                            );
                          } else {
                            passwordTrimCompare.text = senhaEC.text.trim();
                            if (Util.validateForm(formKey)) {
                              if (await HashCrypt
                                  .setGeneralKeyValidationMessage(
                                senhaEC.text,
                              )) {
                                HashPassRouteManager.to(
                                  HashPassRoute.CHOOSE_CONFIGURATION,
                                  context,
                                );
                              } else {
                                HashPassMessage.show(
                                  message: language.registerGeneralKeyError,
                                  title: language.errorOcurred,
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ],
                  duration: 750,
                ),
              ],
            ),
          ),
        ),
      );
}

class WelcomeDescription extends StatelessWidget {
  const WelcomeDescription({
    Key? key,
    required this.description,
  }) : super(key: key);
  final String description;

  @override
  Widget build(BuildContext context) {
    return HashPassLabel(
      text: description,
      size: 15,
      paddingTop: 15,
      paddingLeft: 20,
      paddingRight: 20,
      textAlign: TextAlign.justify,
    );
  }
}
