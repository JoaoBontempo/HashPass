import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/appLanguage.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/modalTitle.dart';

class HashPassVersion with L10n {
  static String currentVersion = '1.3.0';
  static Map<String, HashPassVersion> pathNotes = {
    '1.3.0': HashPassVersion(
      L10n.appLanguage.update1_3_0_title,
      L10n.appLanguage.update1_3_0_description,
      [
        L10n.appLanguage.update1_3_0_note1,
        L10n.appLanguage.update1_3_0_note2,
      ],
    ),
  };

  final String title;
  final String message;
  final List<String> notes;

  const HashPassVersion(
    this.title,
    this.message,
    this.notes,
  );

  static void checkPath(Configuration configuration) {
    String lastVersion = configuration.preferencesManager
            .getString(ConfigurationKeys.APP_VERSION.key) ??
        currentVersion;

    configuration.preferencesManager
        .setString(ConfigurationKeys.APP_VERSION.key, lastVersion);

    if (lastVersion == currentVersion) return;

    HashPassVersion currentVersionNotes = pathNotes[currentVersion]!;

    Get.dialog(PathNotesModal(version: currentVersionNotes));
  }
}

class PathNotesModal extends HashPassStatelessWidget {
  const PathNotesModal({
    super.key,
    required this.version,
  });

  final HashPassVersion version;

  @override
  Widget localeBuild(context, language) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalTitle(
              title: "${language.pathNotes}: ${HashPassVersion.currentVersion}",
            ),
            HashPassLabel(
              paddingTop: 10,
              text: version.title,
              fontWeight: FontWeight.bold,
              paddingBottom: 5,
            ),
            HashPassLabel(
              text: version.title,
              paddingBottom: 5,
            ),
            HashPassLabel(
              text: language.pathNotesIntroduction,
              fontWeight: FontWeight.bold,
              paddingBottom: 10,
            ),
            const Divider(),
            Column(
              children: version.notes
                  .map((note) => HashPassPathNoteItem(note: note))
                  .toList(),
            )
          ],
        ),
      );
}

class HashPassPathNoteItem extends StatelessWidget {
  const HashPassPathNoteItem({
    super.key,
    required this.note,
  });
  final String note;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(
            Icons.brightness_1,
            size: 13,
          ),
          HashPassLabel(
            wrap: true,
            text: note,
            size: 13.5,
          )
        ],
      );
}
