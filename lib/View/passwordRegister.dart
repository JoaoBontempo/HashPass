import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/DTO/leakPassDTO.dart';
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

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({
    Key? key,
    this.onRegister,
    this.onUpdate,
    this.password,
    this.basePassword,
  }) : super(key: key);
  final Senha? password;
  final String? basePassword;
  final Function(Senha)? onRegister;
  final Function(Senha, int)? onUpdate;

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  List<HashFunction> algoritmos = HashCrypt.algoritmos;
  late HashFunction? algoritmoSelecionado;
  bool isAvancado = false;
  final tituloEC = TextEditingController();
  final credencialEC = TextEditingController();
  final senhaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCriptografado = false;

  late PasswordLeakDTO leakObject = PasswordLeakDTO(leakCount: 0);

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
          leakCount: leakObject.leakCount,
        );
        senha = await SenhaDBSource().inserirSenha(senha);
        HashPassRoute.to("/index", context);
        widget.onRegister!(senha);
      },
    );
  }

  void updatePassword() {
    ValidarSenhaGeral.show(
      onValidate: (key) async {
        widget.password!.credencial = credencialEC.text;
        widget.password!.avancado = isAvancado;
        widget.password!.algoritmo = algoritmoSelecionado == null ? 0 : algoritmoSelecionado!.index;
        widget.password!.criptografado = isCriptografado;
        widget.password!.leakCount = leakObject.leakCount;
        widget.password!.senhaBase = await HashCrypt.cipherString(senhaEC.text, key);

        widget.onUpdate!(widget.password!, await SenhaDBSource().atualizarSenha(widget.password!));
      },
    );
  }

  void screenAction() {
    if (isRegister) {
      insertPassword();
    } else {
      updatePassword();
    }
  }

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
    algoritmoSelecionado = algoritmos[0];

    if (!isRegister) {
      senhaEC.text = widget.basePassword!;
      tituloEC.text = widget.password!.titulo;
      credencialEC.text = widget.password!.credencial;
      if (widget.password!.criptografado) algoritmoSelecionado = algoritmos.firstWhere((hashFunc) => hashFunc.index == widget.password!.algoritmo);
      useCredential = widget.password!.credencial.isNotEmpty;
      isAvancado = widget.password!.avancado;
      leakObject = PasswordLeakDTO(leakCount: widget.password!.leakCount);
      hasPasswordVerification = true;
    }

    super.initState();
  }

  void setAdvancedPassword(bool isAdvanced) {
    setState(() {
      isAvancado = isAdvanced;
    });
  }

  bool get isRegister => widget.password == null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        return await HashPassMessage.show(
              title: "Confirmar",
              message: "Tem certeza que deseja cancelar ${isRegister ? 'o cadastro' : 'a edição'} da senha?",
              type: MessageType.YESNO,
            ) ==
            MessageResponse.YES;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isRegister ? "Nova senha" : "Alterar senha"),
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: HashPassLabel(
                      text: isRegister ? "Cadastrar nova senha" : widget.password!.titulo,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: isRegister,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AppTextField(
                        maxLength: 50,
                        icon: Icons.edit_outlined,
                        label: "Título",
                        padding: 0,
                        controller: tituloEC,
                        validator: isRegister
                            ? Validatorless.multiple([
                                Validatorless.required("O título é obrigatório"),
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
                          maxLength: 225,
                          icon: Icons.lock_outline,
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
                                    leakObject = response;
                                    hasPasswordVerification = true;
                                    isVerifiedPassword = response.leakCount == 0;
                                  },
                                );
                              },
                            );
                          },
                          suffixIcon: hasPasswordVerification && Configuration.instance.insertPassVerify ? leakObject.getLeakWidget() : null,
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
                        "A credencial pode ser seu nome de usuário, e-mail, CPF, ou qualquer outra informação "
                        "que deve ser utilizada junto com a senha que deseja guardar",
                    label: "Salvar credencial",
                    value: useCredential,
                    onChange: (isSelected) {
                      setState(() {
                        credencialEC.text = "";
                        useCredential = isSelected;
                      });
                    },
                  ),
                  AnimatedBooleanContainer(
                    show: useCredential,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AppTextField(
                        maxLength: 70,
                        label: "Credencial",
                        padding: 0,
                        icon: FontAwesomeIcons.user,
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
                  AnimatedBooleanContainer(
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
                      label: isRegister ? "Cadastrar senha" : "Salvar",
                      width: Get.size.width * .5,
                      height: 35,
                      onPressed: () async {
                        if (Util.validateForm(formKey)) {
                          tituloEC.text = tituloEC.text.trim();
                          senhaEC.text = senhaEC.text.trim();
                          credencialEC.text = credencialEC.text.trim();
                          if (Configuration.instance.insertPassVerify && !isVerifiedPassword) {
                            HashPassMessage.show(
                              message: leakObject.status == LeakStatus.LEAKED
                                  ? "A senha que você está tentando ${isRegister ? 'cadastrar' : 'salvar'} já foi vazada! Você deseja ${isRegister ? 'cadastrá-la' : 'salvá-la'}"
                                  : "Não foi possível verificar sua senha, pois não há conexão com a internet. Deseja ${isRegister ? 'cadastrar' : 'salvar'} sua senha?",
                              title: leakObject.status == LeakStatus.LEAKED ? "Senha vazada" : "Senha não verificada",
                              type: MessageType.YESNO,
                            ).then((action) {
                              if (action == MessageResponse.YES) screenAction();
                            });
                            return;
                          }

                          screenAction();
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