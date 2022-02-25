import 'package:flutter/material.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    Key? key,
    required this.titulo,
    required this.descricao,
    required this.onAction,
  }) : super(key: key);
  final String titulo;
  final String descricao;
  final Function(bool) onAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(descricao),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAction(false);
          },
          child: const Text("Não"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAction(true);
          },
          child: const Text("Sim"),
        ),
      ],
    );
  }
}
