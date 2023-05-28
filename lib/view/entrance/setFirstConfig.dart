import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/model/configuration.dart';
import 'package:hashpass/util/route.dart';
import 'package:hashpass/widgets/animations/animatedOpacityList.dart';
import 'package:hashpass/widgets/configuration/booleanConfig.dart';
import 'package:hashpass/widgets/configuration/cardStyle.dart';
import 'package:hashpass/widgets/configuration/radioConfig.dart';
import 'package:hashpass/widgets/interface/label.dart';

class FirstConfigScreen extends StatefulWidget {
  const FirstConfigScreen({Key? key}) : super(key: key);

  @override
  State<FirstConfigScreen> createState() => _FirstConfigScreenState();
}

class _FirstConfigScreenState extends State<FirstConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Configuration.setConfigs(useTimer: checked),
                  value: Configuration.instance.hasTimer,
                ),
              ),
              BooleanConfigWidget(
                description:
                    "Ativar/desativar a verificação de vazamento de senha ao cadastrar e ao atualizar uma senha.",
                label: "Verificação de vazamento",
                icon: Icons.security,
                onChange: (checked) => Configuration.setConfigs(
                    insertVerify: checked, updateVerify: checked),
                value: Configuration.instance.insertPassVerify &&
                    Configuration.instance.updatePassVerify,
              ),
              BooleanConfigWidget(
                onChange: (checked) =>
                    Configuration.setConfigs(tooltips: checked),
                description:
                    "Habilita ou desabilita ícones (?) para informações e explicações de ajuda em relação a como o aplicativo funciona.",
                label: "Habilitar ajuda",
                icon: Icons.help,
                value: Configuration.instance.showHelpTooltips,
              ),
              HashPassRadioConfig<HashPassCardStyle>(
                label: "Estilo de card",
                description:
                    "Determina o estilo dos cards aplicativo ao listar suas senhas. "
                    "O estilo simples será um card mais minimalista e o padrão será um card mais completo.",
                group: Configuration.instance.cardStyle,
                values: HashPassCardStyle.values,
                onSelect: (selectedStyle) {
                  setState(() {
                    Configuration.instance.cardStyle = selectedStyle;
                  });
                  Configuration.setConfigs(cardStyle: selectedStyle);
                },
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
    );
  }
}
