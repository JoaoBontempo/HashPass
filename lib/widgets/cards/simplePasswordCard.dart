import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/passwordCardProvider.dart';
import 'package:hashpass/provider/userPasswordsProvider.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class SimpleCardPassword extends HashPassStatelessWidget {
  const SimpleCardPassword({
    Key? key,
    this.isExample = false,
    required this.cardKey,
    required this.removeKey,
    required this.editKey,
  }) : super(key: key);
  final bool isExample;
  final GlobalKey cardKey;
  final GlobalKey removeKey;
  final GlobalKey editKey;

  @override
  Widget localeBuild(context, language) =>
      Consumer2<PasswordCardProvider, UserPasswordsProvider>(
        builder: (context, passwordProvider, userPasswordsProvider, _) =>
            GestureDetector(
          onLongPress: passwordProvider.copyPassword,
          onTap: passwordProvider.showPassword,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 7,
              bottom: 7,
              right: 20,
            ),
            child: Showcase(
              key: passwordProvider.isHelpExample ? cardKey : GlobalKey(),
              description: language.simpleCardShowcase,
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
                              text: passwordProvider.password.title,
                              color: Get.theme.highlightColor,
                              fontWeight: FontWeight.bold,
                            ),
                            Visibility(
                              visible: passwordProvider
                                  .password.credential.isNotEmpty,
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
                                        text: passwordProvider
                                            .password.credential,
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
                                  passwordProvider
                                      .deletePassword(userPasswordsProvider);
                                },
                                padding: EdgeInsets.zero,
                                icon: Showcase(
                                  key: isExample ? removeKey : GlobalKey(),
                                  description: language.deletePasswordShowCase,
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
                                onPressed: () => passwordProvider
                                    .toUpdatePassword(userPasswordsProvider),
                                icon: Showcase(
                                  key: passwordProvider.isHelpExample
                                      ? editKey
                                      : GlobalKey(),
                                  description: language.editPasswordShwocase,
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
        ),
      );
}
