import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/dto/leakPassDTO.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/util/cryptography.dart';
import 'package:hashpass/widgets/cards/cardFunctions.dart';
import 'package:hashpass/widgets/interface/label.dart';
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
  Password password;
  final Function(Password) onDelete;
  final Function(Password) onUpdate;
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
  void initState() {
    if (widget.password.leakCount == LeakStatus.FAILURE.index) {
      HashCrypt.verifyPassowordLeak(widget.password.basePassword).then(
        (response) {
          widget.password.leakCount = response.leakCount;
          widget.password.save();
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => PasswordCardFunctions.copyPassword(
          widget.password, () => widget.onCopy()),
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
          description:
              "Toque uma vez para visualizar a senha. Segure para copiar a senha.",
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
                          text: widget.password.title,
                          color: Get.theme.highlightColor,
                          fontWeight: FontWeight.bold,
                        ),
                        Visibility(
                          visible: widget.password.credential.isNotEmpty,
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
                                    text: widget.password.credential,
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
                              PasswordCardFunctions.deletePassword(
                                  widget.password,
                                  (code) => widget.onDelete(code));
                            },
                            padding: EdgeInsets.zero,
                            icon: Showcase(
                              key: widget.isExample
                                  ? widget.removeKey
                                  : GlobalKey(),
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
                            onPressed: () =>
                                PasswordCardFunctions.toUpdatePassword(
                              widget.password,
                              (_updatedPassword, code) {
                                widget.onUpdate(_updatedPassword);
                                if (code == 1) {
                                  setState(() {
                                    widget.password = _updatedPassword;
                                  });
                                }
                              },
                            ),
                            icon: Showcase(
                              key: widget.isExample
                                  ? widget.editKey
                                  : GlobalKey(),
                              description:
                                  "Toque aqui para editar as informações da senha",
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
