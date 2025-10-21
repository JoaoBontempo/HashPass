import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'package:hashpass/util/appLanguage.dart';
import 'package:hashpass/util/security/cryptography.dart';
import 'package:hashpass/view/hashPassWidgets.dart';
import 'package:hashpass/widgets/appKeyValidation.dart';
import 'package:hashpass/widgets/interface/label.dart';
import 'package:hashpass/widgets/interface/modalTitle.dart';

class HashPassVersion with L10n {
  static String currentVersion = '2.0.0';
  static Map<String, HashPassVersion> pathNotes = {
    '1.3.0': HashPassVersion(
      L10n.appLanguage.update1_3_0_title,
      L10n.appLanguage.update1_3_0_description,
      [
        L10n.appLanguage.update1_3_0_note1,
        L10n.appLanguage.update1_3_0_note2,
      ],
    ),
    '2.0.0': HashPassVersion(
      L10n.appLanguage.update2_0_0_title,
      L10n.appLanguage.update2_0_0_description,
      [
        L10n.appLanguage.update2_0_0_note1,
        L10n.appLanguage.update2_0_0_note2,
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
        'none';

    configuration.preferencesManager
        .setString(ConfigurationKeys.APP_VERSION.key, currentVersion);

    if (lastVersion == currentVersion) return;

    runVersionChanges().then((_) {
      HashPassVersion currentVersionNotes = pathNotes[currentVersion]!;

      Get.dialog(PathNotesModal(version: currentVersionNotes));
    });
  }

  static Future<void> runVersionChanges() async {
    switch (currentVersion) {
      case '2.0.0':
        return version200();
    }
  }

  static Future<void> version200() async {
    AuthAppKey.auth(
      onValidate: (key) => HashCrypt.setGeneralKeyValidationMessage(key),
    );
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
        insetPadding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalTitle(
              title: "${language.pathNotes}: ${HashPassVersion.currentVersion}",
            ),
            HashPassLabel(
              text: version.title,
              padding: 10,
            ),
            HashPassLabel(
              text: language.pathNotesIntroduction,
              fontWeight: FontWeight.bold,
              paddingBottom: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: Column(
                children: version.notes
                    .map((note) => HashPassPathNoteItem(note: note))
                    .toList(),
              ),
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Icon(
                Icons.brightness_1,
                size: 6,
              ),
            ),
            Expanded(
              child: HashPassLabel(
                paddingLeft: 7.5,
                wrap: true,
                text: note,
                size: 14,
              ),
            )
          ],
        ),
      );
}
