// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get closeAppConfirmationTitle => 'Close application?';

  @override
  String get closeAppConfirmationMessage => 'Are you sure to close HashPass?';

  @override
  String get updatedDataMessage => 'All data successfully updated!';

  @override
  String get newPasswordShowCase => 'Tap here to register a new password!';

  @override
  String get passwordFilterShowCase =>
      'Use this field to filter your passwords by title or credential';

  @override
  String get passwordFilterPlaceholder => 'Search for title, credential...';

  @override
  String get notFoundPassword => 'No passwords found!';

  @override
  String get noRegisteredPasswords => 'No passwords registered!';

  @override
  String get registerNewPassword => 'Add new password';

  @override
  String get simpleCardShowcase =>
      'Tap once to show the password. Tap and hold for a few seconds to copy it.';

  @override
  String get deletePasswordShowCase => 'Tap here to delete the password';

  @override
  String get editPasswordShwocase => 'Tap here to edit the password';

  @override
  String get defaultCardShowcase =>
      'You can edit some information in the card, such as password and credential. For the ciphered passwords, you are able to change the hash algorithm and the cipher mode as well.';

  @override
  String get credential => 'Credential';

  @override
  String get emptyCredential => 'The credential should not be empty!';

  @override
  String get basePassword => 'Base password';

  @override
  String get password => 'Password';

  @override
  String get emptyPassword => 'The password should not be empty!';

  @override
  String get shortPassword => 'The password is too short!';

  @override
  String get copyPassword => 'Copy password';

  @override
  String get hashFunction => 'Hash Function';

  @override
  String get advanced => 'Advanced';

  @override
  String get showCardPassword => 'Show password';

  @override
  String get savePasswordShowcase => 'Tap here to save your password';

  @override
  String get changePasswordMenu => 'Change master key';

  @override
  String get exportImportDataMenu => 'Export/Import';

  @override
  String get passworkLeakMenu => 'Password leak';

  @override
  String get passworkLeakMenuNoAuthorized =>
      'To use the password leak verification, you should be connected to the internet.';

  @override
  String get settings => 'Settings';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get about => 'About';

  @override
  String get authNeeded => 'Authentication required';

  @override
  String get verifyIdentity => 'Verify identity';

  @override
  String get setLastAppKey => 'Last master key:';

  @override
  String get appKey => 'Master key:';

  @override
  String get keyAttempts => 'Invalid key! Attempts left:';

  @override
  String get errorOcurred => 'An error ocurred: ';

  @override
  String get unlockNeeded => 'Unlock is required to get the master key';

  @override
  String get validate => 'Validate';

  @override
  String get seconds => 'Seconds';

  @override
  String get enterApp => 'Enter the app';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get useCredentialTooltip =>
      'Check this box if you want to save the credential that regards to the password. The credential might be your username, e-mail, some document number or something else that should be used along with the password';

  @override
  String get saveCredential => 'Save credential';

  @override
  String get useHashTooltip =>
      'Marking this box will make your password be the combination of a base password and a hash function applied on it';

  @override
  String get useHash => 'Use Hash';

  @override
  String get algorithm => 'Algorithm';

  @override
  String get cipherMode => 'Cipher mode';

  @override
  String get normalCipher => 'Normal';

  @override
  String get normalCipherTooltip =>
      'Your password will be the base password with the hash function applied';

  @override
  String get advancedCipherTooltip =>
      'Beyond the hash function, your password will have an addictional symmetric cryptography';

  @override
  String get save => 'Save';

  @override
  String get registerPassword => 'Register password';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmPasswordSave =>
      'Are you sure you want to cancel the password editing?';

  @override
  String get confirmNewPasswordSave =>
      'Are you sure you want to cancel the password register?';

  @override
  String get newPassword => 'New password';

  @override
  String get editPassword => 'Edit password';

  @override
  String get requiredTitle => 'Title is required';

  @override
  String get title => 'Title';

  @override
  String get requiredPassword => 'Password is required!';

  @override
  String get passwordMinimumSizeMessage =>
      'The password should have at least 4 characters!';

  @override
  String get register => 'Register';

  @override
  String get language => 'Language';

  @override
  String get biometricConfigDescription =>
      'Configure the validation kind that the app will use to get the master key.';

  @override
  String get biometricConfigTitle => 'Biometric validation';

  @override
  String get theme => 'Theme';

  @override
  String get timerConfigDescription =>
      'Activate / deactivate the password visualization timer. If activated, it will limit the total amount of time that a password will be avaliable when it is shown.';

  @override
  String get timerConfigTitle => 'Password timer';

  @override
  String get timerDurationConfigTitle => 'Timer duration';

  @override
  String get timerDurationConfigDescription =>
      'Determines, in seconds, the duration of the password timer.';

  @override
  String get passworkLeakConfigDescription =>
      'Verifies if the password has been leaked on a few databases around the internet.';

  @override
  String get insertPasswordLeakVerificationConfig =>
      'Activates real-time leak verification to register a password. Only verified passwords will be registered.';

  @override
  String get updatePasswordLeakVerificationConfig =>
      'Actives real-time leak verification to passwords already registered in the app. Only verified passwords will be updated.';

  @override
  String get helpConfigDescription =>
      'Activate / deactivate help icons used to explain how the app works';

  @override
  String get helpConfigTitle => 'Help icons';

  @override
  String get cardStyleConfigTitle => 'Interface style';

  @override
  String get cardStyleConfigDescription =>
      'Determines the interface style of the app to list your passwords. The simple style is a minimalistic interface and the dafault will have more information on the screen';

  @override
  String get simple => 'Simple';

  @override
  String get default_ => 'Default';

  @override
  String get registerVerifyTitle => 'Register verification';

  @override
  String get updateVerificationTitle => 'Update verification';

  @override
  String get passwordShouldNotHaveSpacesMessage =>
      'The password should not have empty spaces!';

  @override
  String get confirmPassword => 'Confirm your password';

  @override
  String get notEqualPasswords => 'The provided passwords are not equal';

  @override
  String get tryAgain => 'Try again, please.';

  @override
  String get changeGeneralKeySuccess =>
      'HashPass master key successfully updated!';

  @override
  String get dataExportSuccessMessage =>
      'Your passwords were exported sucessfully! Use the token below to import it.';

  @override
  String get dataExportSuccessTitle => 'Data sucessfully exported!';

  @override
  String get dataImportSuccessTitle => 'Data sucessfully imported!';

  @override
  String get copyToken => 'Copy token';

  @override
  String get dataExport => 'Data export';

  @override
  String get dataImport => 'Data import';

  @override
  String get dataExportExplanation =>
      'A text file containing your passwords. It will be ciphered with a random generated token. You will be able to export this file to the place of your preference and copy the generated token. The token will be required to decipher the content of the file to import it into another device.';

  @override
  String get dataImportExplanation =>
      'Insert the token generated at the time you exported your passwords and press the \'Import\' button. Choose the text file containing your ciphered passwords. Make sure you are using the correct token and file. Your HashPass master key should be the same you were using when you exported your data. Access to your files will be required.';

  @override
  String get doNotShareToken =>
      'Do not share your token or your file with nobody!';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get insertExportToken => 'Insert your token';

  @override
  String get emptyFieldMessage => 'This field should not be empty';

  @override
  String get chooseImportFile => 'Choose a file to import';

  @override
  String get accessDenied => 'Access denied';

  @override
  String get fileAccessRequired =>
      'Access to the files of your device is required to import data.';

  @override
  String get unknowErrorToOpenFile =>
      'An unknown error ocurred to open the file';

  @override
  String get unknowErrorToOpenFileManager =>
      'An unknown error ocurred to open the file manager';

  @override
  String get dataImportCanceled => 'No file selected. Data import canceled';

  @override
  String get dataImportErrorMessage =>
      'An unexpected error ocurred during data import process. Please, try again.\n\n*Check if your token is correct\n*Check if the selected file is the right one for this token\n*Check your master key. It should be the same as when you exported the passwords';

  @override
  String get insertPasswordToBeVerified =>
      'Insert your password to be verified on a few leak databases around the internet';

  @override
  String get typePassword => 'Type your password';

  @override
  String get verifyPassword => 'Verify password';

  @override
  String get version => 'Version';

  @override
  String get aboutHashPass =>
      'HashPass is a user-friendly mobile application to store and manage your passwords securely, using complex cryptography';

  @override
  String get developedBy => 'Developed by';

  @override
  String get generalKeyRegistered => 'Master key sucessfully registered!';

  @override
  String get setFirstConfigMessage =>
      'HashPass have some settings to personalize your experience with the app, such as a password visualization timer, leak verification , help icons and more.\n\nDo you like to use the default settings and set your preferences further or do you want to configure it right now?';

  @override
  String get useDefaultConfig => 'Use default settings';

  @override
  String get configTheApp => 'I want to configure the app';

  @override
  String get start => 'Use HashPass';

  @override
  String get appReady => 'Everything is ready!';

  @override
  String get initialSettings => 'Initial settings';

  @override
  String get next => 'Next';

  @override
  String get welcome => 'Welcome to HashPass!';

  @override
  String get shouldAgreePolicy =>
      'To use HashPass, you should agree with our privacy policy terms';

  @override
  String get registerGeneralKeyError =>
      'An unknown error occured to register your master key. Try again, please.';

  @override
  String get agreeWithTerms => 'I agree with HashPass ';

  @override
  String get insertGeneralKey => 'Insert a master key';

  @override
  String get welcomeParagraphOne =>
      'HashPass is a mobile application developed to store and manage your passwords in a truly secure way. To reach this objective, a master key is required, because your passwords will be locally stored using symmetric cryptography. Therefore, a single password is responsable to retrieve all of your passwords, so that is the only thing you need to remember.';

  @override
  String get welcomeParagraphTwo =>
      'It will not be possible to recover the master key, so keep it safe and remember to never share it.';

  @override
  String get welcomeParagraphThree =>
      'You will be able to access your password with biometric validation if your device supports this feature.';

  @override
  String get darkTheme => 'Dark';

  @override
  String get lightTheme => 'Light';

  @override
  String get autoTheme => 'System Default';

  @override
  String get decipherFailure => 'An error ocurred to decipher the password';

  @override
  String get passwordSuccessRegister => 'Password successfully registered!';

  @override
  String get passwordSuccessUpdate => 'Password successfully updated!';

  @override
  String get passwordCopied => 'Password copied';

  @override
  String get passwordRecoverError =>
      'An error ocurred to retrieve your password';

  @override
  String get confirmDelete => 'Confirm deleting';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this password? There is no way to undo this action.';

  @override
  String get deleteSuccess => 'Password successfully deleted!';

  @override
  String get deleteError =>
      'An error ocurred to delete the password. Try again, please';

  @override
  String get leakedPassword => 'Leaked password';

  @override
  String get notVerifiedPassword => 'Password is not verified';

  @override
  String get confirmSaveLeakedPassword =>
      'You are trying to save a password that has been leaked already. Are you sure to save this password?';

  @override
  String get confirmSaveNotVerifiedPassword =>
      'It was not possible to verify your password because some error ocurred or there is no internet connection. Are you sure to save this password?';

  @override
  String get confirmSavePassword => 'Are you sure to update this password?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get updateAndInsertLeakConfigDescription =>
      'Activate / deactivate leak verification to register or update a password';

  @override
  String get couldNotVerifyPassword =>
      'Was not possible to verify your password. Please, check your internet connection';

  @override
  String get passwordLeakedOnce =>
      'This passwork has been leaked at least once!';

  @override
  String get passwordMaybeNotLeaked =>
      'Your password has a great chance of not ever been leaked';

  @override
  String get passwordLeakedMoreThanOnce =>
      'This passwork has been leaked at least';

  @override
  String get times => 'times';

  @override
  String get pathNotes => 'Path Notes';

  @override
  String get pathNotesIntroduction => 'See the version path notes below';

  @override
  String get update1_3_0_title =>
      'HashPass version 1.3.0 has arrived! There are some new features for you!';

  @override
  String get update1_3_0_description =>
      'This is the first update of the app since I developed and published it while I was at the University';

  @override
  String get update1_3_0_note1 =>
      'New feature: Password generation (access it on the aside menu). Gerenate a random and secure password then save it;';

  @override
  String get update1_3_0_note2 =>
      'HashPass is now avaliable in English!. You can swap the language between Portuguese (BR) and English (US).';

  @override
  String get passwordGeneratorMenu => 'Password generator';

  @override
  String get passwordSize => 'Password size';

  @override
  String get lowercases => 'Lowercases';

  @override
  String get uppercases => 'Uppercases';

  @override
  String get numbers => 'Numbers';

  @override
  String get symbols => 'Symbols';

  @override
  String get charBlackList => 'Character blacklist';

  @override
  String get blackListDescription =>
      'Every character at the blacklist will not came into the generated password';

  @override
  String get generatePassword => 'Generate password';

  @override
  String get passwordDetails => 'Password details';

  @override
  String get generatedPassword => 'Generated password';

  @override
  String get invalidParameters => 'Invalid parameters';

  @override
  String get everyDigitOnBlacklist =>
      'It is impossible to generate a password using only numbers if every number ([0-9]) are in the blacklist.';

  @override
  String get useDesktopTitle => 'Desktop module';

  @override
  String get useDesktopDescription =>
      'Activate / deactivate the integration with HashPass Desktop version';

  @override
  String get stablishingConnection => 'Stablishing desktop connection...';

  @override
  String get desktopConnection => 'Desktop Connection';

  @override
  String get cancel => 'Cancel';

  @override
  String get simpleTryAgain => 'Try Again';

  @override
  String get connectionStablished => 'Connection stablished successfully!';

  @override
  String get connectionFailure => 'Couldn\'t stablish connection';

  @override
  String get restart => 'Restart';

  @override
  String get update2_0_0_title =>
      'HashPass version 2.0.0 has arrived with the open-source model! ';

  @override
  String get update2_0_0_description =>
      'The app is now on an open-source model! Also, there\'s a new feature arriving: The Desktop Module!';

  @override
  String get update2_0_0_note1 =>
      'With the desktop module, you can securely copy your password on your phone and send it to your desktop computer.';

  @override
  String get update2_0_0_note2 => 'Browser password data import coming soon.';
}
