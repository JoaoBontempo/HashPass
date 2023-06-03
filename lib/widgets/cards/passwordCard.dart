import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/passwordCardProvider.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/widgets/data/checkBox.dart';
import 'package:hashpass/widgets/data/dropDown.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:validatorless/validatorless.dart';

class PasswordCard extends StatelessWidget {
  const PasswordCard({
    Key? key,
    required this.onDelete,
    required this.onUpdate,
    required this.onCopy,
    this.isExample = false,
    required this.cardKey,
    required this.saveKey,
    required this.editKey,
    required this.removeKey,
  }) : super(key: key);
  final Function(Password) onDelete;
  final Function(Password) onUpdate;
  final VoidCallback onCopy;
  final bool isExample;
  final GlobalKey cardKey;
  final GlobalKey saveKey;
  final GlobalKey editKey;
  final GlobalKey removeKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordCardProvider>(
      builder: (context, passwordProvider, _widget) => Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 12,
          bottom: 12,
          right: 20,
        ),
        child: Showcase(
          key: passwordProvider.isHelpExample ? cardKey : GlobalKey(),
          description:
              "Você pode editar algumas informações no próprio card, como a credencial e a senha. Para senhas criptografadas, é possível alterar o algoritmo e o tipo de criptografia.",
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: passwordProvider.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: HashPassLabel(
                          overflow: TextOverflow.fade,
                          paddingTop: 10,
                          paddingLeft: 20,
                          paddingRight: 20,
                          paddingBottom: 10,
                          text: passwordProvider.password.title,
                          color: Get.theme.highlightColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => passwordProvider.toUpdatePassword(
                          (updatedPassword, code) => onUpdate(updatedPassword),
                        ),
                        icon: Showcase(
                          key: isExample ? editKey : GlobalKey(),
                          description:
                              "Toque aqui para editar as informações da sua senha",
                          child: const Icon(Icons.edit),
                        ),
                        color: Get.theme.highlightColor,
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
                        iconColor: Get.theme.colorScheme.tertiary,
                        label: "Credencial",
                        padding: 0,
                        controller: passwordProvider.credentialController,
                        dark: true,
                        fontColor: Get.theme.colorScheme.tertiary,
                        borderColor: Get.theme.highlightColor,
                        labelStyle: TextStyle(
                            color: Get.theme.colorScheme.tertiary,
                            fontSize: 17),
                        validator:
                            passwordProvider.password.credential.isNotEmpty
                                ? HashPassValidator.empty(
                                    "A credencial não pode estar vazia!")
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
                                left: 20, bottom: 15, right: 20),
                            child: AppTextField(
                              maxLength: 225,
                              icon: Icons.lock_outline,
                              iconColor: Get.theme.colorScheme.tertiary,
                              label: passwordProvider.password.useCriptography
                                  ? "Senha base"
                                  : "Senha",
                              padding: 0,
                              labelStyle: TextStyle(
                                  color: Get.theme.colorScheme.tertiary,
                                  fontSize: 17),
                              validator: Validatorless.multiple(
                                [
                                  HashPassValidator.empty(
                                      "A senha não pode estar vazia!"),
                                  Validatorless.min(
                                      4, 'A senha é curta demais!'),
                                ],
                              ),
                              controller: passwordProvider.passwordController,
                              dark: true,
                              obscureText: true,
                              borderColor: Get.theme.highlightColor,
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
                                      color: Get.theme.highlightColor,
                                    ),
                              suffixIconClick: passwordProvider
                                      .enablePasswordDelete
                                  ? passwordProvider.deletePasswordFromTextField
                                  : passwordProvider.restorePasswordHistory,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      passwordProvider.copyPassword(onCopy),
                                  child: HashPassLabel(
                                    text: "Copiar senha",
                                    size: 12,
                                    color: Get.theme.colorScheme.tertiary,
                                  ),
                                ),
                                Visibility(
                                  visible: Configuration
                                          .instance.updatePassVerify &&
                                      passwordProvider.passwordController.text
                                              .trim()
                                              .length >
                                          4,
                                  child: passwordProvider.leakInformation
                                      .getLeakWidget(size: 16),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: passwordProvider.password.useCriptography,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HashPassDropDown<HashAlgorithm>(
                            itens: HashAlgorithm.values,
                            onChange: passwordProvider.setAlgorithm,
                            hintText: "Função hash",
                            selectedItem:
                                passwordProvider.password.hashFunction,
                          ),
                          HashPassCheckBox(
                            onChange: (isSelected) => passwordProvider
                                .password.isAdvanced = isSelected,
                            value: passwordProvider.password.isAdvanced,
                            label: "Avançado",
                            labelSize: 14,
                            labelColor: Get.theme.colorScheme.tertiary,
                            backgroundColor: Get.theme.highlightColor,
                            checkColor: HashPassTheme.isDarkMode
                                ? AppColors.SECONDARY_DARK
                                : AppColors.SECONDARY_LIGHT,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 10, top: 8, bottom: 15, left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => passwordProvider.showPassword(),
                          child: HashPassLabel(
                            text: "VISUALIZAR SENHA",
                            size: 12,
                            color: Get.theme.highlightColor,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.focusScope!.unfocus();
                                passwordProvider.deletePassword((code) =>
                                    onDelete(passwordProvider.password));
                              },
                              icon: Showcase(
                                key: isExample ? removeKey : GlobalKey(),
                                description: "Toque aqui para excluir a senha",
                                child: const Icon(Icons.delete),
                              ),
                              color: Colors.redAccent,
                            ),
                            IconButton(
                              onPressed: () =>
                                  passwordProvider.updatePassword(context),
                              icon: Showcase(
                                key: isExample ? saveKey : GlobalKey(),
                                description:
                                    "Toque aqui para salvar as informações da sua senha",
                                child: const Icon(Icons.save),
                              ),
                              color: Get.theme.highlightColor,
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
      ),
    );
  }
}
