import 'package:flutter/material.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/View/nova_senha.dart';
import 'package:hashpass/Widgets/card_senha.dart';

import '../Util/util.dart';

class MenuSenhas extends StatefulWidget {
  const MenuSenhas({Key? key}) : super(key: key);

  @override
  _MenuSenhasState createState() => _MenuSenhasState();
}

class _MenuSenhasState extends State<MenuSenhas> {
  late bool hasSenhas;

  @override
  void initState() {
    SenhaDBSource().getTodasSenhas().then((value) {
      setState(() {
        Util.senhas.addAll(value);
        hasSenhas = Util.senhas.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NovaSenhaPage(
                onCadastro: (senha) {
                  setState(() {
                    debugPrint("Senha cadastrada: " + senha.toString());
                    Util.senhas.add(senha);
                    hasSenhas = Util.senhas.isNotEmpty;
                  });
                },
              ),
            ),
          );
        },
      ),
      body: hasSenhas
          ? Container(
              color: Colors.transparent,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: Util.senhas.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 12,
                      bottom: 12,
                      right: 20,
                    ),
                    child: CardSenha(
                      senha: Util.senhas[index],
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
                            Util.senhas.remove(Util.senhas[index]);
                            hasSenhas = Util.senhas.isNotEmpty;
                          });
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
            )
          : Center(
              child: Text("Nenhuma senha foi cadastrada!"),
            ),
    );
  }
}
