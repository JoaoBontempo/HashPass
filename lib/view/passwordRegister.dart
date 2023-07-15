import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/passwordRegisterProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/view/configuration.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/animations/booleanHide.dart';
import 'package:hashpass/widgets/data/button.dart';
import 'package:hashpass/widgets/data/checkBox.dart';
import 'package:hashpass/widgets/data/dropDown.dart';
import 'package:hashpass/widgets/data/radioButton.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class NewPasswordPage extends HashPassStatelessWidget {
  const NewPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget localeBuild(context, language) =>
      Consumer2<PasswordRegisterProvider, UserPasswordsProvider>(
        builder:
            (context, registerProvider, passwordsProvider, defaultWidget) =>
                WillPopScope(
          onWillPop: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            bool cancelEditing = await HashPassMessage.show(
                  title: language.confirm,
                  message: registerProvider.isNewPassword
                      ? language.confirmNewPasswordSave
                      : language.confirmPasswordSave,
                  type: MessageType.YESNO,
                ) ==
                MessageResponse.YES;

            if (cancelEditing) registerProvider.resetPasswordState();

            return cancelEditing;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                registerProvider.isNewPassword
                    ? language.newPassword
                    : language.editPassword,
              ),
            ),
            body: SingleChildScrollView(
              reverse: false,
              child: Form(
                key: registerProvider.formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: HashPassLabel(
                          text: registerProvider.isNewPassword
                              ? language.registerNewPassword
                              : registerProvider.password.title,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Visibility(
                        visible: registerProvider.isNewPassword,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AppTextField(
                            maxLength: 50,
                            icon: Icons.edit_outlined,
                            label: language.title,
                            padding: 0,
                            controller: registerProvider.titleController,
                            validator: registerProvider.isNewPassword
                                ? Validatorless.multiple([
                                    HashPassValidator.empty(
                                      language.requiredTitle,
                                    ),
                                  ])
                                : Validatorless.min(0, ''),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: AppTextField(
                              maxLength: 150,
                              icon: Icons.lock_outline,
                              label: language.password,
                              padding: 0,
                              obscureText: registerProvider.hidePassword,
                              controller: registerProvider.passwordController,
                              validator: Validatorless.multiple(
                                [
                                  HashPassValidator.empty(
                                    language.requiredPassword,
                                  ),
                                  Validatorless.min(
                                    4,
                                    language.passwordMinimumSizeMessage,
                                  ),
                                ],
                              ),
                              onChange: registerProvider
                                  .handlePasswordTextFieldChanges,
                              suffixIcon: registerProvider
                                          .passwordHasBeenVerified &&
                                      ((Configuration
                                                  .instance.insertPassVerify &&
                                              registerProvider.isNewPassword) ||
                                          (Configuration
                                                  .instance.updatePassVerify &&
                                              !registerProvider.isNewPassword))
                                  ? registerProvider.leakInformation
                                      .getLeakWidget()
                                  : null,
                            ),
                          ),
                          GestureDetector(
                            onTap: registerProvider.changePasswordVisibility,
                            child: HashPassLabel(
                              text: registerProvider.hidePassword
                                  ? language.showPassword
                                  : language.hidePassword,
                              size: 11,
                            ),
                          )
                        ],
                      ),
                      const HashPassConfigDivider(),
                      TooltippedCheckBox(
                        tooltip: language.useCredentialTooltip,
                        label: language.saveCredential,
                        value: registerProvider.useCredential,
                        onChange: registerProvider.setUseCredential,
                      ),
                      AnimatedBooleanContainer(
                        show: registerProvider.useCredential,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AppTextField(
                            maxLength: 70,
                            label: language.credential,
                            padding: 0,
                            icon: FontAwesomeIcons.user,
                            controller: registerProvider.credentialController,
                            validator: registerProvider.useCredential
                                ? Validatorless.multiple([
                                    HashPassValidator.empty(
                                      language.emptyCredential,
                                    ),
                                  ])
                                : Validatorless.min(0, ''),
                          ),
                        ),
                      ),
                      TooltippedCheckBox(
                        tooltip: language.useHashTooltip,
                        label: language.useHash,
                        value: registerProvider.password.useCriptography,
                        onChange: registerProvider.setUseCriptography,
                      ),
                      AnimatedBooleanContainer(
                        show: registerProvider.password.useCriptography,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                HashPassLabel(
                                  text: "${language.algorithm}:",
                                  paddingRight: 20,
                                ),
                                HashPassDropDown<HashAlgorithm>(
                                  isLightBackground: !HashPassTheme.isDarkMode,
                                  itens: HashAlgorithm.values,
                                  onChange: registerProvider.setAlgorithm,
                                  hintText: language.hashFunction,
                                  selectedItem:
                                      registerProvider.password.hashAlgorithm,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                ),
                                child: Text("${language.cipherMode}:"),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TooltippedRadioButton(
                                  value: false,
                                  group: registerProvider.password.isAdvanced,
                                  label: language.normalCipher,
                                  tooltip: language.normalCipherTooltip,
                                  onSelect: registerProvider.setAdvanced,
                                ),
                                TooltippedRadioButton(
                                  value: true,
                                  group: registerProvider.password.isAdvanced,
                                  label: language.advanced,
                                  tooltip: language.advancedCipherTooltip,
                                  onSelect: registerProvider.setAdvanced,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 25),
                        child: AppButton(
                          label: registerProvider.isNewPassword
                              ? language.registerPassword
                              : language.save,
                          width: Get.size.width * .5,
                          height: 35,
                          onPressed: () =>
                              registerProvider.savePassword(context),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class TooltippedRadioButton extends StatelessWidget {
  const TooltippedRadioButton({
    Key? key,
    required this.value,
    required this.group,
    required this.label,
    required this.tooltip,
    required this.onSelect,
  }) : super(key: key);
  final bool value;
  final bool group;
  final String label;
  final String tooltip;
  final Function(bool) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: HashPassRadioButton<bool>(
            label: label,
            value: value,
            group: group,
            onSelect: (selected) => onSelect(selected),
          ),
        ),
        Tooltip(
          margin: EdgeInsets.only(
              left: 20, right: MediaQuery.of(context).size.width * .5, top: 5),
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 10),
          message: tooltip,
          child: Visibility(
            visible: Configuration.instance.showHelpTooltips,
            child: const Icon(
              Icons.help_outline,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}

class TooltippedCheckBox extends StatelessWidget {
  const TooltippedCheckBox({
    Key? key,
    required this.tooltip,
    required this.label,
    required this.value,
    required this.onChange,
    this.duration = 10,
  }) : super(key: key);
  final String tooltip;
  final String label;
  final bool value;
  final Function(bool) onChange;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HashPassCheckBox(
          onChange: (isSelected) => onChange(isSelected),
          value: value,
          labelSize: 15,
          label: label,
        ),
        Tooltip(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          triggerMode: TooltipTriggerMode.tap,
          showDuration: Duration(seconds: duration),
          message: tooltip,
          child: Visibility(
            visible: Configuration.instance.showHelpTooltips,
            child: const Icon(
              Icons.help_outline,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
