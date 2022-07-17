import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Util/route.dart';
import 'package:hashpass/View/configuracoes.dart';
import 'package:hashpass/Widgets/animations/booleanHide.dart';
import 'package:hashpass/Widgets/configuration/booleanConfig.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:local_auth/local_auth.dart';

class FirstConfigScreen extends StatefulWidget {
  const FirstConfigScreen({Key? key}) : super(key: key);

  @override
  State<FirstConfigScreen> createState() => _FirstConfigScreenState();
}

class _FirstConfigScreenState extends State<FirstConfigScreen> {
  bool hasBiometricValidation = false, showContinueButton = false;
  double firstOpacity = 0, secondOpacity = 0, thirdOpacity = 0;

  @override
  void initState() {
    final LocalAuthentication auth = LocalAuthentication();
    auth.isDeviceSupported().then((value) {
      setState(() {
        hasBiometricValidation = value;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        firstOpacity = 1;
      }),
    );
    super.initState();
  }

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
                padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
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
            AnimatedOpacity(
              opacity: firstOpacity,
              onEnd: () => setState(() {
                secondOpacity = 1;
              }),
              duration: const Duration(milliseconds: 750),
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: BooleanConfigWidget(
                  description: "Ativar/desativar o temporizador de senha. Se ativado, suas senhas ficarão "
                      "visíveis por um determinado tempo quando quiser visualizá-las, como uma medida de segurança adicional. ",
                  label: "Temporizador de senha",
                  icon: Icons.timer,
                  onChange: (checked) => Configuration.setConfigs(hasTimer: checked),
                  value: Configuration.instance.hasTimer,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: secondOpacity,
              duration: const Duration(milliseconds: 750),
              onEnd: () => setState(() {
                thirdOpacity = 1;
              }),
              child: BooleanConfigWidget(
                description: "Ativar/desativar a verificação de vazamento de senha ao cadastrar e ao atualizar uma senha.",
                label: "Verificação de vazamento",
                icon: Icons.security,
                onChange: (checked) => Configuration.setConfigs(insertVerify: checked, updateVerify: checked),
                value: Configuration.instance.insertPassVerify && Configuration.instance.updatePassVerify,
              ),
            ),
            AnimatedOpacity(
              opacity: thirdOpacity,
              duration: const Duration(milliseconds: 750),
              onEnd: () => setState(() {
                showContinueButton = true;
              }),
              child: BooleanConfigWidget(
                onChange: (checked) => Configuration.setConfigs(tooltips: checked),
                description: "Habilita ou desabilita ícones (?) para informações e explicações de ajuda em relação a como o aplicativo funciona.",
                label: "Habilitar ajuda",
                icon: Icons.help,
                value: Configuration.instance.showHelpTooltips,
              ),
            ),
            AnimatedBooleanContainer(
              show: showContinueButton,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => HashPassRoute.to("/setEntrance", context),
                    child: const HashPassLabel(
                      paddingRight: 20,
                      text: "CONTINUAR",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
