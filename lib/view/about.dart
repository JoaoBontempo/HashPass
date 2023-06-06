import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/util/util.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends HashPassStatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget localeBuild(context, language) => Scaffold(
        appBar: AppBar(
          title: Text("${language.about} HashPass"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Image.asset(
                    HashPassTheme.isDarkMode
                        ? "assets/images/logo-dark.png"
                        : "assets/images/logo-light.png",
                    width: Get.size.width * .4,
                  ),
                ),
                HashPassLabel(
                  text: language.aboutHashPass,
                  textAlign: TextAlign.justify,
                  padding: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: HashPassLabel(
                    text: "${language.version}: ${Util.APP_VERSION}",
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
                  "${language.developedBy}: João Vitor Bontempo",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SocialMediaButton(
                        link: "https://github.com/JoaoBontempo",
                        label: "GitHub",
                        color: Colors.black,
                        textColor: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.github),
                      ),
                      SocialMediaButton(
                        link:
                            "https://www.linkedin.com/in/jo%C3%A3o-vitor-pedon-bontempo-978077228/",
                        label: "LinkedIn",
                        color: Color(0xFF0073B1),
                        textColor: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.linkedin),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
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
