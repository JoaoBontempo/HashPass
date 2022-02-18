import 'package:flutter/material.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/hash_function.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Util/criptografia.dart';
import 'package:hashpass/Util/util.dart';
import 'package:hashpass/Widgets/button.dart';
import 'package:hashpass/Widgets/textfield.dart';
import 'package:validatorless/validatorless.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({Key? key, required this.onCadastro}) : super(key: key);
  final Function(Senha) onCadastro;

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  List<HashFunction> algoritmos = Criptografia.algoritmos;
  late HashFunction? algoritmoSelecionado = null;
  bool isAvancado = false;
  final tituloEC = TextEditingController();
  final credencialEC = TextEditingController();
  final senhaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Nova senha"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: AppTextField(
                label: "Título",
                padding: 0,
                controller: tituloEC,
                validator: Validatorless.multiple([
                  Validatorless.required("O título é obrigatório"),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: AppTextField(
                label: "Usuário/e-mail",
                padding: 0,
                controller: credencialEC,
                validator: Validatorless.multiple([
                  Validatorless.required("A credencial é obrigatória"),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: AppTextField(
                label: "Senha base",
                padding: 0,
                controller: senhaEC,
                validator: Validatorless.multiple([
                  Validatorless.required("A senha base é obrigatória"),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Text("Função Hash:"),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: DropdownButton<int>(
                      items: algoritmos.map<DropdownMenuItem<int>>((HashFunction algoritmo) {
                        return DropdownMenuItem<int>(
                          value: algoritmo.index,
                          child: Text(algoritmo.label),
                        );
                      }).toList(),
                      onChanged: (idSelecionado) {
                        setState(() {
                          algoritmoSelecionado = algoritmos.firstWhere((algoritmo) => algoritmo.index == idSelecionado);
                        });
                      },
                      hint: const Text(
                        "Selecione o algoritmo de hash",
                        style: TextStyle(color: AppColors.ACCENT_LIGHT),
                        textAlign: TextAlign.center,
                      ),
                      icon: const RotatedBox(quarterTurns: 1, child: Icon(Icons.chevron_right, color: AppColors.ACCENT_LIGHT)),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: AppColors.ACCENT_LIGHT),
                      underline: Container(
                        height: 2,
                        color: AppColors.ACCENT_LIGHT,
                      ),
                      value: algoritmoSelecionado?.index,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text("Modo de criptografia:"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  child: RadioListTile(
                    title: const Text("Modo normal"),
                    value: false,
                    groupValue: isAvancado,
                    onChanged: (value) {
                      setState(() {
                        isAvancado = value as bool;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  child: RadioListTile(
                    title: const Text("Modo Avançado"),
                    value: true,
                    groupValue: isAvancado,
                    onChanged: (value) {
                      setState(() {
                        isAvancado = value as bool;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AppButton(
                label: "Cadastrar senha",
                width: MediaQuery.of(context).size.width * .5,
                height: 35,
                onPressed: () async {
                  final formValido = formKey.currentState?.validate() ?? false;
                  if (formValido) {
                    Senha senha = Senha(
                      titulo: tituloEC.text,
                      credencial: credencialEC.text,
                      senhaBase: senhaEC.text,
                      avancado: isAvancado,
                      algoritmo: algoritmoSelecionado!.index,
                    );
                    senha = await SenhaDBSource().inserirSenha(senha);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Senha cadastrada com sucesso!",
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.greenAccent,
                      ),
                    );
                    Navigator.of(context).pop();
                    widget.onCadastro(senha);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
