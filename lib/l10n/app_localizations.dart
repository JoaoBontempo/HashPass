import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @closeAppConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Close application?'**
  String get closeAppConfirmationTitle;

  /// No description provided for @closeAppConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to close HashPass?'**
  String get closeAppConfirmationMessage;

  /// No description provided for @updatedDataMessage.
  ///
  /// In en, this message translates to:
  /// **'All data successfully updated!'**
  String get updatedDataMessage;

  /// No description provided for @newPasswordShowCase.
  ///
  /// In en, this message translates to:
  /// **'Tap here to register a new password!'**
  String get newPasswordShowCase;

  /// No description provided for @passwordFilterShowCase.
  ///
  /// In en, this message translates to:
  /// **'Use this field to filter your passwords by title or credential'**
  String get passwordFilterShowCase;

  /// No description provided for @passwordFilterPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for title, credential...'**
  String get passwordFilterPlaceholder;

  /// No description provided for @notFoundPassword.
  ///
  /// In en, this message translates to:
  /// **'No passwords found!'**
  String get notFoundPassword;

  /// No description provided for @noRegisteredPasswords.
  ///
  /// In en, this message translates to:
  /// **'No passwords registered!'**
  String get noRegisteredPasswords;

  /// No description provided for @registerNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Add new password'**
  String get registerNewPassword;

  /// No description provided for @simpleCardShowcase.
  ///
  /// In en, this message translates to:
  /// **'Tap once to show the password. Tap and hold for a few seconds to copy it.'**
  String get simpleCardShowcase;

  /// No description provided for @deletePasswordShowCase.
  ///
  /// In en, this message translates to:
  /// **'Tap here to delete the password'**
  String get deletePasswordShowCase;

  /// No description provided for @editPasswordShwocase.
  ///
  /// In en, this message translates to:
  /// **'Tap here to edit the password'**
  String get editPasswordShwocase;

  /// No description provided for @defaultCardShowcase.
  ///
  /// In en, this message translates to:
  /// **'You can edit some information in the card, such as password and credential. For the ciphered passwords, you are able to change the hash algorithm and the cipher mode as well.'**
  String get defaultCardShowcase;

  /// No description provided for @credential.
  ///
  /// In en, this message translates to:
  /// **'Credential'**
  String get credential;

  /// No description provided for @emptyCredential.
  ///
  /// In en, this message translates to:
  /// **'The credential should not be empty!'**
  String get emptyCredential;

  /// No description provided for @basePassword.
  ///
  /// In en, this message translates to:
  /// **'Base password'**
  String get basePassword;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @emptyPassword.
  ///
  /// In en, this message translates to:
  /// **'The password should not be empty!'**
  String get emptyPassword;

  /// No description provided for @shortPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too short!'**
  String get shortPassword;

  /// No description provided for @copyPassword.
  ///
  /// In en, this message translates to:
  /// **'Copy password'**
  String get copyPassword;

  /// No description provided for @hashFunction.
  ///
  /// In en, this message translates to:
  /// **'Hash Function'**
  String get hashFunction;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @showCardPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showCardPassword;

  /// No description provided for @savePasswordShowcase.
  ///
  /// In en, this message translates to:
  /// **'Tap here to save your password'**
  String get savePasswordShowcase;

  /// No description provided for @changePasswordMenu.
  ///
  /// In en, this message translates to:
  /// **'Change master key'**
  String get changePasswordMenu;

  /// No description provided for @exportImportDataMenu.
  ///
  /// In en, this message translates to:
  /// **'Export/Import'**
  String get exportImportDataMenu;

  /// No description provided for @passworkLeakMenu.
  ///
  /// In en, this message translates to:
  /// **'Password leak'**
  String get passworkLeakMenu;

  /// No description provided for @passworkLeakMenuNoAuthorized.
  ///
  /// In en, this message translates to:
  /// **'To use the password leak verification, you should be connected to the internet.'**
  String get passworkLeakMenuNoAuthorized;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @authNeeded.
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authNeeded;

  /// No description provided for @verifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify identity'**
  String get verifyIdentity;

  /// No description provided for @setLastAppKey.
  ///
  /// In en, this message translates to:
  /// **'Last master key:'**
  String get setLastAppKey;

  /// No description provided for @appKey.
  ///
  /// In en, this message translates to:
  /// **'Master key:'**
  String get appKey;

  /// No description provided for @keyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Invalid key! Attempts left:'**
  String get keyAttempts;

  /// No description provided for @errorOcurred.
  ///
  /// In en, this message translates to:
  /// **'An error ocurred: '**
  String get errorOcurred;

  /// No description provided for @unlockNeeded.
  ///
  /// In en, this message translates to:
  /// **'Unlock is required to get the master key'**
  String get unlockNeeded;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @enterApp.
  ///
  /// In en, this message translates to:
  /// **'Enter the app'**
  String get enterApp;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @useCredentialTooltip.
  ///
  /// In en, this message translates to:
  /// **'Check this box if you want to save the credential that regards to the password. The credential might be your username, e-mail, some document number or something else that should be used along with the password'**
  String get useCredentialTooltip;

  /// No description provided for @saveCredential.
  ///
  /// In en, this message translates to:
  /// **'Save credential'**
  String get saveCredential;

  /// No description provided for @useHashTooltip.
  ///
  /// In en, this message translates to:
  /// **'Marking this box will make your password be the combination of a base password and a hash function applied on it'**
  String get useHashTooltip;

  /// No description provided for @useHash.
  ///
  /// In en, this message translates to:
  /// **'Use Hash'**
  String get useHash;

  /// No description provided for @algorithm.
  ///
  /// In en, this message translates to:
  /// **'Algorithm'**
  String get algorithm;

  /// No description provided for @cipherMode.
  ///
  /// In en, this message translates to:
  /// **'Cipher mode'**
  String get cipherMode;

  /// No description provided for @normalCipher.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalCipher;

  /// No description provided for @normalCipherTooltip.
  ///
  /// In en, this message translates to:
  /// **'Your password will be the base password with the hash function applied'**
  String get normalCipherTooltip;

  /// No description provided for @advancedCipherTooltip.
  ///
  /// In en, this message translates to:
  /// **'Beyond the hash function, your password will have an addictional symmetric cryptography'**
  String get advancedCipherTooltip;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @registerPassword.
  ///
  /// In en, this message translates to:
  /// **'Register password'**
  String get registerPassword;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmPasswordSave.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the password editing?'**
  String get confirmPasswordSave;

  /// No description provided for @confirmNewPasswordSave.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the password register?'**
  String get confirmNewPasswordSave;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @editPassword.
  ///
  /// In en, this message translates to:
  /// **'Edit password'**
  String get editPassword;

  /// No description provided for @requiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get requiredTitle;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @requiredPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is required!'**
  String get requiredPassword;

  /// No description provided for @passwordMinimumSizeMessage.
  ///
  /// In en, this message translates to:
  /// **'The password should have at least 4 characters!'**
  String get passwordMinimumSizeMessage;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @biometricConfigDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure the validation kind that the app will use to get the master key.'**
  String get biometricConfigDescription;

  /// No description provided for @biometricConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric validation'**
  String get biometricConfigTitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @timerConfigDescription.
  ///
  /// In en, this message translates to:
  /// **'Activate / deactivate the password visualization timer. If activated, it will limit the total amount of time that a password will be avaliable when it is shown.'**
  String get timerConfigDescription;

  /// No description provided for @timerConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Password timer'**
  String get timerConfigTitle;

  /// No description provided for @timerDurationConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer duration'**
  String get timerDurationConfigTitle;

  /// No description provided for @timerDurationConfigDescription.
  ///
  /// In en, this message translates to:
  /// **'Determines, in seconds, the duration of the password timer.'**
  String get timerDurationConfigDescription;

  /// No description provided for @passworkLeakConfigDescription.
  ///
  /// In en, this message translates to:
  /// **'Verifies if the password has been leaked on a few databases around the internet.'**
  String get passworkLeakConfigDescription;

  /// No description provided for @insertPasswordLeakVerificationConfig.
  ///
  /// In en, this message translates to:
  /// **'Activates real-time leak verification to register a password. Only verified passwords will be registered.'**
  String get insertPasswordLeakVerificationConfig;

  /// No description provided for @updatePasswordLeakVerificationConfig.
  ///
  /// In en, this message translates to:
  /// **'Actives real-time leak verification to passwords already registered in the app. Only verified passwords will be updated.'**
  String get updatePasswordLeakVerificationConfig;

  /// No description provided for @helpConfigDescription.
  ///
  /// In en, this message translates to:
  /// **'Activate / deactivate help icons used to explain how the app works'**
  String get helpConfigDescription;

  /// No description provided for @helpConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Help icons'**
  String get helpConfigTitle;

  /// No description provided for @cardStyleConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Interface style'**
  String get cardStyleConfigTitle;

  /// No description provided for @cardStyleConfigDescription.
  ///
  /// In en, this message translates to:
  /// **'Determines the interface style of the app to list your passwords. The simple style is a minimalistic interface and the dafault will have more information on the screen'**
  String get cardStyleConfigDescription;

  /// No description provided for @simple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get simple;

  /// No description provided for @default_.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default_;

  /// No description provided for @registerVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Register verification'**
  String get registerVerifyTitle;

  /// No description provided for @updateVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Update verification'**
  String get updateVerificationTitle;

  /// No description provided for @passwordShouldNotHaveSpacesMessage.
  ///
  /// In en, this message translates to:
  /// **'The password should not have empty spaces!'**
  String get passwordShouldNotHaveSpacesMessage;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPassword;

  /// No description provided for @notEqualPasswords.
  ///
  /// In en, this message translates to:
  /// **'The provided passwords are not equal'**
  String get notEqualPasswords;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again, please.'**
  String get tryAgain;

  /// No description provided for @changeGeneralKeySuccess.
  ///
  /// In en, this message translates to:
  /// **'HashPass master key successfully updated!'**
  String get changeGeneralKeySuccess;

  /// No description provided for @dataExportSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your passwords were exported sucessfully! Use the token below to import it.'**
  String get dataExportSuccessMessage;

  /// No description provided for @dataExportSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Data sucessfully exported!'**
  String get dataExportSuccessTitle;

  /// No description provided for @dataImportSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Data sucessfully imported!'**
  String get dataImportSuccessTitle;

  /// No description provided for @copyToken.
  ///
  /// In en, this message translates to:
  /// **'Copy token'**
  String get copyToken;

  /// No description provided for @dataExport.
  ///
  /// In en, this message translates to:
  /// **'Data export'**
  String get dataExport;

  /// No description provided for @dataImport.
  ///
  /// In en, this message translates to:
  /// **'Data import'**
  String get dataImport;

  /// No description provided for @dataExportExplanation.
  ///
  /// In en, this message translates to:
  /// **'A text file containing your passwords. It will be ciphered with a random generated token. You will be able to export this file to the place of your preference and copy the generated token. The token will be required to decipher the content of the file to import it into another device.'**
  String get dataExportExplanation;

  /// No description provided for @dataImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Insert the token generated at the time you exported your passwords and press the \'Import\' button. Choose the text file containing your ciphered passwords. Make sure you are using the correct token and file. Your HashPass master key should be the same you were using when you exported your data. Access to your files will be required.'**
  String get dataImportExplanation;

  /// No description provided for @doNotShareToken.
  ///
  /// In en, this message translates to:
  /// **'Do not share your token or your file with nobody!'**
  String get doNotShareToken;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @insertExportToken.
  ///
  /// In en, this message translates to:
  /// **'Insert your token'**
  String get insertExportToken;

  /// No description provided for @emptyFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'This field should not be empty'**
  String get emptyFieldMessage;

  /// No description provided for @chooseImportFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file to import'**
  String get chooseImportFile;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDenied;

  /// No description provided for @fileAccessRequired.
  ///
  /// In en, this message translates to:
  /// **'Access to the files of your device is required to import data.'**
  String get fileAccessRequired;

  /// No description provided for @unknowErrorToOpenFile.
  ///
  /// In en, this message translates to:
  /// **'An unknown error ocurred to open the file'**
  String get unknowErrorToOpenFile;

  /// No description provided for @unknowErrorToOpenFileManager.
  ///
  /// In en, this message translates to:
  /// **'An unknown error ocurred to open the file manager'**
  String get unknowErrorToOpenFileManager;

  /// No description provided for @dataImportCanceled.
  ///
  /// In en, this message translates to:
  /// **'No file selected. Data import canceled'**
  String get dataImportCanceled;

  /// No description provided for @dataImportErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error ocurred during data import process. Please, try again.\n\n*Check if your token is correct\n*Check if the selected file is the right one for this token\n*Check your master key. It should be the same as when you exported the passwords'**
  String get dataImportErrorMessage;

  /// No description provided for @insertPasswordToBeVerified.
  ///
  /// In en, this message translates to:
  /// **'Insert your password to be verified on a few leak databases around the internet'**
  String get insertPasswordToBeVerified;

  /// No description provided for @typePassword.
  ///
  /// In en, this message translates to:
  /// **'Type your password'**
  String get typePassword;

  /// No description provided for @verifyPassword.
  ///
  /// In en, this message translates to:
  /// **'Verify password'**
  String get verifyPassword;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @aboutHashPass.
  ///
  /// In en, this message translates to:
  /// **'HashPass is a user-friendly mobile application to store and manage your passwords securely, using complex cryptography'**
  String get aboutHashPass;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;

  /// No description provided for @generalKeyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Master key sucessfully registered!'**
  String get generalKeyRegistered;

  /// No description provided for @setFirstConfigMessage.
  ///
  /// In en, this message translates to:
  /// **'HashPass have some settings to personalize your experience with the app, such as a password visualization timer, leak verification , help icons and more.\n\nDo you like to use the default settings and set your preferences further or do you want to configure it right now?'**
  String get setFirstConfigMessage;

  /// No description provided for @useDefaultConfig.
  ///
  /// In en, this message translates to:
  /// **'Use default settings'**
  String get useDefaultConfig;

  /// No description provided for @configTheApp.
  ///
  /// In en, this message translates to:
  /// **'I want to configure the app'**
  String get configTheApp;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Use HashPass'**
  String get start;

  /// No description provided for @appReady.
  ///
  /// In en, this message translates to:
  /// **'Everything is ready!'**
  String get appReady;

  /// No description provided for @initialSettings.
  ///
  /// In en, this message translates to:
  /// **'Initial settings'**
  String get initialSettings;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to HashPass!'**
  String get welcome;

  /// No description provided for @shouldAgreePolicy.
  ///
  /// In en, this message translates to:
  /// **'To use HashPass, you should agree with our privacy policy terms'**
  String get shouldAgreePolicy;

  /// No description provided for @registerGeneralKeyError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured to register your master key. Try again, please.'**
  String get registerGeneralKeyError;

  /// No description provided for @agreeWithTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree with HashPass '**
  String get agreeWithTerms;

  /// No description provided for @insertGeneralKey.
  ///
  /// In en, this message translates to:
  /// **'Insert a master key'**
  String get insertGeneralKey;

  /// No description provided for @welcomeParagraphOne.
  ///
  /// In en, this message translates to:
  /// **'HashPass is a mobile application developed to store and manage your passwords in a truly secure way. To reach this objective, a master key is required, because your passwords will be locally stored using symmetric cryptography. Therefore, a single password is responsable to retrieve all of your passwords, so that is the only thing you need to remember.'**
  String get welcomeParagraphOne;

  /// No description provided for @welcomeParagraphTwo.
  ///
  /// In en, this message translates to:
  /// **'It will not be possible to recover the master key, so keep it safe and remember to never share it.'**
  String get welcomeParagraphTwo;

  /// No description provided for @welcomeParagraphThree.
  ///
  /// In en, this message translates to:
  /// **'You will be able to access your password with biometric validation if your device supports this feature.'**
  String get welcomeParagraphThree;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @autoTheme.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get autoTheme;

  /// No description provided for @decipherFailure.
  ///
  /// In en, this message translates to:
  /// **'An error ocurred to decipher the password'**
  String get decipherFailure;

  /// No description provided for @passwordSuccessRegister.
  ///
  /// In en, this message translates to:
  /// **'Password successfully registered!'**
  String get passwordSuccessRegister;

  /// No description provided for @passwordSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'Password successfully updated!'**
  String get passwordSuccessUpdate;

  /// No description provided for @passwordCopied.
  ///
  /// In en, this message translates to:
  /// **'Password copied'**
  String get passwordCopied;

  /// No description provided for @passwordRecoverError.
  ///
  /// In en, this message translates to:
  /// **'An error ocurred to retrieve your password'**
  String get passwordRecoverError;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm deleting'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this password? There is no way to undo this action.'**
  String get confirmDeleteMessage;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password successfully deleted!'**
  String get deleteSuccess;

  /// No description provided for @deleteError.
  ///
  /// In en, this message translates to:
  /// **'An error ocurred to delete the password. Try again, please'**
  String get deleteError;

  /// No description provided for @leakedPassword.
  ///
  /// In en, this message translates to:
  /// **'Leaked password'**
  String get leakedPassword;

  /// No description provided for @notVerifiedPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is not verified'**
  String get notVerifiedPassword;

  /// No description provided for @confirmSaveLeakedPassword.
  ///
  /// In en, this message translates to:
  /// **'You are trying to save a password that has been leaked already. Are you sure to save this password?'**
  String get confirmSaveLeakedPassword;

  /// No description provided for @confirmSaveNotVerifiedPassword.
  ///
  /// In en, this message translates to:
  /// **'It was not possible to verify your password because some error ocurred or there is no internet connection. Are you sure to save this password?'**
  String get confirmSaveNotVerifiedPassword;

  /// No description provided for @confirmSavePassword.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to update this password?'**
  String get confirmSavePassword;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @updateAndInsertLeakConfigDescription.
  ///
  /// In en, this message translates to:
  /// **'Activate / deactivate leak verification to register or update a password'**
  String get updateAndInsertLeakConfigDescription;

  /// No description provided for @couldNotVerifyPassword.
  ///
  /// In en, this message translates to:
  /// **'Was not possible to verify your password. Please, check your internet connection'**
  String get couldNotVerifyPassword;

  /// No description provided for @passwordLeakedOnce.
  ///
  /// In en, this message translates to:
  /// **'This passwork has been leaked at least once!'**
  String get passwordLeakedOnce;

  /// No description provided for @passwordMaybeNotLeaked.
  ///
  /// In en, this message translates to:
  /// **'Your password has a great chance of not ever been leaked'**
  String get passwordMaybeNotLeaked;

  /// No description provided for @passwordLeakedMoreThanOnce.
  ///
  /// In en, this message translates to:
  /// **'This passwork has been leaked at least'**
  String get passwordLeakedMoreThanOnce;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// No description provided for @pathNotes.
  ///
  /// In en, this message translates to:
  /// **'Path Notes'**
  String get pathNotes;

  /// No description provided for @pathNotesIntroduction.
  ///
  /// In en, this message translates to:
  /// **'See the version path notes below'**
  String get pathNotesIntroduction;

  /// No description provided for @update1_3_0_title.
  ///
  /// In en, this message translates to:
  /// **'HashPass version 1.3.0 has arrived! There are some new features for you!'**
  String get update1_3_0_title;

  /// No description provided for @update1_3_0_description.
  ///
  /// In en, this message translates to:
  /// **'This is the first update of the app since I developed and published it while I was at the University'**
  String get update1_3_0_description;

  /// No description provided for @update1_3_0_note1.
  ///
  /// In en, this message translates to:
  /// **'New feature: Password generation (access it on the aside menu). Gerenate a random and secure password then save it;'**
  String get update1_3_0_note1;

  /// No description provided for @update1_3_0_note2.
  ///
  /// In en, this message translates to:
  /// **'HashPass is now avaliable in English!. You can swap the language between Portuguese (BR) and English (US).'**
  String get update1_3_0_note2;

  /// No description provided for @passwordGeneratorMenu.
  ///
  /// In en, this message translates to:
  /// **'Password generator'**
  String get passwordGeneratorMenu;

  /// No description provided for @passwordSize.
  ///
  /// In en, this message translates to:
  /// **'Password size'**
  String get passwordSize;

  /// No description provided for @lowercases.
  ///
  /// In en, this message translates to:
  /// **'Lowercases'**
  String get lowercases;

  /// No description provided for @uppercases.
  ///
  /// In en, this message translates to:
  /// **'Uppercases'**
  String get uppercases;

  /// No description provided for @numbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numbers;

  /// No description provided for @symbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get symbols;

  /// No description provided for @charBlackList.
  ///
  /// In en, this message translates to:
  /// **'Character blacklist'**
  String get charBlackList;

  /// No description provided for @blackListDescription.
  ///
  /// In en, this message translates to:
  /// **'Every character at the blacklist will not came into the generated password'**
  String get blackListDescription;

  /// No description provided for @generatePassword.
  ///
  /// In en, this message translates to:
  /// **'Generate password'**
  String get generatePassword;

  /// No description provided for @passwordDetails.
  ///
  /// In en, this message translates to:
  /// **'Password details'**
  String get passwordDetails;

  /// No description provided for @generatedPassword.
  ///
  /// In en, this message translates to:
  /// **'Generated password'**
  String get generatedPassword;

  /// No description provided for @invalidParameters.
  ///
  /// In en, this message translates to:
  /// **'Invalid parameters'**
  String get invalidParameters;

  /// No description provided for @everyDigitOnBlacklist.
  ///
  /// In en, this message translates to:
  /// **'It is impossible to generate a password using only numbers if every number ([0-9]) are in the blacklist.'**
  String get everyDigitOnBlacklist;

  /// No description provided for @useDesktopTitle.
  ///
  /// In en, this message translates to:
  /// **'Desktop module'**
  String get useDesktopTitle;

  /// No description provided for @useDesktopDescription.
  ///
  /// In en, this message translates to:
  /// **'Activate / deactivate the integration with HashPass Desktop version'**
  String get useDesktopDescription;

  /// No description provided for @stablishingConnection.
  ///
  /// In en, this message translates to:
  /// **'Stablishing desktop connection...'**
  String get stablishingConnection;

  /// No description provided for @desktopConnection.
  ///
  /// In en, this message translates to:
  /// **'Desktop Connection'**
  String get desktopConnection;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @simpleTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get simpleTryAgain;

  /// No description provided for @connectionStablished.
  ///
  /// In en, this message translates to:
  /// **'Connection stablished successfully!'**
  String get connectionStablished;

  /// No description provided for @connectionFailure.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t stablish connection'**
  String get connectionFailure;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @update2_0_0_title.
  ///
  /// In en, this message translates to:
  /// **'HashPass version 2.0.0 has arrived with the open-source model! '**
  String get update2_0_0_title;

  /// No description provided for @update2_0_0_description.
  ///
  /// In en, this message translates to:
  /// **'The app is now on an open-source model! Also, there\'s a new feature arriving: The Desktop Module!'**
  String get update2_0_0_description;

  /// No description provided for @update2_0_0_note1.
  ///
  /// In en, this message translates to:
  /// **'With the desktop module, you can securely copy your password on your phone and send it to your desktop computer.'**
  String get update2_0_0_note1;

  /// No description provided for @update2_0_0_note2.
  ///
  /// In en, this message translates to:
  /// **'Browser password data import coming soon.'**
  String get update2_0_0_note2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
