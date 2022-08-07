import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Widgets/cards/cardFunctions.dart';
import 'package:hashpass/Widgets/interface/label.dart';
import 'package:showcaseview/showcaseview.dart';

class SimpleCardPassword extends StatefulWidget {
  SimpleCardPassword({
    Key? key,
    required this.password,
    required this.onDelete,
    required this.onCopy,
    required this.onUpdate,
    this.isExample = false,
    required this.cardKey,
    required this.removeKey,
    required this.editKey,
  }) : super(key: key);
  Senha password;
  final Function(int) onDelete;
  final Function(int) onUpdate;
  final VoidCallback onCopy;
  final bool isExample;
  final GlobalKey cardKey;
  final GlobalKey removeKey;
  final GlobalKey editKey;

  @override
  State<SimpleCardPassword> createState() => _SimpleCardPasswordState();
}

class _SimpleCardPasswordState extends State<SimpleCardPassword> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => PasswordCardFunctions.copyPassword(widget.password, () => widget.onCopy()),
      onTap: () => PasswordCardFunctions.showPassword(widget.password),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 7,
          bottom: 7,
          right: 20,
        ),
        child: Showcase(
          key: widget.isExample ? widget.cardKey : GlobalKey(),
          description: "Toque uma vez para visualizar a senha. Segure para copiar a senha.",
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
                          text: widget.password.titulo,
                          color: Get.theme.highlightColor,
                          fontWeight: FontWeight.bold,
                        ),
                        Visibility(
                          visible: widget.password.credencial.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.user,
                                  size: 13,
                                  color: Get.theme.colorScheme.tertiary,
                                ),
                                Expanded(
                                  child: HashPassLabel(
                                    paddingLeft: 7.5,
                                    paddingTop: 1.5,
                                    overflow: TextOverflow.fade,
                                    size: 12,
                                    text: widget.password.credencial,
                                    color: Get.theme.colorScheme.tertiary,
                                  ),
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
                              PasswordCardFunctions.deletePassword(widget.password, (code) => widget.onDelete(code));
                            },
                            padding: EdgeInsets.zero,
                            icon: Showcase(
                              key: widget.isExample ? widget.removeKey : GlobalKey(),
                              description: "Toque aqui para excluir a senha",
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                              ),
                            ),
                            color: Colors.redAccent,
                          ),
                          IconButton(
                            padding: const EdgeInsets.only(right: 10),
                            constraints: const BoxConstraints(),
                            onPressed: () => PasswordCardFunctions.toUpdatePassword(
                              widget.password,
                              (_updatedPassword, code) {
                                widget.onUpdate(code);
                                if (code == 1) {
                                  setState(() {
                                    widget.password = _updatedPassword;
                                  });
                                }
                              },
                            ),
                            icon: Showcase(
                              key: widget.isExample ? widget.editKey : GlobalKey(),
                              description: "Toque aqui para editar as informações da senha",
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                              ),
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
      ),
    );
  }
}
