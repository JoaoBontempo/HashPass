import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/dto/leakPassDTO.dart';
import 'package:hashpass/model/configuration.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/util/validator.dart';
import 'package:hashpass/widgets/cards/cardFunctions.dart';
import 'package:hashpass/widgets/data/checkBox.dart';
import 'package:hashpass/widgets/data/dropDown.dart';
import 'package:hashpass/widgets/data/textfield.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:hashpass/widgets/validarChave.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:validatorless/validatorless.dart';

class PasswordCard extends StatefulWidget {
  PasswordCard({
    Key? key,
    required this.senha,
    required this.onDelete,
    required this.onUpdate,
    required this.onCopy,
    this.isExample = false,
    required this.cardKey,
    required this.saveKey,
    required this.editKey,
    required this.removeKey,
  }) : super(key: key);
  Password senha;
  final Function(Password) onDelete;
  final Function(Password) onUpdate;
  final VoidCallback onCopy;
  final bool isExample;
  final GlobalKey cardKey;
  final GlobalKey saveKey;
  final GlobalKey editKey;
  final GlobalKey removeKey;

  @override
  PasswordCardState createState() => PasswordCardState();

  static PasswordCardState? of(BuildContext context) =>
      context.findAncestorStateOfType<PasswordCardState>();
}

class PasswordCardState extends State<PasswordCard> {
  final formKey = GlobalKey<FormState>();
  final senhaEC = TextEditingController();
  final credencialEC = TextEditingController();
  late PasswordLeakDTO leakObject =
      PasswordLeakDTO(leakCount: widget.senha.leakCount);

  late String basePassword;
  String lastText = "";

  bool toDelete = true;
  bool isDeleting = false;
  bool hasPasswordVerification = false;
  bool isVerifiedPassword = true;
  bool hidePassword = true;

  void atualizarParametrosSenha(
      String lastPassword, String newPassword, String credential) {
    widget.senha.credential = credential;
    if (lastPassword != basePassword) {
      widget.senha.basePassword = newPassword;
      basePassword = newPassword;
      senhaEC.text = newPassword;
    }
  }

  @override
  void initState() {
    credencialEC.text = widget.senha.credential;
    senhaEC.text = widget.senha.basePassword;
    basePassword = widget.senha.basePassword;
    isVerifiedPassword = widget.senha.leakCount == 0;

    if (widget.senha.leakCount == -1) {
      HashCrypt.verifyPassowordLeak(basePassword).then(
        (response) {
          setState(
            () {
              widget.senha.leakCount = response.leakCount;
              widget.senha.save();
              leakObject = response;
              hasPasswordVerification = true;
              isVerifiedPassword = response.leakCount == 0;
            },
          );
        },
      );
    }

    super.initState();
  }

