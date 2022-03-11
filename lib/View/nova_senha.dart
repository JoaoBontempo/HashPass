import 'package:flutter/material.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Model/hash_function.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/Widgets/button.dart';
import 'package:hashpass/Widgets/confirmdialog.dart';
import 'package:hashpass/Widgets/textfield.dart';
import 'package:hashpass/Widgets/validarChave.dart';
import 'package:validatorless/validatorless.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({Key? key, required this.onCadastro}) : super(key: key);
  final Function(Senha) onCadastro;

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  List<HashFunction> algoritmos = Criptografia.algoritmos;
  late HashFunction? algoritmoSelecionado = null;
  bool isAvancado = false;
  final tituloEC = TextEditingController();
  final credencialEC = TextEditingController();
  final senhaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCriptografado = false;

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
  String isLeakedMessage = '';

  bool hidePassword = true;
  String hidePasswordLabel = 'Mostrar senha';

  @override
  void initState() {
    verifyPassIcon = leakedIcon;
    algoritmoSelecionado = algoritmos[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        showDialog(
          context: context,
          builder: (_) => AppConfirmDialog(
            titulo: "Confirmar",
            descricao: "Tem certeza que deseja cancelar o cadastro da senha?",
            onAction: (isConfirmed) {
              if (isConfirmed) {
                Navigator.of(context).pop();
              }
              return isConfirmed;
            },
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nova senha"),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Cadastrar nova senha",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: AppTextField(
                    label: "Título",
                    padding: 0,
                    controller: tituloEC,
                    validator: Validatorless.multiple([
                      Validatorless.required("O título é obrigatório"),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: AppTextField(
                    label: "Usuário/e-mail/CPF/credencial",
                    padding: 0,
                    controller: credencialEC,
                    validator: Validatorless.multiple([
                      Validatorless.required("A credencial é obrigatória"),
                    ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: hasPasswordVerification ? MediaQuery.of(context).size.width * .85 : MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                              onSave: (password) {
                                Criptografia.verifyPassowordLeak(password).then(
                                  (response) {
                                    setState(
                                      () {
                                        if (password.isEmpty || password.length < 4) {
                                          hasPasswordVerification = false;
                                          return;
                                        }
                                        hasPasswordVerification = true;
                                        isLeakedMessage = response.message;
                                        verifyPassIcon = response.leakCount == 0 ? notLeakedIcon : leakedIcon;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                hidePassword = !hidePassword;
                                hidePasswordLabel = hidePassword ? 'Mostrar senha' : 'Ocultar senha';
                              });
                            },
                            child: Text(
                              hidePasswordLabel,
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: hasPasswordVerification,
                      child: Tooltip(
                        margin: EdgeInsets.only(left: 20, right: MediaQuery.of(context).size.width * .15 + 20, top: 5),
                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                        triggerMode: TooltipTriggerMode.tap,
                        showDuration: const Duration(seconds: 3),
                        message: isLeakedMessage,
                        child: Visibility(
                          visible: Configuration.showHelpTooltips,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: verifyPassIcon,
                          ),
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
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: CheckboxListTile(
                            side: BorderSide(color: Theme.of(context).hintColor),
                            activeColor: Theme.of(context).hintColor,
                            checkColor: Theme.of(context).shadowColor,
                            title: Text(
                              "Senha com criptografia Hash",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            value: isCriptografado,
                            onChanged: (isSelected) {
                              setState(() {
                                isCriptografado = isSelected!;
                              });
                            },
                          ),
                        ),
                        Tooltip(
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 10),
                          message: "Ao marcar esta caixa, sua senha real será a "
                              "combinação entre uma senha base e um algoritmo hash.",
                          child: Visibility(
                            visible: Configuration.showHelpTooltips,
                            child: const Icon(
                              Icons.help_outline,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isCriptografado,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            const Text(
                              "Função Hash:",
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: DropdownButton<int>(
                                items: algoritmos.map<DropdownMenuItem<int>>((HashFunction algoritmo) {
                                  return DropdownMenuItem<int>(
                                    value: algoritmo.index,
                                    child: Text(algoritmo.label),
                                  );
                                }).toList(),
                                onChanged: (idSelecionado) {
                                  setState(() {
                                    algoritmoSelecionado = algoritmos.firstWhere((algoritmo) => algoritmo.index == idSelecionado);
                                  });
                                },
                                hint: const Text(
                                  "Algoritmo hash",
                                  style: TextStyle(color: AppColors.ACCENT_LIGHT),
                                  textAlign: TextAlign.center,
                                ),
                                icon: RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(Icons.chevron_right, color: Theme.of(context).toggleableActiveColor),
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: Theme.of(context).textTheme.bodyText2,
                                underline: Container(
                                  height: 2,
                                  color: Theme.of(context).toggleableActiveColor,
                                ),
                                value: algoritmoSelecionado?.index,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                          child: Text("Modo de criptografia:"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .35,
                                child: RadioListTile(
                                  title: Text(
                                    "Modo normal",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  value: false,
                                  groupValue: isAvancado,
                                  onChanged: (value) {
                                    setState(() {
                                      isAvancado = value as bool;
                                    });
                                  },
                                ),
                              ),
                              Tooltip(
                                margin: EdgeInsets.only(left: 20, right: MediaQuery.of(context).size.width * .5, top: 5),
                                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                triggerMode: TooltipTriggerMode.tap,
                                showDuration: const Duration(seconds: 10),
                                message: "Sua senha final será a senha base com o algoritmo hash aplicado.",
                                child: Visibility(
                                  visible: Configuration.showHelpTooltips,
                                  child: const Icon(
                                    Icons.help_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .41,
                                child: RadioListTile(
                                  title: Text(
                                    "Modo Avançado",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  value: true,
                                  groupValue: isAvancado,
                                  onChanged: (value) {
                                    setState(() {
                                      isAvancado = value as bool;
                                    });
                                  },
                                ),
                              ),
                              Tooltip(
                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .5, right: 20, top: 5),
                                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                triggerMode: TooltipTriggerMode.tap,
                                showDuration: const Duration(seconds: 5),
                                message: "Além do algoritmo hash, sua senha real terá uma criptografia simétrica adicional.",
                                child: Visibility(
                                  visible: Configuration.showHelpTooltips,
                                  child: const Icon(
                                    Icons.help_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
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
                    width: MediaQuery.of(context).size.width * .5,
                    height: 35,
                    onPressed: () async {
                      tituloEC.text = tituloEC.text.trim();
                      senhaEC.text = senhaEC.text.trim();
                      credencialEC.text = credencialEC.text.trim();
                      final formValido = formKey.currentState?.validate() ?? false;
                      if (formValido) {
                        showDialog(
                          context: context,
                          builder: (_) => ValidarSenhaGeral(
                            onValidate: (chaveGeral) async {
                              Navigator.of(context).pop();
                              Senha senha = Senha(
                                titulo: tituloEC.text,
                                credencial: credencialEC.text,
                                senhaBase: await Criptografia.criptografarSenha(senhaEC.text, chaveGeral),
                                avancado: isAvancado,
                                algoritmo: algoritmoSelecionado == null ? 0 : algoritmoSelecionado!.index,
                                criptografado: isCriptografado,
                              );
                              senha = await SenhaDBSource().inserirSenha(senha);
                              Navigator.of(context).pushNamed("/index");
                              widget.onCadastro(senha);
                            },
                          ),
                        );
                      }
                    },
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
