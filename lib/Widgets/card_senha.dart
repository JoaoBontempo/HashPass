import 'package:flutter/material.dart';
import 'package:hashpass/Database/datasource.dart';

import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Widgets/textfield.dart';
import 'package:hashpass/Widgets/visualizar_senha.dart';

import '../Model/hash_function.dart';
import '../Util/criptografia.dart';

class CardSenha extends StatefulWidget {
  const CardSenha({
    Key? key,
    required this.senha,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);
  final Senha senha;
  final Function(int) onDelete;
  final Function(int) onUpdate;

  @override
  _CardSenhaState createState() => _CardSenhaState();
}

class _CardSenhaState extends State<CardSenha> {
  List<HashFunction> algoritmos = Criptografia.algoritmos;
  late HashFunction algoritmoSelecionado = algoritmos[widget.senha.algoritmo];
  final senhaEC = TextEditingController();
  final credencialEC = TextEditingController();

  @override
  void initState() {
    credencialEC.text = widget.senha.credencial;
    senhaEC.text = widget.senha.senhaBase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.SECONDARY_LIGHT.withOpacity(0.7),
      ),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.senha.titulo,
                style: const TextStyle(
                  color: AppColors.ACCENT_LIGHT_2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: AppTextField(
                label: "Usuário/e-mail",
                padding: 0,
                controller: credencialEC,
                dark: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: AppTextField(
                label: "Senha base",
                padding: 0,
                controller: senhaEC,
                dark: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<int>(
                  dropdownColor: AppColors.SECONDARY_LIGHT,
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
                    "Função Hash",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  icon: const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.ACCENT_LIGHT_2,
                    ),
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  underline: Container(
                    height: 2,
                    color: AppColors.ACCENT_LIGHT_2,
                  ),
                  value: algoritmoSelecionado.index,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .42,
                  child: CheckboxListTile(
                    side: const BorderSide(color: Colors.white),
                    activeColor: AppColors.ACCENT_LIGHT_2,
                    checkColor: AppColors.SECONDARY_LIGHT,
                    title: const Text(
                      "Avançado",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    value: widget.senha.avancado,
                    onChanged: (isSelected) {
                      setState(() {
                        widget.senha.avancado = isSelected!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10, top: 8, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => VisualizacaoSenhaModal(senha: widget.senha),
                      );
                    },
                    child: const Text("Visualizar senha"),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          int code = await SenhaDBSource().excluirSenha(widget.senha.id!);
                          widget.onDelete(code);
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                      IconButton(
                        onPressed: () async {
                          int code = await SenhaDBSource().atualizarSenha(widget.senha);
                          if (code == 1) {
                            widget.senha.credencial = credencialEC.text;
                            widget.senha.senhaBase = senhaEC.text;
                            widget.senha.algoritmo = algoritmoSelecionado.index;
                          }
                          widget.onUpdate(code);
                        },
                        icon: const Icon(Icons.save),
                        color: AppColors.ACCENT_LIGHT_2,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
