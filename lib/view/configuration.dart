import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/widgets/animations/booleanHide.dart';
import 'package:hashpass/widgets/configuration/booleanConfig.dart';
import 'package:hashpass/widgets/configuration/cardStyle.dart';
import 'package:hashpass/widgets/configuration/multiBooleanWidgetConfig.dart';
import 'package:hashpass/widgets/configuration/radioConfig.dart';
import 'package:hashpass/widgets/configuration/secondaryBooleanConfig.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/data/textfield.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  double timer = Configuration.instance.showPasswordTime;
  bool hasBiometricValidation = false;
  late bool isBiometric = Configuration.instance.isBiometria;
  final timerEC = TextEditingController();

  @override
  void initState() {
    timerEC.text = timer.toInt().toString();
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
    return Consumer<Configuration>(
      builder: (context, configuration, widget) => WillPopScope(
        onWillPop: () async {
          HashPassRouteManager.to(HashPassRoute.INDEX, context);
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
                    useState: false,
                    isVisible: hasBiometricValidation,
                    onChange: (checked) {
                      configuration.setConfigs(
                        useBiometricValidation: checked,
                        onBiometricChange: (isBiometricConfig) {
                          setState(
                            () {
                              isBiometric = isBiometricConfig;
                            },
                          );
                        },
                      );
                    },
                    description:
                        "Configura a forma de validação da senha geral do app para biometria ou texto.",
                    label: "Validação biométrica",
                    icon: Icons.fingerprint,
                    value: isBiometric,
                  ),
                  const HashPassConfigDivider(),
                  HashPassRadioConfig<HashPassTheme>(
                    label: "Tema",
                    group: configuration.theme,
                    values: HashPassTheme.values,
                    onSelect: (selectedTheme) =>
                        configuration.setConfigs(theme: selectedTheme),
                    icon: Icons.brightness_6,
                  ),
                  const HashPassConfigDivider(),
                  BooleanConfigWidget(
                    onChange: (checked) =>
                        configuration.setConfigs(useTimer: checked),
                    description:
                        "Ativa ou desativa o temporizador de senha. O temporizador "
                        "serve para limitar a quantidade de tempo que uma senha ficará "
                        "disponível para visualização.",
                    label: "Temporizador de senha",
                    icon: Icons.timer,
                    value: configuration.hasTimer,
                  ),
                  AnimatedBooleanContainer(
                    useWidth: false,
                    show: configuration.hasTimer,
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
                                    width:
                                        MediaQuery.of(context).size.width * .15,
                                    height: 25,
                                    child: AppTextField(
                                      maxLength: 3,
                                      label: "",
                                      onSave: (value) {
                                        if (value.isEmpty) {
                                          timerEC.text = "30";
                                          return;
                                        }

                                        double timer = double.parse(value);

                                        if (timer == 0) {
                                          timerEC.text = "30";
                                          return;
                                        }
                                        print('caiu aqui');
                                        configuration.setConfigs(
                                          timer: timer,
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
                              padding: const EdgeInsets.only(
                                  left: 20, top: 10, right: 20, bottom: 25),
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
                    headerDescription:
                        'Configurações relacionadas com a verificação das senhas informadas por você no sistema '
                        'em bancos de dados de senhas que já foram vazadas na internet.',
                    configurations: [
                      SecondaryBooleanConfigWidget(
                        onChange: (checked) =>
                            configuration.setConfigs(insertVerify: checked),
                        description:
                            'Ativa a verificação real-time ao cadastrar uma senha. Somente será '
                            'possível cadastrar uma senha verificada.',
                        label: "Verificar ao cadastrar",
                        value: configuration.insertPassVerify,
                      ),
                      SecondaryBooleanConfigWidget(
                        onChange: (checked) =>
                            configuration.setConfigs(updateVerify: checked),
                        description:
                            'Ativa a verificação real-time ao atualizar uma senha já cadastrada. Não será '
                            'possível salvar uma senha não verificada.',
                        label: "Verificar ao atualizar",
                        value: configuration.updatePassVerify,
                      ),
                    ],
                    headerIcon: Icons.security,
                  ),
                  const HashPassConfigDivider(),
                  BooleanConfigWidget(
                    onChange: (checked) =>
                        configuration.setConfigs(tooltips: checked),
                    description:
                        "Habilita ou desabilita ícones (?) para informações e explicações de ajuda em relação a como o aplicativo funciona.",
                    label: "Habilitar ajuda",
                    icon: Icons.help,
                    value: configuration.showHelpTooltips,
                  ),
                  const HashPassConfigDivider(),
                  HashPassRadioConfig<HashPassCardStyle>(
                    label: "Estilo de card",
                    description:
                        "Determina o estilo dos cards aplicativo ao listar suas senhas. "
                        "O estilo simples será um card mais minimalista e o padrão será um card mais completo.",
                    group: configuration.cardStyle,
                    values: HashPassCardStyle.values,
                    onSelect: (selectedStyle) {
                      if (selectedStyle.style == CardStyle.SIMPLE) {
                        HashPassMessage.show(
                            message:
                                "Toque uma vez no card para visualizar sua senha. Pressione o card por alguns segundos para copiar a senha.",
                            title: "Card simples");
                      }
                      configuration.setConfigs(cardStyle: selectedStyle);
                    },
                    icon: Icons.subtitles,
                  ),
                ],
              ),
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
