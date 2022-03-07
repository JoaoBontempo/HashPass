import 'package:flutter/material.dart';

import '../Model/configuration.dart';
import '../Widgets/verificar_token.dart';

class ChangeMailView extends StatefulWidget {
  const ChangeMailView({
    Key? key,
    required this.onMailChanged,
  }) : super(key: key);
  final Function onMailChanged;

  @override
  _ChangeMailViewState createState() => _ChangeMailViewState();
}

class _ChangeMailViewState extends State<ChangeMailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alterar e-mail"),
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              const Text(
                "Alterar e-mail",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "O e-mail cadastrado no HashPass serve como uma medida de segurança para "
                  "validar sua identidade ao alterar a senha geral do app e para exportar seus dados, "
                  "caso seja necessário. \n\n"
                  "Para alterar este dado, informe o novo endereço e-mail abaixo. Um token será enviado para este e-mail. "
                  "Informe o token que foi enviado para você e seu e-mail será alterado.",
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              VerificarTokenWidget(
                isFirstTime: true,
                onValidate: (destinatario) async {
                  bool cadastrouEmail = await Configuration.adicionarEmail(destinatario);
                  if (cadastrouEmail) {
                    widget.onMailChanged();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
