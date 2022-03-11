import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/main.dart';
import 'package:local_auth/local_auth.dart';

import '../Widgets/textfield.dart';
import '../Widgets/validarChave.dart';

class MenuConfiguracoes extends StatefulWidget {
  const MenuConfiguracoes({Key? key}) : super(key: key);

  @override
  _MenuConfiguracoesState createState() => _MenuConfiguracoesState();
}

class _MenuConfiguracoesState extends State<MenuConfiguracoes> {
  bool isBiometria = Configuration.isBiometria;
  bool hasTimer = Configuration.hasTimer;
  double timer = Configuration.showPasswordTime;
  int theme = Configuration.darkMode;
  bool aceitaBiometria = false;
  bool onlyVerifiedPasswords = Configuration.onlyVerifiedPasswords;
  bool updatePassVerify = Configuration.updatePassVerify;
  bool insertPassVerify = Configuration.insertPassVerify;
  bool showTooltips = Configuration.showHelpTooltips;
  final timerEC = TextEditingController();

  @override
  void initState() {
    final LocalAuthentication auth = LocalAuthentication();
    auth.isDeviceSupported().then((value) {
      setState(() {
        aceitaBiometria = value;
      });
    });
    setState(() {
      timerEC.text = timer.toInt().toString();
    });
    super.initState();
  }

  void _saveConfiguration() {
    Configuration.setConfigs(
      theme,
      timer,
      isBiometria,
      hasTimer,
      insertPassVerify,
      updatePassVerify,
      showTooltips,
      onlyVerifiedPasswords,
    );
  }

  void _changeTimer(String value) {
    if (value == null || value == '') {
      timerEC.text = "30";
      timer = 30;
    } else {
      timer = double.parse(value);
    }
    _saveConfiguration();
  }

  void _changeValidation() {
    if (Configuration.isBiometria) {
      _saveConfiguration();
      return;
    } else {
      showDialog(
        context: context,
        builder: (_) => ValidarSenhaGeral(
          onValidate: (senha) {
            Criptografia.criarChaveGeral(senha);
            Navigator.of(context).pop();
            _saveConfiguration();
          },
        ),
      );
    }
  }

  void _changeTheme() {
    switch (theme) {
      case 1:
        MyApp.of(context)!.changeTheme(ThemeMode.light);
        break;

      case 2:
        MyApp.of(context)!.changeTheme(ThemeMode.dark);
        break;

      case 3:
        MyApp.of(context)!.changeTheme(ThemeMode.system);
        break;
    }
    _saveConfiguration();
  }

  void _changeHasTimer() {
    debugPrint("Mudou has timer");
    if (!hasTimer) {
      timerEC.text = "30";
      timer = double.parse(timerEC.text);
    }
    _saveConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Visibility(
                  visible: aceitaBiometria,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.fingerprint,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          Row(
                            children: [
                              const Text("Validação biométrica: "),
                              Switch(
                                value: isBiometria,
                                onChanged: (checked) {
                                  setState(() {
                                    isBiometria = checked;
                                    _changeValidation();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 10),
                        child: Text(
                          "Configura a forma de validação da senha geral do app para biometria ou texto.",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.brightness_medium,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          Text("Tema: "),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Column(
                        children: [
                          RadioListTile(
                            title: Text(
                              "Padrão",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            value: 1,
                            groupValue: theme,
                            onChanged: (value) {
                              setState(() {
                                theme = value as int;
                                _changeTheme();
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Escuro",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            value: 2,
                            groupValue: theme,
                            onChanged: (value) {
                              setState(() {
                                theme = value as int;
                                _changeTheme();
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Automático (sistema)",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            value: 3,
                            groupValue: theme,
                            onChanged: (value) {
                              setState(() {
                                theme = value as int;
                                _changeTheme();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: Divider(),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.timer,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                        const Text("Temporizador de senha:"),
                        Checkbox(
                          value: hasTimer,
                          side: BorderSide(color: Theme.of(context).hintColor),
                          activeColor: Theme.of(context).hintColor,
                          checkColor: Theme.of(context).shadowColor,
                          onChanged: (isSelected) {
                            setState(() {
                              hasTimer = isSelected!;
                              _changeHasTimer();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70, right: 20),
                    child: Text(
                      "Ativa ou desativa o temporizador de senha. O temporizador "
                      "serve para limitar a quantidade de tempo que uma senha ficará "
                      "disponível para visualização.",
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Visibility(
                    visible: hasTimer,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 25),
                            child: Row(
                              children: [
                                const Text(
                                  "Duração do temporizador: ",
                                  style: TextStyle(fontSize: 13.5),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * .12,
                                    height: 25,
                                    child: AppTextField(
                                      label: "",
                                      onSave: (value) {
                                        _changeTimer(value);
                                      },
                                      controller: timerEC,
                                      padding: 0,
                                      fontSize: 14,
                                      textAlign: TextAlign.center,
                                      formatter: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                const Text("s"),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 25),
                              child: Text(
                                "Determina a duração do temporizador de senha, em segundos.",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.security,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                        Text("Verificação de senhas"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70, right: 20),
                    child: Text(
                      'Configurações relacionadas com a verificação das senhas informadas por você no sistema '
                      'em bancos de dados de senhas que já foram vazadas na internet.',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 25),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Verificar ao cadastrar:",
                                          style: TextStyle(fontSize: 13.5),
                                        ),
                                        Switch(
                                          value: insertPassVerify,
                                          onChanged: (checked) {
                                            setState(() {
                                              insertPassVerify = checked;
                                            });
                                            _saveConfiguration();
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Ativa a verificação real-time ao cadastrar uma senha.',
                                      style: Theme.of(context).textTheme.headline1,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Verificar ao atualizar:",
                                          style: TextStyle(fontSize: 13.5),
                                        ),
                                        Switch(
                                          value: updatePassVerify,
                                          onChanged: (checked) {
                                            setState(() {
                                              updatePassVerify = checked;
                                            });
                                            _saveConfiguration();
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Ativa a verificação real-time ao atualizar uma senha já cadastrada.',
                                      style: Theme.of(context).textTheme.headline1,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Cadastrar somente verificadas:",
                                          style: TextStyle(fontSize: 13.5),
                                        ),
                                        Switch(
                                          value: onlyVerifiedPasswords,
                                          onChanged: (checked) {
                                            setState(() {
                                              onlyVerifiedPasswords = checked;
                                            });
                                            _saveConfiguration();
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Permite ou não cadastrar uma senha que já foi vazada.',
                                      style: Theme.of(context).textTheme.headline1,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.help,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                        Row(
                          children: [
                            const Text("Habilitar ajuda: "),
                            Switch(
                              value: showTooltips,
                              onChanged: (checked) {
                                setState(() {
                                  showTooltips = checked;
                                });
                                _saveConfiguration();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 10),
                      child: Text(
                        "Habilita ou desabilita ícones (?) para informações e explicações de ajuda em relação a como o aplicativo funciona.",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
