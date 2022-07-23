import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Util/route.dart';
import 'package:hashpass/Widgets/animations/booleanHide.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class ChooseConfigScreen extends StatefulWidget {
  const ChooseConfigScreen({Key? key}) : super(key: key);

  @override
  State<ChooseConfigScreen> createState() => _FirstConfigurationScreenState();
}

class _FirstConfigurationScreenState extends State<ChooseConfigScreen> {
  double headerOpactity = 0;
  bool showConfigTitle = false;
  bool showConfigDescription = false;
  bool showOptions = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initAnimation());
  }

  void initAnimation() {
    setState(() {
      headerOpactity = 1;
      Future.delayed(const Duration(milliseconds: 3150), () {
        setState(() {
          showConfigDescription = true;
          Future.delayed(const Duration(milliseconds: 650), () {
            setState(() {
              showOptions = true;
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              AnimatedOpacity(
                opacity: headerOpactity,
                duration: const Duration(milliseconds: 1500),
                onEnd: () {
                  setState(() {
                    showConfigTitle = true;
                  });
                },
                child: SizedBox(
                  height: Get.size.height * 0.4,
                  width: Get.size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HashPassLabel(
                        text: "Chave cadastrada com sucesso!",
                        size: 20,
                        fontWeight: FontWeight.bold,
                        paddingBottom: 20,
                        color: Get.theme.hintColor,
                      ),
                      FaIcon(
                        FontAwesomeIcons.checkCircle,
                        size: Get.width * .5,
                        color: Colors.greenAccent,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
                child: Column(
                  children: [
                    AnimatedBooleanContainer(
                      behavior: Curves.decelerate,
                      alignment: Alignment.centerLeft,
                      useHeight: false,
                      duration: const Duration(milliseconds: 1500),
                      show: showConfigTitle,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.settings,
                            color: Colors.grey,
                            size: 20,
                          ),
                          HashPassLabel(
                            text: "Configurações",
                            size: 17,
                            fontWeight: FontWeight.bold,
                            paddingLeft: 10,
                          ),
                        ],
                      ),
                    ),
                    AnimatedBooleanContainer(
                      useWidth: false,
                      alignment: Alignment.bottomCenter,
                      behavior: Curves.decelerate,
                      show: showConfigDescription,
                      child: const HashPassLabel(
                        text: "O HashPass possui algumas configurações para que sua experiência "
                            "com o app seja personalizada, como temporizador de visualização de senha, "
                            "verificação de vazamento de senha, ícones de ajuda dentre outras opções."
                            "\n\n"
                            "Deseja utilizar as configurações padrão e alterá-las posteriormente ou deseja configurar o app agora?",
                        textAlign: TextAlign.justify,
                        size: 14,
                        paddingTop: 20,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedBooleanContainer(
                show: showOptions,
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 10),
                  child: SizedBox(
                    width: Get.size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Configuration.setDefaultConfig();
                            HashPassRoute.to("/setEntrance", context);
                          },
                          child: const HashPassLabel(
                            text: "USAR CONFIGURAÇÕES PADRÃO",
                          ),
                        ),
                        TextButton(
                          onPressed: () => HashPassRoute.to("/firstConfig", context),
                          child: const HashPassLabel(
                            text: "QUERO CONFIGURAR O APP",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
