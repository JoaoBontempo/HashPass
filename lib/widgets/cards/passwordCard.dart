import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/passwordCardProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/security/hash.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/cards/hashPassCard.dart';
import 'package:hashpass/widgets/data/checkBox.dart';
import 'package:hashpass/widgets/data/dropDown.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:validatorless/validatorless.dart';

class PasswordCard extends HashPassStatelessWidget {
  const PasswordCard({
    Key? key,
    this.isExample = false,
    required this.cardKey,
    required this.saveKey,
    required this.editKey,
    required this.removeKey,
  }) : super(key: key);
  final bool isExample;
  final GlobalKey cardKey;
  final GlobalKey saveKey;
  final GlobalKey editKey;
  final GlobalKey removeKey;

  @override
  Widget localeBuild(context, language) =>
      Consumer2<PasswordCardProvider, UserPasswordsProvider>(
        builder: (context, passwordProvider, userPasswordsProvider, _) =>
            Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 12,
            bottom: 12,
            right: 17,
          ),
          child: ShowcaseHashPassCard(
            showcaseKey: passwordProvider.isHelpExample ? cardKey : GlobalKey(),
            description: language.defaultCardShowcase,
            child: Form(
              key: passwordProvider.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20,
                            right: passwordProvider.showSecurityUpdateIcon
                                ? 10
                                : 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: passwordProvider.showSecurityUpdateIcon,
                              child: passwordProvider.leakInformation
                                  .getLeakWidget(size: 16),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: HashPassLabel(
                          overflow: TextOverflow.fade,
                          paddingTop: 10,
                          paddingRight: 20,
                          paddingBottom: 10,
                          text: passwordProvider.password.title,
                          color: Get.theme.hintColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => passwordProvider
                            .toUpdatePassword(userPasswordsProvider),
                        icon: Showcase(
                          key: isExample ? editKey : GlobalKey(),
                          description: language.editPasswordShwocase,
                          child: const Icon(Icons.edit),
                        ),
                        color: Get.theme.hintColor,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: passwordProvider.password.credential.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: AppTextField(
                        maxLength: 70,
                        icon: FontAwesomeIcons.user,
                        label: language.credential,
                        padding: 0,
                        controller: passwordProvider.credentialController,
                        fontColor: Get.theme.colorScheme.tertiary,
                        borderColor: Get.theme.hintColor,
                        labelStyle: TextStyle(
                          color: Get.theme.colorScheme.tertiary,
                          fontSize: 17,
                        ),
                        validator: passwordProvider
                                .password.credential.isNotEmpty
                            ? HashPassValidator.empty(language.emptyCredential)
                            : Validatorless.min(0, ''),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 10, right: 20),
                            child: AppTextField(
                              maxLength: 225,
                              icon: Icons.lock_outline,
                              label: passwordProvider.password.useCriptography
                                  ? language.basePassword
                                  : language.password,
                              padding: 0,
                              labelStyle: const TextStyle(fontSize: 17),
                              validator: Validatorless.multiple(
                                [
                                  HashPassValidator.empty(
                                    language.emptyPassword,
                                  ),
                                  Validatorless.min(
                                    4,
                                    language.shortPassword,
                                  ),
                                ],
                              ),
                              controller: passwordProvider.passwordController,
                              obscureText: true,
                              borderColor: Get.theme.hintColor,
                              fontColor: Get.theme.colorScheme.tertiary,
                              onChange: passwordProvider
                                  .handlePasswordTextFieldChanges,
                              suffixIcon: passwordProvider.enablePasswordDelete
                                  ? const Icon(
                                      Icons.close,
                                      color: Colors.redAccent,
                                    )
                                  : Icon(
                                      Icons.history,
                                      color: Get.theme.hintColor,
                                    ),
                              suffixIconClick: passwordProvider
                                      .enablePasswordDelete
                                  ? passwordProvider.deletePasswordFromTextField
                                  : passwordProvider.restorePasswordHistory,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: passwordProvider.password.useCriptography,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HashPassDropDown<HashAlgorithm>(
                            isLightBackground: !HashPassTheme.isDarkMode,
                            itens: HashAlgorithm.values,
                            onChange: passwordProvider.setAlgorithm,
                            hintText: language.hashFunction,
                            selectedItem:
                                passwordProvider.password.hashFunction,
                          ),
                          HashPassCheckBox(
                            onChange: (isSelected) => passwordProvider
                                .password.isAdvanced = isSelected,
                            value: passwordProvider.password.isAdvanced,
                            label: language.advanced,
                            labelSize: 14,
                            labelColor: Get.theme.hintColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      bottom: 10,
                      left: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            //TODO: Add showcases
                            IconButton(
                              onPressed: passwordProvider.copyPassword,
                              icon: Showcase(
                                key: isExample ? removeKey : GlobalKey(),
                                description: language.deletePasswordShowCase,
                                child: const Icon(Icons.copy),
                              ),
                              color: Get.theme.hintColor,
                            ),
                            IconButton(
                              onPressed: () => passwordProvider.showPassword,
                              icon: Showcase(
                                key: isExample ? saveKey : GlobalKey(),
                                description: language.savePasswordShowcase,
                                child: const Icon(Icons.visibility_outlined),
                              ),
                              color: Get.theme.hintColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.focusScope!.unfocus();
                                passwordProvider
                                    .deletePassword(userPasswordsProvider);
                              },
                              icon: Showcase(
                                key: isExample ? removeKey : GlobalKey(),
                                description: language.deletePasswordShowCase,
                                child: const Icon(Icons.delete_outline),
                              ),
                              color: Colors.redAccent,
                            ),
                            IconButton(
                              onPressed: () =>
                                  passwordProvider.updatePassword(context),
                              icon: Showcase(
                                key: isExample ? saveKey : GlobalKey(),
                                description: language.savePasswordShowcase,
                                child: const Icon(Icons.save_outlined),
                              ),
                              color: Get.theme.hintColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
