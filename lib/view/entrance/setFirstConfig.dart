import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/widgets/animations/animatedOpacityList.dart';
import 'package:hashpass/widgets/configuration/booleanConfig.dart';
import 'package:hashpass/widgets/configuration/cardStyle.dart';
import 'package:hashpass/widgets/configuration/radioConfig.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';

class FirstConfigScreen extends StatelessWidget {
  const FirstConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Configuration>(
      builder: (context, configuration, widget) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 50, bottom: 20, left: 20, right: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.grey.shade300,
                        size: 27,
                      ),
                      Expanded(
                        child: HashPassLabel(
                          paddingLeft: 20,
                          text: "Configurações iniciais",
                          size: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedOpacitytList(widgets: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: BooleanConfigWidget(
                    description:
                        "Ativar/desativar o temporizador de senha. Se ativado, suas senhas ficarão "
                        "visíveis por um determinado tempo quando quiser visualizá-las, como uma medida de segurança adicional. ",
                    label: "Temporizador de senha",
                    icon: Icons.timer,
                    onChange: (checked) =>
                        configuration.setConfigs(useTimer: checked),
                    value: configuration.hasTimer,
                  ),
                ),
                BooleanConfigWidget(
                  description:
                      "Ativar/desativar a verificação de vazamento de senha ao cadastrar e ao atualizar uma senha.",
                  label: "Verificação de vazamento",
                  icon: Icons.security,
                  onChange: (checked) => configuration.setConfigs(
                      insertVerify: checked, updateVerify: checked),
                  value: configuration.insertPassVerify &&
                      configuration.updatePassVerify,
                ),
                BooleanConfigWidget(
                  onChange: (checked) =>
                      configuration.setConfigs(tooltips: checked),
                  description:
                      "Habilita ou desabilita ícones (?) para informações e explicações de ajuda em relação a como o aplicativo funciona.",
                  label: "Habilitar ajuda",
                  icon: Icons.help,
                  value: configuration.showHelpTooltips,
                ),
                HashPassRadioConfig<HashPassCardStyle>(
                  label: "Estilo de card",
                  description:
                      "Determina o estilo dos cards aplicativo ao listar suas senhas. "
                      "O estilo simples será um card mais minimalista e o padrão será um card mais completo.",
                  group: configuration.cardStyle,
                  values: HashPassCardStyle.values,
                  onSelect: (selectedStyle) =>
                      configuration.setConfigs(cardStyle: selectedStyle),
                  icon: Icons.subtitles,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => HashPassRouteManager.to(
                          HashPassRoute.ENTRANCE, context),
                      child: const HashPassLabel(
                        paddingRight: 20,
                        text: "CONTINUAR",
                      ),
                    ),
                  ),
                ),
              ], duration: 850),
            ],
          ),
        ),
      ),
    );
  }
}
