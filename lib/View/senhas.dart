import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/View/passwordRegister.dart';
import 'package:hashpass/Widgets/cards/passwordCard.dart';
import 'package:hashpass/Widgets/animations/hideonscroll.dart';
import 'package:hashpass/Widgets/cards/simplePasswordCard.dart';
import 'package:hashpass/Widgets/configuration/cardStyle.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/snackbar.dart';
import 'package:hashpass/Widgets/searchtext.dart';
import '../Util/util.dart';

class MenuSenhas extends StatefulWidget {
  const MenuSenhas({Key? key}) : super(key: key);

  @override
  _MenuSenhasState createState() => _MenuSenhasState();
}

class _MenuSenhasState extends State<MenuSenhas> {
  final filterController = TextEditingController();
  late ScrollController scroller;
  late BannerAd bannerAd;
  late List<Senha> passwords = Util.senhas;

  @override
  void initState() {
    scroller = ScrollController();
    super.initState();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', //Util.adMobAppID,
      listener: BannerAdListener(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  void newPasswordScreen() {
    Get.focusScope!.unfocus();
    Get.to(
      NewPasswordPage(
        onCadastro: (senha) {
          setState(() {
            HashPassSnackBar.show(message: "Senha cadastrada com sucesso!");
            Util.senhas.add(senha);
            passwords = Util.senhas;
          });
        },
      ),
    );
  }

  void onPasswordDelete(int code, int index) {
    if (code == 1) {
      setState(() {
        Util.senhas.removeWhere((_password) => _password.id == passwords[index].id);
        passwords = Util.senhas;
        filterController.text = '';
      });
    }
    HashPassSnackBar.show(
      message: code == 1 ? "Senha excluída com sucesso!" : "Ocorreu um erro ao excluir a senha, tente novamente",
      type: code == 1 ? SnackBarType.SUCCESS : SnackBarType.ERROR,
    );
  }

  void onPasswordSimpleUpdate(int code) {
    HashPassSnackBar.show(
      message: code == 1 ? "Informações atualizadas com sucesso!" : "Ocorreu um erro ao atualizar as informações, tente novamente",
      type: code == 1 ? SnackBarType.SUCCESS : SnackBarType.ERROR,
    );
  }

  void onPasswordCopy() {
    HashPassSnackBar.show(
      message: "Senha copiada!",
      duration: const Duration(milliseconds: 2500),
    );
  }

  void onPasswordCompleteUpdate() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => newPasswordScreen(),
        ),
      ),
      body: Util.senhas.isNotEmpty
          ? GestureDetector(
              onTap: () => Get.focusScope!.unfocus(),
              child: Column(
                children: [
                  AnimatedHide(
                    height: 60,
                    controller: scroller,
                    child: AppSearchText(
                      placeholder: "Título, credencial, e-mail, usuário...",
                      controller: filterController,
                      onChange: (filter) {
                        Util.isInFilter = filter.isNotEmpty;
                        setState(() {
                          passwords = Util.senhas.where((password) {
                            String query = filter.toLowerCase();
                            return password.titulo.toLowerCase().contains(query) || password.credencial.toLowerCase().contains(query);
                          }).toList();
                        });
                      },
                    ),
                  ),
                  passwords.isEmpty
                      ? const Center(
                          child: Text("Nenhuma senha encontrada!"),
                        )
                      : Expanded(
                          child: ListView.builder(
                            key: Key(passwords.toString()),
                            padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
                            controller: scroller,
                            scrollDirection: Axis.vertical,
                            itemCount: passwords.length,
                            itemBuilder: (context, index) {
                              switch (Configuration.instance.cardStyle.style) {
                                case CardStyle.DEFAULT:
                                  return PasswordCard(
                                    senha: passwords[index],
                                    onCopy: () => onPasswordCopy(),
                                    onDelete: (code) => onPasswordDelete(code, index),
                                    onUpdate: (code) => onPasswordSimpleUpdate(code),
                                  );
                                case CardStyle.SIMPLE:
                                  return SimpleCardPassword(
                                    password: passwords[index],
                                    onCopy: () => onPasswordCopy(),
                                    onDelete: (code) => onPasswordDelete(code, index),
                                  );
                              }
                            },
                          ),
                        ),
                ],
              ),
            )
          : SizedBox(
              width: Get.size.width,
              height: Get.size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Nenhuma senha foi cadastrada!"),
                  TextButton(
                    onPressed: () => newPasswordScreen(),
                    child: const HashPassLabel(text: "CADASTRAR UMA NOVA SENHA"),
                  )
                ],
              ),
            ),
      bottomSheet: Container(
        width: Get.width,
        height: bannerAd.size.height.toDouble(),
        color: Colors.transparent,
        child: Center(
          child: AdWidget(ad: bannerAd),
        ),
      ),
    );
  }
}
