import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Widgets/cards/cardFunctions.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class SimpleCardPassword extends StatelessWidget {
  const SimpleCardPassword({
    Key? key,
    required this.password,
    required this.onDelete,
    required this.onCopy,
  }) : super(key: key);
  final Senha password;
  final Function(int) onDelete;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => PasswordCardFunctions.copyPassword(password, () => onCopy()),
      onTap: () => PasswordCardFunctions.showPassword(password),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 7,
          bottom: 7,
          right: 20,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.size.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HashPassLabel(
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        text: password.titulo,
                        color: Get.theme.highlightColor,
                        fontWeight: FontWeight.bold,
                      ),
                      Visibility(
                        visible: password.credencial.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.user,
                                size: 13,
                                color: Colors.grey.shade300,
                              ),
                              HashPassLabel(
                                paddingLeft: 7.5,
                                paddingTop: 1.5,
                                overflow: TextOverflow.fade,
                                size: 12,
                                text: password.credencial,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.focusScope!.unfocus();
                            PasswordCardFunctions.deletePassword(password, (code) => onDelete(code));
                          },
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                          ),
                          color: Colors.redAccent,
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(right: 10),
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            size: 20,
                          ),
                          color: Get.theme.highlightColor,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
