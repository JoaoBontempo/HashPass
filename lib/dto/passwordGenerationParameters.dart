import 'dart:math';

class PasswordGenerationParameters {
  //Symbols char codes at ASCII table divided by 4 groups
  static final Map<int, List<int>> _specialCharCodeGroups = {
    1: [33, 47],
    2: [58, 64],
    3: [91, 96],
    4: [123, 126]
  };

  int size;
  bool useNumbers;
  bool useUpperCase;
  bool useLowerCase;
  bool useSpecialChar;
  String blackList;
  late Random _randomGenerator;

  PasswordGenerationParameters({
    required this.size,
    required this.useNumbers,
    required this.useUpperCase,
    required this.useLowerCase,
    required this.useSpecialChar,
    required this.blackList,
  }) {
    _randomGenerator = Random();
  }

  String generate() {
    String password = '';
    for (int index = 0; index < size; index++) {
      password += _getNextChar();
    }
    return password;
  }

  String _getNextChar() {
    if (useSpecialChar && _fiftyPercentChance) {
      int symbolGroupIndex = _rangeRandom(1, 4);
      List<int> symbolGroup = _specialCharCodeGroups[symbolGroupIndex] ??
          _specialCharCodeGroups.values.first;
      return _checkNewChar(
        String.fromCharCode(
          _rangeRandom(
            symbolGroup[0],
            symbolGroup[1],
          ),
        ),
      );
    }

    if (useNumbers && _fiftyPercentChance) {
      return _checkNewChar(String.fromCharCode(_rangeRandom(48, 57)));
    }

    if ((useUpperCase && _fiftyPercentChance) || !useLowerCase) {
      return _checkNewChar(String.fromCharCode(_rangeRandom(65, 90)));
    }

    return _checkNewChar(String.fromCharCode(_rangeRandom(97, 122)));
  }

  String _checkNewChar(String char) =>
      blackList.isNotEmpty && blackList.contains(char) ? _getNextChar() : char;

  bool get _fiftyPercentChance => _rangeRandom(1, 10) > 5;

  int _rangeRandom(int min, int max) =>
      min + _randomGenerator.nextInt(max - min);
}
