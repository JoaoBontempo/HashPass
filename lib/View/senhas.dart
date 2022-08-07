import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/Model/configuration.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/appContext.dart';
import 'package:hashpass/View/passwordRegister.dart';
import 'package:hashpass/Widgets/cards/passwordCard.dart';
import 'package:hashpass/Widgets/animations/hideonscroll.dart';
import 'package:hashpass/Widgets/cards/simplePasswordCard.dart';
import 'package:hashpass/Widgets/configuration/cardStyle.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:hashpass/Widgets/interface/snackbar.dart';
import 'package:hashpass/Widgets/searchtext.dart';
import 'package:showcaseview/showcaseview.dart';
import '../Util/util.dart';

class MenuSenhas extends StatefulWidget {
  const MenuSenhas({Key? key}) : super(key: key);

  @override
  _MenuSenhasState createState() => _MenuSenhasState();
}

class _MenuSenhasState extends State<MenuSenhas> {
  final GlobalKey key = GlobalKey();
  final GlobalKey floatingButtonKey = GlobalKey();
  final GlobalKey cardKey = GlobalKey();
  final GlobalKey saveKey = GlobalKey();
  final GlobalKey editKey = GlobalKey();
  final GlobalKey removeKey = GlobalKey();
  final filterController = TextEditingController();
  late final ScrollController scroller;
  late BannerAd bannerAd;
  late List<Senha> passwords = Util.senhas;
  bool showSearchField = true;

  @override
  void initState() {
    scroller = ScrollController();
    scroller.addListener(scrollListener);
    HashPassContext.scroller = scroller;
    HashPassContext.keys = [floatingButtonKey, key, cardKey, editKey, removeKey, saveKey];
    super.initState();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: Util.adBannerID,
      listener: BannerAdListener(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    scroller.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    if (Util.isInFilter || Util.isDeleting) {
      _showSearchField(true);
      return;
    }
    if (Util.senhas.isEmpty) {
      _showSearchField(false);
      return;
    }
    final scrollDirection = scroller.position.userScrollDirection;
    if (scroller.offset == 0) {
      _showSearchField(true);
      return;
    }

    if (scrollDirection == ScrollDirection.forward) {
      _showSearchField(true);
    } else if (scrollDirection == ScrollDirection.reverse) {
      _showSearchField(false);
    }
  }

  void _showSearchField(bool show) {
    setState(() {
      showSearchField = show;
    });
  }

  void newPasswordScreen() {
    Get.focusScope!.unfocus();
    Get.to(
      NewPasswordPage(
        onRegister: (senha) {
          setState(() {
            HashPassSnackBar.show(message: "Senha cadastrada com sucesso!");
            Util.senhas.add(senha);
            passwords = Util.senhas;
          });
        },
      ),
    );
  }

  void onPasswordDelete(int code, int index) async {
    if (code == 1) {
      setState(() {
        showSearchField = true;
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

  void onPasswordUpdate(int code) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Showcase(
          key: floatingButtonKey,
          description: "Toque aqui para cadastrar uma nova senha",
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => newPasswordScreen(),
          ),
        ),
      ),
      body: Util.senhas.isNotEmpty
          ? GestureDetector(
              onTap: () => Get.focusScope!.unfocus(),
              child: Column(
                children: [
                  AnimatedHide(
                    isVisible: showSearchField,
                    height: 60,
                    controller: scroller,
                    child: Showcase(
                      key: key,
                      description: "Utilize este campo para filtrar suas senhas cadastradas por título ou por credencial",
                      child: AppSearchText(
                        placeholder: "Pesquisar título, credencial...",
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
                  ),
                  passwords.isEmpty
                      ? const Center(
                          child: Text("Nenhuma senha encontrada!"),
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            key: Key(passwords.toString()),
                            padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
                            controller: scroller,
                            scrollDirection: Axis.vertical,
                            itemCount: passwords.length,
                            itemBuilder: (context, index) {
                              switch (Configuration.instance.cardStyle.style) {
                                case CardStyle.DEFAULT:
                                  return PasswordCard(
                                    isExample: index == 0,
                                    cardKey: cardKey,
                                    editKey: editKey,
                                    removeKey: removeKey,
                                    saveKey: saveKey,
                                    senha: passwords[index],
                                    onCopy: () => onPasswordCopy(),
                                    onDelete: (code) => onPasswordDelete(code, index),
                                    onUpdate: (code) => onPasswordUpdate(code),
                                  );
                                case CardStyle.SIMPLE:
                                  return SimpleCardPassword(
                                    cardKey: cardKey,
                                    editKey: editKey,
                                    removeKey: removeKey,
                                    isExample: index == 0,
                                    password: passwords[index],
                                    onCopy: () => onPasswordCopy(),
                                    onDelete: (code) => onPasswordDelete(code, index),
                                    onUpdate: (code) => onPasswordUpdate(code),
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
