import 'dart:math';

enum PasswordGeneratorCharacterType {
  SYMBOL,
  NUMBER,
  LOWERCASE,
  UPPERCASE;
}

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
    int typeIndex = _rangeRandom(0, 3);
    PasswordGeneratorCharacterType charType =
        PasswordGeneratorCharacterType.values.firstWhere(
      (_charType) => _charType.index == typeIndex,
    );

    switch (charType) {
      case PasswordGeneratorCharacterType.SYMBOL:
        return _getNewSymbol();
      case PasswordGeneratorCharacterType.NUMBER:
        return _getNewNumber();
      case PasswordGeneratorCharacterType.UPPERCASE:
        return _getNewUppercase();
      case PasswordGeneratorCharacterType.LOWERCASE:
        return _getNewLowercase();
      default:
        return _getNextChar();
    }
  }

  String _getNewSymbol() {
    if (useSpecialChar && _randomChance) {
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

    return _getNextChar();
  }

  String _getNewNumber() {
    if (useNumbers && _randomChance) {
      return _checkNewChar(String.fromCharCode(_rangeRandom(48, 57)));
    }

    return _getNextChar();
  }

  String _getNewUppercase() {
    if (useUpperCase && _randomChance) {
      return _checkNewChar(String.fromCharCode(_rangeRandom(65, 90)));
    }

    return _getNextChar();
  }

  String _getNewLowercase() {
    if (useLowerCase && _randomChance) {
      return _checkNewChar(String.fromCharCode(_rangeRandom(97, 122)));
    }

    return _getNextChar();
  }

  String _checkNewChar(String char) =>
      blackList.isNotEmpty && blackList.contains(char) ? _getNextChar() : char;

  bool get _randomChance =>
      _rangeRandom(_rangeRandom(1, 50), _rangeRandom(51, 100)) >
      _rangeRandom(1, 100);

  int _rangeRandom(int min, int max) =>
      min + _randomGenerator.nextInt(++max - min);
}
