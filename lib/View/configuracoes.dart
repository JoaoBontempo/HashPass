import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/Widgets/button.dart';
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
  double timer = Configuration.showPasswordTime;
  int theme = Configuration.darkMode;
  bool aceitaBiometria = false;
  final timerEC = TextEditingController();

  @override
  void initState() {
    final LocalAuthentication auth = LocalAuthentication();
    auth.isDeviceSupported().then((value) {
      setState(() {
        aceitaBiometria = value;
        timerEC.text = timer.toInt().toString();
      });
    });
    super.initState();
  }

  void _salvarConfiguracoes() {
    if (timerEC.text == "" || timerEC.text.isEmpty) {
      timerEC.text = "30";
    }
    timer = double.parse(timerEC.text);
    Configuration.setConfigs(theme, timer, isBiometria);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Configurações atualizadas com sucesso!",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );
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
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
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
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text("Tempo de visibilidade: "),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .12,
                          height: 25,
                          child: AppTextField(
                            label: "",
                            controller: timerEC,
                            padding: 0,
                            fontSize: 15,
                            textAlign: TextAlign.center,
                            formatter: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const Text("s"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Text(
                      "Determina a quantidade de tempo que uma senha ficará disponível para visualizá-la ",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppButton(
                    label: "Salvar configurações",
                    width: MediaQuery.of(context).size.width * .5,
                    height: 35,
                    onPressed: () {
                      if (isBiometria) {
                        if (Configuration.isBiometria) {
                          _salvarConfiguracoes();
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (_) => ValidarSenhaGeral(
                            onValidate: (senha) {
                              Criptografia.criarChaveGeral(senha);
                              Navigator.of(context).pop();
                              _salvarConfiguracoes();
                            },
                          ),
                        );
                      } else {
                        _salvarConfiguracoes();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
