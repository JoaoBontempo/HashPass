import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/Themes/theme.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:url_launcher/url_launcher.dart';

class SobreAppPage extends StatelessWidget {
  const SobreAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre o HashPass"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Image.asset(
                  HashPassTheme.isDarkMode ? "assets/images/logo-dark.png" : "assets/images/logo-light.png",
                  width: Get.size.width * .4,
                ),
              ),
              const HashPassLabel(
                text: "HashPass é um software que tem o objetivo de ser uma solução simples para armazenar as senhas dos seus apps "
                    "e serviços de forma segura, utilizando criptografia. ",
                textAlign: TextAlign.justify,
                padding: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: HashPassLabel(
                  text: "Versão: 1.1.0",
                  paddingLeft: 20,
                  paddingBottom: 15,
                  size: 13,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Desenvolvido por: João Vitor Bontempo",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    SocialMediaButton(
                      link: "https://github.com/JoaoBontempo",
                      label: "GitHub",
                      color: Colors.black,
                      textColor: Colors.white,
                      icon: FaIcon(FontAwesomeIcons.github),
                    ),
                    SocialMediaButton(
                      link: "https://www.linkedin.com/in/jo%C3%A3o-vitor-pedon-bontempo-978077228/",
                      label: "GitHub",
                      color: Color(0xFF0073B1),
                      textColor: Colors.white,
                      icon: FaIcon(FontAwesomeIcons.linkedin),
                    ),
                  ],
                ),
              ),
              HashPassLabel(
                text: "@HashPass - Todos os direitos reservados",
                paddingBottom: 25,
                style: Get.theme.textTheme.bodyText1,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton({
    Key? key,
    required this.link,
    required this.label,
    required this.color,
    required this.textColor,
    required this.icon,
  }) : super(key: key);
  final String link;
  final String label;
  final Color color;
  final Color textColor;
  final FaIcon icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.size.width * .35,
      child: ElevatedButton.icon(
        onPressed: () {
          launch(link);
        },
        icon: icon,
        label: Text(label),
        style: ElevatedButton.styleFrom(
          primary: color,
          textStyle: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
