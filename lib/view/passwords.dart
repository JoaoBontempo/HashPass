import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/model/configuration.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/passwordsProvider.dart';
import 'package:hashpass/util/ads.dart';
import 'package:hashpass/util/appContext.dart';
import 'package:hashpass/view/passwordRegister.dart';
import 'package:hashpass/widgets/cards/passwordCard.dart';
import 'package:hashpass/widgets/animations/hideonscroll.dart';
import 'package:hashpass/widgets/cards/simplePasswordCard.dart';
import 'package:hashpass/widgets/configuration/cardStyle.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/snackbar.dart';
import 'package:hashpass/widgets/searchtext.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import '../util/util.dart';

class PasswordsMenu extends StatefulWidget {
  const PasswordsMenu({Key? key}) : super(key: key);

  @override
  _PasswordsMenuState createState() => _PasswordsMenuState();
}

class _PasswordsMenuState extends State<PasswordsMenu> {
  final GlobalKey key = GlobalKey();
  final GlobalKey floatingButtonKey = GlobalKey();
  final GlobalKey cardKey = GlobalKey();
  final GlobalKey saveKey = GlobalKey();
  final GlobalKey editKey = GlobalKey();
  final GlobalKey removeKey = GlobalKey();
  final filterController = TextEditingController();
  late final ScrollController scroller;
  late BannerAd bannerAd;
  bool showSearchField = true;

  @override
  void initState() {
    scroller = ScrollController();
    scroller.addListener(scrollListener);
    HashPassContext.scroller = scroller;
    HashPassContext.keys = [
      floatingButtonKey,
      key,
      cardKey,
      editKey,
      removeKey,
      saveKey
    ];
    super.initState();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: ADType.BANNER.id,
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

  void newPasswordScreen(PasswordProvider provider) {
    Get.focusScope!.unfocus();
    Get.to(ChangeNotifierProvider<PasswordProvider>.value(
      value: provider,
      child: NewPasswordPage(
        onRegister: (password) {
          HashPassSnackBar.show(message: "Senha cadastrada com sucesso!");
          Util.senhas.add(password);
          provider.addPassword(password);
        },
      ),
    ));
  }

  void onPasswordDelete(PasswordProvider provider, Password password) async {
    provider.removePassword(password);
    setState(() {
      showSearchField = true;
      filterController.text = '';
    });
  }

  void onPasswordUpdate() {
    HashPassSnackBar.show(
      message: "Informações atualizadas com sucesso!",
      type: SnackBarType.SUCCESS,
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
    return Consumer<PasswordProvider>(
      builder: (context, provider, widget) => Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Showcase(
            key: floatingButtonKey,
            description: "Toque aqui para cadastrar uma nova senha",
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => newPasswordScreen(provider),
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
                        description:
                            "Utilize este campo para filtrar suas senhas cadastradas por título ou por credencial",
                        child: AppSearchText(
                          placeholder: "Pesquisar título, credencial...",
                          controller: filterController,
                          onChange: (filter) => provider.filterPasswords,
                        ),
                      ),
                    ),
                    provider.filteredPasswords.isEmpty
                        ? const Center(
                            child: Text("Nenhuma senha encontrada!"),
                          )
                        : Expanded(
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              key: Key(provider.filteredPasswords.toString()),
                              padding: const EdgeInsets.only(
                                  bottom: kFloatingActionButtonMargin + 100),
                              controller: scroller,
                              scrollDirection: Axis.vertical,
                              itemCount: provider.filteredPasswords.length,
                              itemBuilder: (context, index) {
                                switch (
                                    Configuration.instance.cardStyle.style) {
                                  case CardStyle.DEFAULT:
                                    return PasswordCard(
                                      isExample: index == 0,
                                      cardKey: cardKey,
                                      editKey: editKey,
                                      removeKey: removeKey,
                                      saveKey: saveKey,
                                      senha: provider.filteredPasswords[index],
                                      onCopy: () => onPasswordCopy(),
                                      onDelete: (password) =>
                                          onPasswordDelete(provider, password),
                                      onUpdate: (password) =>
                                          onPasswordUpdate(),
                                    );
                                  case CardStyle.SIMPLE:
                                    return SimpleCardPassword(
                                      cardKey: cardKey,
                                      editKey: editKey,
                                      removeKey: removeKey,
                                      isExample: index == 0,
                                      password:
                                          provider.filteredPasswords[index],
                                      onCopy: () => onPasswordCopy(),
                                      onDelete: (password) =>
                                          onPasswordDelete(provider, password),
                                      onUpdate: (password) =>
                                          onPasswordUpdate(),
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
                      onPressed: () => newPasswordScreen(provider),
                      child:
                          const HashPassLabel(text: "CADASTRAR UMA NOVA SENHA"),
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
      ),
    );
  }
}
