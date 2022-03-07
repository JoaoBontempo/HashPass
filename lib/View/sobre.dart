import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Themes/colors.dart';

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
                  Theme.of(context).primaryColor == AppColors.SECONDARY_DARK ? "assets/images/logo-dark.png" : "assets/images/logo-light.png",
                  width: MediaQuery.of(context).size.width * .4,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "HashPass é um software que tem o objetivo de ser uma solução simples para armazenar as senhas dos seus apps "
                  "e serviços de forma segura, utilizando criptografia. ",
                  textAlign: TextAlign.justify,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 15),
                  child: Text("Versão: 1.0.0"),
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
                  children: [
                    Link(
                      target: LinkTarget.blank,
                      uri: Uri.parse("https://www.linkedin.com/in/jo%C3%A3o-vitor-pedon-bontempo-978077228/"),
                      builder: (context, followLink) => SizedBox(
                        width: MediaQuery.of(context).size.width * .35,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            launch("https://github.com/JoaoBontempo");
                          },
                          icon: const FaIcon(FontAwesomeIcons.github),
                          label: const Text("GitHub"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .35,
                      child: Link(
                        target: LinkTarget.blank,
                        uri: Uri.parse(Uri.encodeFull("https://www.linkedin.com/in/jo%C3%A3o-vitor-pedon-bontempo-978077228/")),
                        builder: (context, followLink) => ElevatedButton.icon(
                          onPressed: () {
                            launch("https://www.linkedin.com/in/jo%C3%A3o-vitor-pedon-bontempo-978077228/");
                          },
                          icon: const FaIcon(FontAwesomeIcons.linkedin),
                          label: const Text("LinkedIn"),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF0073B1),
                            textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(
                  "@HashPass - Todos os direitos reservados",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