  void updatePassword() {
    Get.dialog(
      ValidarSenhaGeral(
        onValidate: (key) async {
          atualizarParametrosSenha(
            senhaEC.text,
            await HashCrypt.cipherString(senhaEC.text, key),
            credencialEC.text,
          );
          await widget.senha.save();
          widget.onUpdate(widget.senha);
          setState(() {
            hasPasswordVerification = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        top: 12,
        bottom: 12,
        right: 20,
      ),
      child: Showcase(
        key: widget.isExample ? widget.cardKey : GlobalKey(),
        description:
            "Você pode editar algumas informações no próprio card, como a credencial e a senha. Para senhas criptografadas, é possível alterar o algoritmo e o tipo de criptografia.",
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Form(
            key: formKey,
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
                        text: widget.senha.title,
                        color: Get.theme.highlightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => PasswordCardFunctions.toUpdatePassword(
                        widget.senha,
                        (_updatedPassword, code) {
                          widget.onUpdate(_updatedPassword);
                          if (code == 1) {
                            setState(() {
                              widget.senha = _updatedPassword;
                              credencialEC.text = _updatedPassword.credential;
                            });
                          }
                        },
                      ),
                      icon: Showcase(
                        key: widget.isExample ? widget.editKey : GlobalKey(),
                        description:
                            "Toque aqui para editar as informações da sua senha",
                        child: const Icon(Icons.edit),
                      ),
                      color: Get.theme.highlightColor,
                    ),
                  ],
                ),
                Visibility(
                  visible: widget.senha.credential.isNotEmpty,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: AppTextField(
                      maxLength: 70,
                      icon: FontAwesomeIcons.user,
                      iconColor: Get.theme.colorScheme.tertiary,
                      label: "Credencial",
                      padding: 0,
                      controller: credencialEC,
                      dark: true,
                      fontColor: Get.theme.colorScheme.tertiary,
                      borderColor: Get.theme.highlightColor,
                      labelStyle: TextStyle(
                          color: Get.theme.colorScheme.tertiary, fontSize: 17),
                      validator: widget.senha.credential.isNotEmpty
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
                            label: widget.senha.useCriptography
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
                                Validatorless.min(4, 'A senha é curta demais!'),
                              ],
                            ),
                            controller: senhaEC,
                            dark: true,
                            obscureText: true,
                            borderColor: Get.theme.highlightColor,
                            fontColor: Get.theme.colorScheme.tertiary,
                            onChange: (text) {
                              setState(() {
                                toDelete = true;
                                if (text.isEmpty || text.trim() == '') {
                                  hasPasswordVerification = false;
                                }
                              });
                              if (text.isEmpty ||
                                  text.trim() == '' ||
                                  text.length < 4) {
                                isDeleting = true;
                                setState(() {
                                  hasPasswordVerification = false;
                                });
                                return;
                              } else {
                                isDeleting = false;
                              }
                              if (Configuration.instance.updatePassVerify) {
                                HashCrypt.verifyPassowordLeak(text).then(
                                  (response) {
                                    if (isDeleting) {
                                      return;
                                    }
                                    setState(
                                      () {
                                        widget.senha.leakCount =
                                            response.leakCount;
                                        leakObject = response;
                                        hasPasswordVerification = true;
                                        isVerifiedPassword =
                                            response.leakCount == 0;
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            suffixIcon: toDelete
                                ? const Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  )
                                : Icon(
                                    Icons.history,
                                    color: Get.theme.highlightColor,
                                  ),
                            suffixIconClick: () {
                              if (toDelete) {
                                setState(() {
                                  lastText = senhaEC.text;
                                  toDelete = false;
                                  senhaEC.text = "";
                                  hasPasswordVerification = false;
                                });
                              } else {
                                setState(() {
                                  toDelete = true;
                                  senhaEC.text = lastText;
                                  if (lastText.length > 4 ||
                                      lastText.isNotEmpty) {
                                    hasPasswordVerification = true;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  PasswordCardFunctions.copyPassword(
                                    widget.senha,
                                    () => widget.onCopy(),
                                  );
                                },
                                child: HashPassLabel(
                                  text: "Copiar senha",
                                  size: 12,
                                  color: Get.theme.colorScheme.tertiary,
                                ),
                              ),
                              Visibility(
                                visible:
                                    Configuration.instance.updatePassVerify &&
                                        senhaEC.text.trim().length > 4,
                                child: leakObject.getLeakWidget(size: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: widget.senha.useCriptography,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 5, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HashPassDropDown<HashAlgorithm>(
                          itens: HashAlgorithm.values,
                          onChange: (algorithm) {
                            setState(() {
                              widget.senha.hashAlgorithm = algorithm;
                            });
                          },
                          hintText: "Função hash",
                          selectedItem: widget.senha.hashFunction,
                        ),
                        HashPassCheckBox(
                          onChange: (isSelected) =>
                              widget.senha.isAdvanced = isSelected,
                          value: widget.senha.isAdvanced,
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
                        onPressed: () =>
                            PasswordCardFunctions.showPassword(widget.senha),
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
                              PasswordCardFunctions.deletePassword(widget.senha,
                                  (code) => widget.onDelete(widget.senha));
                            },
                            icon: Showcase(
                              key: widget.isExample
                                  ? widget.removeKey
                                  : GlobalKey(),
                              description: "Toque aqui para excluir a senha",
                              child: const Icon(Icons.delete),
                            ),
                            color: Colors.redAccent,
                          ),
                          IconButton(
                            onPressed: () async {
                              Get.focusScope!.unfocus();
                              if (Util.validateForm(formKey)) {
                                if (Configuration.instance.updatePassVerify &&
                                    !isVerifiedPassword) {
                                  HashPassMessage.show(
                                    message: leakObject.status ==
                                            LeakStatus.LEAKED
                                        ? "A senha que você está tentando salvar já foi vazada! Você deseja salvá-la mesmo assim?"
                                        : "Não foi possível verificar sua senha, pois não há conexão com a internet. Deseja salvar sua senha mesmo assim?",
                                    title:
                                        leakObject.status == LeakStatus.LEAKED
                                            ? "Senha vazada"
                                            : "Senha não verificada",
                                    type: MessageType.YESNO,
                                  ).then((action) {
                                    if (action == MessageResponse.YES)
                                      updatePassword();
                                  });
                                  return;
                                }
                                HashPassMessage.show(
                                  title: "Confirmar",
                                  message:
                                      "Tem certeza que deseja atualizar os dados desta senha?",
                                  type: MessageType.YESNO,
                                ).then((action) {
                                  if (action == MessageResponse.YES)
                                    updatePassword();
                                });
                              }
                            },
                            icon: Showcase(
                              key: widget.isExample
                                  ? widget.saveKey
                                  : GlobalKey(),
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
    );
  }
}
