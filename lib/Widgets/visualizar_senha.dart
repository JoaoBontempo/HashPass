import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Util/criptografia.dart';

import '../Model/senha.dart';

class VisualizacaoSenhaModal extends StatefulWidget {
  const VisualizacaoSenhaModal({
    Key? key,
    required this.senha,
  }) : super(key: key);

  final Senha senha;

  @override
  _VisualizacaoSenhaModalState createState() => _VisualizacaoSenhaModalState();
}

class _VisualizacaoSenhaModalState extends State<VisualizacaoSenhaModal> {
  double tempo = 0;
  double tempoTotal = 30;
  late Timer time;
  double cont = 30;
  String senha = "";
  final Icon toCopy = const Icon(
    Icons.copy,
    color: AppColors.SECONDARY_LIGHT,
  );

  final Icon copied = const Icon(
    Icons.check_circle,
    color: Colors.greenAccent,
  );

  late Icon copyIcon;

  @override
  void initState() {
    copyIcon = toCopy;
    //senha = Criptografia.aplicarAlgoritmos(widget.senha.algoritmo, widget.senha.senhaBase, widget.senha.avancado);
    Criptografia.aplicarAlgoritmos(widget.senha.algoritmo, widget.senha.senhaBase, widget.senha.avancado).then((value) {
      setState(() {
        senha = value;
      });
    });
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (cont > 0) {
          tempo += 1 / tempoTotal;
          cont = cont - 1;
        }
      });
      if (tempo >= 0.99) {
        Navigator.of(context, rootNavigator: true).pop();
        time.cancel();
      }
    });

    super.initState();
  }

  void closeModal() {
    time.cancel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.senha.titulo),
          IconButton(
            onPressed: () {
              closeModal();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(senha),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: tempo,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.SECONDARY_LIGHT),
                        backgroundColor: AppColors.ACCENT_LIGHT.withOpacity(0.3),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.timer,
                                color: AppColors.SECONDARY_LIGHT,
                                size: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "${cont.toInt()} segundos",
                                  style: const TextStyle(
                                    color: AppColors.SECONDARY_LIGHT,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: senha));
                    setState(() {
                      copyIcon = copied;
                      Future.delayed(const Duration(seconds: 1), () {
                        copyIcon = toCopy;
                      });
                    });
                  },
                  icon: copyIcon,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
