import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Themes/theme.dart';
import 'package:hashpass/Util/route.dart';
import 'package:hashpass/Widgets/configuration/booleanConfig.dart';
import 'package:hashpass/Widgets/configuration/multiBooleanWidgetConfig.dart';
import 'package:hashpass/Widgets/configuration/radioConfig.dart';
import 'package:hashpass/Widgets/configuration/secondaryBooleanConfig.dart';
import 'package:local_auth/local_auth.dart';
import '../Widgets/data/textfield.dart';

class MenuConfiguracoes extends StatefulWidget {
  const MenuConfiguracoes({Key? key}) : super(key: key);

  @override
  _MenuConfiguracoesState createState() => _MenuConfiguracoesState();
}

class _MenuConfiguracoesState extends State<MenuConfiguracoes> {
  double timer = Configuration.instance.showPasswordTime;
  bool hasBiometricValidation = false;
  final timerEC = TextEditingController();

  @override
  void initState() {
    timerEC.text = Configuration.instance.showPasswordTime.toInt().toString();
    final LocalAuthentication auth = LocalAuthentication();
    auth.isDeviceSupported().then((value) {
      setState(() {
        hasBiometricValidation = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        HashPassRoute.to("/index", context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Configurações"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                BooleanConfigWidget(
                  isVisible: hasBiometricValidation,
                  onChange: (checked) => Configuration.setConfigs(biometria: checked),
                  description: "Configura a forma de validação da senha geral do app para biometria ou texto.",
                  label: "Validação biométrica",
                  icon: Icons.fingerprint,
                  value: Configuration.instance.isBiometria,
                ),
                const HashPassConfigDivider(),
                HashPassRadioConfig<HashPassTheme>(
                  label: "Tema",
                  group: Configuration.instance.theme,
                  values: HashPassTheme.values,
                  onSelect: (selectedTheme) {
                    setState(() {
                      Configuration.instance.theme = selectedTheme;
                    });
                    Configuration.setConfigs(theme: selectedTheme);
                  },
                  icon: Icons.brightness_6,
                ),
                const HashPassConfigDivider(),
                BooleanConfigWidget(
                  onChange: (checked) {
                    setState(() {
                      Configuration.setConfigs(hasTimer: checked);
                    });
                  },
                  description: "Ativa ou desativa o temporizador de senha. O temporizador "
                      "serve para limitar a quantidade de tempo que uma senha ficará "
                      "disponível para visualização.",
                  label: "Temporizador de senha",
                  icon: Icons.timer,
                  value: Configuration.instance.hasTimer,
                ),
                Visibility(
                  visible: Configuration.instance.hasTimer,
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
                                  width: MediaQuery.of(context).size.width * .15,
                                  height: 25,
                                  child: AppTextField(
                                    label: "",
                                    onSave: (value) {
                                      if (value.isEmpty) return;
                                      Configuration.setConfigs(
                                        timer: double.parse(value),
                                      );
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
                const HashPassConfigDivider(),
                MultiBooleanWConfig(
                  headerLabel: "Verificação de senha",
                  headerDescription: 'Configurações relacionadas com a verificação das senhas informadas por você no sistema '
                      'em bancos de dados de senhas que já foram vazadas na internet.',
                  configurations: [
                    SecondaryBooleanConfigWidget(
                      onChange: (checked) => Configuration.setConfigs(insertVerify: checked),
                      description: 'Ativa a verificação real-time ao cadastrar uma senha. Somente será '
                          'possível cadastrar uma senha verificada.',
                      label: "Verificar ao cadastrar",
                      value: Configuration.instance.insertPassVerify,
                    ),
                    SecondaryBooleanConfigWidget(
                      onChange: (checked) => Configuration.setConfigs(updateVerify: checked),
                      description: 'Ativa a verificação real-time ao atualizar uma senha já cadastrada. Não será '
                          'possível salvar uma senha não verificada.',
                      label: "Verificar ao atualizar",
                      value: Configuration.instance.updatePassVerify,
                    ),
                  ],
                  headerIcon: Icons.security,
                ),
                const HashPassConfigDivider(),
                BooleanConfigWidget(
                  onChange: (checked) => Configuration.setConfigs(tooltips: checked),
                  description: "Habilita ou desabilita ícones (?) para informações e explicações de ajuda em relação a como o aplicativo funciona.",
                  label: "Habilitar ajuda",
                  icon: Icons.help,
                  value: Configuration.instance.showHelpTooltips,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HashPassConfigDivider extends StatelessWidget {
  const HashPassConfigDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Divider(),
    );
  }
}
