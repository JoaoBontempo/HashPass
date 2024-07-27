import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/widgets/interface/label.dart';

class ModalTitle extends StatelessWidget {
  const ModalTitle({
    super.key,
    required this.title,
    this.onTapClose,
  });
  final String title;
  final VoidCallback? onTapClose;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: HashPassLabel(
                overflow: TextOverflow.clip,
                text: title,
                fontWeight: FontWeight.bold,
                size: 18,
                paddingRight: 10,
              ),
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: onTapClose ?? Get.back,
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
}
