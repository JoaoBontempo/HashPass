import 'package:flutter/material.dart';
import 'package:hashpass/widgets/interface/label.dart';

class ModalTitle extends StatelessWidget {
  const ModalTitle({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(
            Icons.close_outlined,
            size: 17,
            color: Colors.grey,
          ),
          HashPassLabel(
            text: title,
            paddingLeft: 10,
            fontWeight: FontWeight.bold,
          ),
        ],
      );
}
