import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/View/cadastroSenha.dart';
import 'package:hashpass/Widgets/cardSenha.dart';
import 'package:hashpass/Widgets/animations/hideonscroll.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Get.focusScope!.unfocus();
            Get.to(
              NovaSenhaPage(
                onCadastro: (senha) {
                  setState(() {
                    HashPassSnackBar.show(message: "Senha cadastrada com sucesso!");
                    Util.senhas.add(senha);
                    passwords = Util.senhas;
                  });
                },
              ),
            );
          },
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
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 12,
                                  bottom: 12,
                                  right: 20,
                                ),
                                child: CardSenha(
                                  senha: passwords[index],
                                  onCopy: () {
                                    HashPassSnackBar.show(
                                      message: "Senha copiada!",
                                      duration: const Duration(seconds: 1),
                                    );
                                  },
                                  onUpdate: (code) {
                                    HashPassSnackBar.show(
                                      message: code == 1
                                          ? "Informações atualizadas com sucesso!"
                                          : "Ocorreu um erro ao atualizar as informações, tente novamente",
                                      type: code == 1 ? SnackBarType.SUCCESS : SnackBarType.ERROR,
                                    );
                                  },
                                  onDelete: (code) {
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
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            )
          : const Center(
              child: Text("Nenhuma senha foi cadastrada!"),
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
