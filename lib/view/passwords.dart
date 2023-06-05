import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/provider/passwordCardProvider.dart';
import 'package:hashpass/provider/passwordRegisterProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
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

  void newPasswordScreen(UserPasswordsProvider provider) {
    Get.focusScope!.unfocus();
    Get.to(MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPasswordsProvider>.value(value: provider),
        ChangeNotifierProvider<PasswordRegisterProvider>(
            create: (context) => PasswordRegisterProvider(Password(), provider))
      ],
      builder: (context, _) => const NewPasswordPage(),
    ));
  }

  void onPasswordDelete(
      UserPasswordsProvider provider, Password password) async {
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserPasswordsProvider, Configuration>(
      builder: (context, userPasswordsProvider, configuration, widget) =>
          Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Showcase(
            key: floatingButtonKey,
            description: "Toque aqui para cadastrar uma nova senha",
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => newPasswordScreen(userPasswordsProvider),
            ),
          ),
        ),
        body: userPasswordsProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : userPasswordsProvider.getPasswords().isNotEmpty
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
                              onChange: userPasswordsProvider.filterPasswords,
                            ),
                          ),
                        ),
                        userPasswordsProvider.filteredPasswords.isEmpty
                            ? const Center(
                                child: Text("Nenhuma senha encontrada!"),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  key: Key(
                                    userPasswordsProvider.filteredPasswords
                                        .toString(),
                                  ),
                                  padding: const EdgeInsets.only(
                                    bottom: kFloatingActionButtonMargin + 100,
                                  ),
                                  controller: scroller,
                                  scrollDirection: Axis.vertical,
                                  itemCount: userPasswordsProvider
                                      .filteredPasswords.length,
                                  itemBuilder: (context, index) {
                                    bool isExampleCard = index == 0;
                                    return MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider<
                                            UserPasswordsProvider>.value(
                                          value: userPasswordsProvider,
                                        ),
                                        ChangeNotifierProvider<
                                            PasswordCardProvider>(
                                          create: (context) =>
                                              PasswordCardProvider(
                                            userPasswordsProvider
                                                .filteredPasswords[index],
                                            isHelpExample: isExampleCard,
                                          ),
                                        ),
                                      ],
                                      builder: (context, _) =>
                                          configuration.cardStyle.style ==
                                                  CardStyle.DEFAULT
                                              ? PasswordCard(
                                                  isExample: isExampleCard,
                                                  cardKey: cardKey,
                                                  editKey: editKey,
                                                  removeKey: removeKey,
                                                  saveKey: saveKey,
                                                )
                                              : SimpleCardPassword(
                                                  cardKey: cardKey,
                                                  editKey: editKey,
                                                  removeKey: removeKey,
                                                  isExample: isExampleCard,
                                                ),
                                    );
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
                          onPressed: () =>
                              newPasswordScreen(userPasswordsProvider),
                          child: const HashPassLabel(
                              text: "CADASTRAR UMA NOVA SENHA"),
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
