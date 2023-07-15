import 'package:flutter/material.dart';
import 'package:hashpass/dto/passwordGenerationParameters.dart';
import 'package:hashpass/provider/hashPassProvider.dart';
import 'package:hashpass/widgets/interface/messageBox.dart';

class PasswordGeneratorProvider extends HashPassProvider {
  String generatedPassword;
  late PasswordGenerationParameters parameters;
  final blackListController = TextEditingController();

  final digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  PasswordGeneratorProvider({
    this.generatedPassword = '',
  }) {
    parameters = PasswordGenerationParameters(
      size: 10,
      useNumbers: true,
      useUpperCase: true,
      useLowerCase: true,
      useSpecialChar: true,
      blackList: '',
    );
  }

  void setParameters({
    int? size,
    bool? lowerCase,
    bool? upperCase,
    bool? numbers,
    bool? symbols,
  }) {
    parameters.size = size ?? parameters.size;
    parameters.useSpecialChar = symbols ?? parameters.useSpecialChar;
    parameters.useNumbers = numbers ?? parameters.useNumbers;
    parameters.useLowerCase = lowerCase ?? parameters.useLowerCase;
    parameters.useUpperCase = upperCase ?? parameters.useUpperCase;

    if (!parameters.useSpecialChar &&
        !parameters.useNumbers &&
        !parameters.useLowerCase &&
        !parameters.useUpperCase) {
      parameters.useLowerCase = lowerCase ?? true;
      parameters.useUpperCase = upperCase ?? true;
    }

    if (generatedPassword.trim().isNotEmpty) {
      generatePassword();
      return;
    }

    notifyListeners();
  }

  bool isValidParameters() {
    if (parameters.useNumbers &&
        !parameters.useLowerCase &&
        !parameters.useSpecialChar &&
        !parameters.useUpperCase &&
        digits.every(
          (digit) => parameters.blackList.contains(digit.toString()),
        )) {
      HashPassMessage.show(
        message: language.everyDigitOnBlacklist,
        title: language.invalidParameters,
      );
      return false;
    }
    return true;
  }

  void generatePassword() {
    parameters.blackList = blackListController.text;
    if (isValidParameters()) {
      generatedPassword = parameters.generate();
      notifyListeners();
    }
  }
}
