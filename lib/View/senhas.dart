import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hashpass/View/nova_senha.dart';
import 'package:hashpass/Widgets/card_senha.dart';
import 'package:hashpass/Widgets/hideonscroll.dart';
import 'package:hashpass/Widgets/searchtext.dart';

import '../Model/senha.dart';
import '../Util/util.dart';

class MenuSenhas extends StatefulWidget {
  const MenuSenhas({Key? key}) : super(key: key);

  @override
  _MenuSenhasState createState() => _MenuSenhasState();
}

class _MenuSenhasState extends State<MenuSenhas> {
  bool hasSenhas = true;
  late List<Senha> senhasView;
  final filterController = TextEditingController();
  late ScrollController scroller;
  double showPadding = 0;
  late BannerAd bannerAd;
  bool isBannerReady = false;

  @override
  void initState() {
    scroller = ScrollController();
    hasSenhas = Util.senhas.isNotEmpty;
    senhasView = Util.senhas;
    super.initState();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', //Util.adMobAppID,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          isBannerReady = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        debugPrint("Erro ao carregar o banner: ${error.message}");
        isBannerReady = false;
        ad.dispose();
      }),
      request: AdRequest(),
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
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NovaSenhaPage(
                  onCadastro: (senha) {
                    setState(() {
                      senhasView = Util.senhas;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Senha cadastrada com sucesso!",
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.greenAccent,
                        ),
                      );
                      debugPrint("Senha cadastrada: " + senha.toString());
                      senhasView.add(senha);
                      hasSenhas = senhasView.isNotEmpty;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      body: hasSenhas
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
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
                        final senhas = Util.senhas.where((senha) {
                          String tituloSenha = senha.titulo.toLowerCase();
                          String credential = senha.credencial.toLowerCase();
                          String query = filter.toLowerCase();

                          return tituloSenha.contains(query) || credential.contains(query);
                        }).toList();

                        setState(() {
                          senhasView = senhas;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      key: new Key(senhasView.toString()),
                      padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
                      controller: scroller,
                      scrollDirection: Axis.vertical,
                      itemCount: senhasView.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 12,
                            bottom: 12,
                            right: 20,
                          ),
                          child: CardSenha(
                            senha: senhasView[index],
                            onUpdate: (code) {
                              if (code == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Informações atualizadas com sucesso!",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Ocorreu um erro ao atualizar as informações, tente novamente"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            onDelete: (code) {
                              if (code == 1) {
                                setState(() {
                                  Util.removePassword(senhasView[index]);
                                  senhasView = Util.senhas;
                                  hasSenhas = senhasView.isNotEmpty;
                                });
                                filterController.text = '';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Senha excluída com sucesso!",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Ocorreu um erro ao excluir a senha, tente novamente"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
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
        width: MediaQuery.of(context).size.width,
        height: bannerAd.size.height.toDouble(),
        color: Colors.transparent,
        child: Center(child: AdWidget(ad: bannerAd)),
      ),
    );
  }
}
