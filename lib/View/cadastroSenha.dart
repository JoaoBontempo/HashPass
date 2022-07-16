import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Model/hashFunction.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Themes/theme.dart';
import 'package:hashpass/Util/cryptography.dart';
import 'package:hashpass/Util/route.dart';
import 'package:hashpass/Util/util.dart';
import 'package:hashpass/View/configuracoes.dart';
import 'package:hashpass/Widgets/animations/booleanHide.dart';
import 'package:hashpass/Widgets/data/button.dart';
import 'package:hashpass/Widgets/data/checkBox.dart';
import 'package:hashpass/Widgets/data/dropDown.dart';
import 'package:hashpass/Widgets/data/radioButton.dart';
import 'package:hashpass/Widgets/data/textfield.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/messageBox.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import 'package:validatorless/validatorless.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({Key? key, required this.onCadastro}) : super(key: key);
  final Function(Senha) onCadastro;

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  List<HashFunction> algoritmos = HashCrypt.algoritmos;
  late HashFunction? algoritmoSelecionado;
  bool isAvancado = false;
  final tituloEC = TextEditingController();
  final credencialEC = TextEditingController();
  final senhaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCriptografado = false;
  int leakCount = 0;

  void insertPassword() {
    ValidarSenhaGeral.show(
      onValidate: (key) async {
        Senha senha = Senha(
          titulo: tituloEC.text,
          credencial: credencialEC.text,
          senhaBase: await HashCrypt.cipherString(senhaEC.text, key),
          avancado: isAvancado,
          algoritmo: algoritmoSelecionado == null ? 0 : algoritmoSelecionado!.index,
          criptografado: isCriptografado,
          leakCount: leakCount,
        );
        senha = await SenhaDBSource().inserirSenha(senha);
        HashPassRoute.to("/index", context);
        widget.onCadastro(senha);
      },
    );
  }

  final Icon leakedIcon = const Icon(
    Icons.warning,
    color: Colors.redAccent,
  );

  final Icon notLeakedIcon = const Icon(
    Icons.verified_user,
    color: Colors.greenAccent,
  );

  late Icon verifyPassIcon;
  bool hasPasswordVerification = false;
  bool isVerifiedPassword = false;
  String isLeakedMessage = '';
  bool isDeleting = false;
  bool useCredential = true;

  bool hidePassword = true;
  String hidePasswordLabel = 'Mostrar senha';

  @override
  void initState() {
    verifyPassIcon = leakedIcon;
    algoritmoSelecionado = algoritmos[0];
    super.initState();
  }

  void setAdvancedPassword(bool isAdvanced) {
    setState(() {
      isAvancado = isAdvanced;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        return await HashPassMessage.show(
              title: "Confirmar",
              message: "Tem certeza que deseja cancelar o cadastro da senha?",
              type: MessageType.YESNO,
            ) ==
            MessageResponse.YES;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nova senha"),
        ),
        body: SingleChildScrollView(
          reverse: false,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: HashPassLabel(
                      text: "Cadastrar nova senha",
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AppTextField(
                      label: "Título",
                      padding: 0,
                      controller: tituloEC,
                      validator: Validatorless.multiple([
                        Validatorless.required("O título é obrigatório"),
                      ]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: AppTextField(
                          label: "Senha",
                          padding: 0,
                          obscureText: hidePassword,
                          controller: senhaEC,
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required("A senha é obrigatória"),
                              Validatorless.min(4, 'A senha é pequena demais'),
                            ],
                          ),
                          onChange: (password) {
                            if (password.isEmpty || password.length < 4) {
                              isDeleting = true;
                              setState(() {
                                hasPasswordVerification = false;
                              });
                              return;
                            } else {
                              isDeleting = false;
                            }
                            HashCrypt.verifyPassowordLeak(password).then(
                              (response) {
                                if (isDeleting) {
                                  return;
                                }
                                setState(
                                  () {
                                    hasPasswordVerification = true;
                                    isLeakedMessage = response.message;
                                    verifyPassIcon = response.leakCount == 0 ? notLeakedIcon : leakedIcon;
                                    isVerifiedPassword = response.leakCount == 0;
                                    leakCount = response.leakCount;
                                  },
                                );
                              },
                            );
                          },
                          suffixIcon: hasPasswordVerification && Configuration.instance.insertPassVerify
                              ? Tooltip(
                                  margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
                                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: const Duration(seconds: 3),
                                  message: isLeakedMessage,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: verifyPassIcon,
                                  ),
                                  textStyle: TextStyle(
                                    color: verifyPassIcon.color == Colors.greenAccent ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: verifyPassIcon.color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                            hidePasswordLabel = hidePassword ? 'Mostrar senha' : 'Ocultar senha';
                          });
                        },
                        child: HashPassLabel(
                          text: hidePasswordLabel,
                          size: 11,
                        ),
                      )
                    ],
                  ),
                  const HashPassConfigDivider(),
                  TooltippedCheckBox(
                    tooltip: "Marque esta caixa caso deseje salvar a credencial relacionada a esta senha. "
                        "A credencial pode ser seu nome de usuário, e-mail, CPF, ou qualquer outra informação"
                        "que deve ser utilizada junto com a senha que deseja guardar",
                    label: "Salvar credencial",
                    value: useCredential,
                    onChange: (isSelected) {
                      setState(() {
                        useCredential = isSelected;
                      });
                    },
                  ),
                  AnimtedBooleanContainer(
                    show: useCredential,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AppTextField(
                        label: "Credencial",
                        padding: 0,
                        controller: credencialEC,
                        validator: useCredential
                            ? Validatorless.multiple([
                                Validatorless.required("A credencial é obrigatória"),
                              ])
                            : Validatorless.min(0, ''),
                      ),
                    ),
                  ),
                  TooltippedCheckBox(
                    tooltip: "Ao marcar esta caixa, sua senha real será a "
                        "combinação entre uma senha base e um algoritmo hash.",
                    label: "Usar hash",
                    value: isCriptografado,
                    onChange: (isSelected) {
                      setState(() {
                        isCriptografado = isSelected;
                      });
                    },
                  ),
                  AnimtedBooleanContainer(
                    show: isCriptografado,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const HashPassLabel(
                              text: "Algoritmo:",
                              paddingRight: 20,
                            ),
                            HashPassDropDown<HashFunction>(
                              isLightBackground: !HashPassTheme.isDarkMode,
                              itens: HashCrypt.algoritmos,
                              onChange: (function) {
                                setState(() {
                                  algoritmoSelecionado = HashCrypt.algoritmos.firstWhere(
                                    (algoritmo) => algoritmo.index == function.index,
                                  );
                                });
                              },
                              hintText: "Função hash",
                              selectedItem: algoritmoSelecionado!,
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
                              group: isAvancado,
                              label: "Modo normal",
                              tooltip: "Sua senha final será a senha base com o algoritmo hash aplicado.",
                              onSelect: (selected) => setAdvancedPassword(false),
                            ),
                            TooltippedRadioButton(
                              value: true,
                              group: isAvancado,
                              label: "Modo avançado",
                              tooltip: "Além do algoritmo hash, sua senha real terá uma criptografia simétrica adicional.",
                              onSelect: (selected) => setAdvancedPassword(true),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 25),
                    child: AppButton(
                      label: "Cadastrar senha",
                      width: Get.size.width * .5,
                      height: 35,
                      onPressed: () async {
                        if (Util.validateForm(formKey)) {
                          tituloEC.text = tituloEC.text.trim();
                          senhaEC.text = senhaEC.text.trim();
                          credencialEC.text = credencialEC.text.trim();
                          if (Configuration.instance.insertPassVerify && !isVerifiedPassword) {
                            HashPassMessage.show(
                              message: "A senha que você está tentando cadastar já foi vazada! Você deseja cadastrá-la mesmo assim?",
                              title: "Senha vazada",
                              type: MessageType.YESNO,
                            ).then((action) {
                              if (action == MessageResponse.YES) insertPassword();
                            });
                            return;
                          }
                          insertPassword();
                        }
                      },
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
          margin: EdgeInsets.only(left: 20, right: MediaQuery.of(context).size.width * .5, top: 5),
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
          checkColor: HashPassTheme.isDarkMode ? AppColors.SECONDARY_DARK : AppColors.ACCENT_LIGHT_2,
          onChange: (isSelected) => onChange(isSelected),
          value: value,
          labelSize: 15,
          label: label,
        ),
        Tooltip(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
