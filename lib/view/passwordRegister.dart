import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/passwordRegisterProvider.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/view/configuration.dart';
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

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({
    Key? key,
    this.onRegister,
    this.onUpdate,
    this.password,
    this.basePassword,
  }) : super(key: key);
  final Password? password;
  final String? basePassword;
  final Function(Password)? onRegister;
  final Function(Password, int)? onUpdate;

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordRegisterProvider>(
      builder: (context, provider, defaultWidget) => WillPopScope(
        onWillPop: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          return await HashPassMessage.show(
                title: "Confirmar",
                message:
                    "Tem certeza que deseja cancelar ${provider.isNewPassword ? 'o cadastro' : 'a edição'} da senha?",
                type: MessageType.YESNO,
              ) ==
              MessageResponse.YES;
        },
        child: Scaffold(
          appBar: AppBar(
            title:
                Text(provider.isNewPassword ? "Nova senha" : "Alterar senha"),
          ),
          body: SingleChildScrollView(
            reverse: false,
            child: Form(
              key: provider.formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: HashPassLabel(
                        text: provider.isNewPassword
                            ? "Cadastrar nova senha"
                            : widget.password!.title,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Visibility(
                      visible: provider.isNewPassword,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: AppTextField(
                          maxLength: 50,
                          icon: Icons.edit_outlined,
                          label: "Título",
                          padding: 0,
                          controller: provider.titleController,
                          validator: provider.isNewPassword
                              ? Validatorless.multiple([
                                  HashPassValidator.empty(
                                      "O título é obrigatório"),
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
                            label: "Senha",
                            padding: 0,
                            obscureText: provider.hidePassword,
                            controller: provider.passwordController,
                            validator: Validatorless.multiple(
                              [
                                HashPassValidator.empty(
                                    "A senha é obrigatória!"),
                                Validatorless.min(4,
                                    'A senha deve ter no mínimo 4 caracteres'),
                              ],
                            ),
                            onChange: provider.handlePasswordTextFieldChanges,
                            suffixIcon: provider.passwordHasBeenVerified &&
                                    ((Configuration.instance.insertPassVerify &&
                                            provider.isNewPassword) ||
                                        (Configuration
                                                .instance.updatePassVerify &&
                                            !provider.isNewPassword))
                                ? provider.leakInformation.getLeakWidget()
                                : null,
                          ),
                        ),
                        GestureDetector(
                          onTap: provider.changePasswordVisibility,
                          child: HashPassLabel(
                            text: provider.hidePassword
                                ? 'Mostrar senha'
                                : 'Ocultar senha',
                            size: 11,
                          ),
                        )
                      ],
                    ),
                    const HashPassConfigDivider(),
                    TooltippedCheckBox(
                      tooltip:
                          "Marque esta caixa caso deseje salvar a credencial relacionada a esta senha. "
                          "A credencial pode ser seu nome de usuário, e-mail, CPF, ou qualquer outra informação "
                          "que deve ser utilizada junto com a senha que deseja guardar",
                      label: "Salvar credencial",
                      value: provider.useCredential,
                      onChange: provider.setUseCredential,
                    ),
                    AnimatedBooleanContainer(
                      show: provider.useCredential,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: AppTextField(
                          maxLength: 70,
                          label: "Credencial",
                          padding: 0,
                          icon: FontAwesomeIcons.user,
                          controller: provider.credentialController,
                          validator: provider.useCredential
                              ? Validatorless.multiple([
                                  HashPassValidator.empty(
                                      "A credencial é obrigatória"),
                                ])
                              : Validatorless.min(0, ''),
                        ),
                      ),
                    ),
                    TooltippedCheckBox(
                      tooltip: "Ao marcar esta caixa, sua senha real será a "
                          "combinação entre uma senha base e um algoritmo hash.",
                      label: "Usar hash",
                      value: provider.password.useCriptography,
                      onChange: provider.setUseCriptography,
                    ),
                    AnimatedBooleanContainer(
                      show: provider.password.useCriptography,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const HashPassLabel(
                                text: "Algoritmo:",
                                paddingRight: 20,
                              ),
                              HashPassDropDown<HashAlgorithm>(
                                isLightBackground: !HashPassTheme.isDarkMode,
                                itens: HashAlgorithm.values,
                                onChange: provider.setAlgorithm,
                                hintText: "Função Hash",
                                selectedItem: provider.password.hashAlgorithm,
                              ),
                            ],
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: Text("Modo de criptografia:"),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TooltippedRadioButton(
                                value: false,
                                group: provider.password.isAdvanced,
                                label: "Modo normal",
                                tooltip:
                                    "Sua senha final será a senha base com o algoritmo hash aplicado.",
                                onSelect: provider.setAdvanced,
                              ),
                              TooltippedRadioButton(
                                value: true,
                                group: provider.password.isAdvanced,
                                label: "Modo avançado",
                                tooltip:
                                    "Além do algoritmo hash, sua senha real terá uma criptografia simétrica adicional.",
                                onSelect: provider.setAdvanced,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 25),
                      child: AppButton(
                        label: provider.isNewPassword
                            ? "Cadastrar senha"
                            : "Salvar",
                        width: Get.size.width * .5,
                        height: 35,
                        onPressed: () => provider.savePassword(context),
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
          checkColor: HashPassTheme.isDarkMode
              ? AppColors.SECONDARY_DARK
              : AppColors.ACCENT_LIGHT_2,
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
