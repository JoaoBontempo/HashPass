import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart' as hashs;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:hashpass/dto/dataExportDTO.dart';
import 'package:hashpass/dto/leakPassDTO.dart';
import 'package:hashpass/model/password.dart';
import 'package:hashpass/provider/configurationProvider.dart';
import 'http.dart';

enum HashAlgorithm {
  SHA512('SHA-512'),
  MD5('MD-5'),
  SHA256('SHA-256'),
  SHA384('SHA-348'),
  SHA224('SHA-224'),
  SHA1('SHA-1'),
  HMAC('HMAC');

  final String name;
  const HashAlgorithm(this.name);

  @override
  String toString() => name;
}

class HashCrypt {
  static final List<int> _specialCharCodes = [
    33,
    35,
    36,
    37,
    40,
    41,
    45,
    46,
    47,
    60,
    62,
    63,
    64,
    91,
    92,
    93,
    94,
    95,
    123,
    125,
  ];

  static Future<PasswordLeakDTO> verifyPassowordLeak(String basePass) async {
    String passwordHash = _applyHashAlgorithm(hashs.sha1, basePass);
    String response = await HTTPRequest.requestPasswordLeak(passwordHash);

    if (response.isEmpty) {
      return PasswordLeakDTO(leakCount: -1);
    }

    String passwordSubHash = passwordHash.substring(5).toUpperCase();

    List<String> leakedPasswords = response.split('\n');

    for (int index = 0, length = leakedPasswords.length;
        index < length;
        index += 1) {
      List<String> passwordInfo = leakedPasswords[index].split(':');
      if (passwordInfo[0] == passwordSubHash) {
        return PasswordLeakDTO(leakCount: int.parse(passwordInfo[1]));
      }
    }
    return PasswordLeakDTO(leakCount: 0);
  }

  static List<int> _passwordNumbers = <int>[];

  static String _getSpecialChar(int index) {
    if (index > _specialCharCodes.length) {
      return String.fromCharCode(_specialCharCodes[index ~/ 3]);
    }
    return String.fromCharCode(_specialCharCodes[
        index % 2 == 0 ? _specialCharCodes.length - index + 1 : index]);
  }

  static String _getPasswordNumber(int index) {
    if (index > _passwordNumbers.length) {
      return _passwordNumbers[index ~/ 3].toString();
    }
    return _passwordNumbers[
            index % 2 == 0 ? _passwordNumbers.length - index + 1 : index]
        .toString();
  }

  static String _generatePasswordKey() {
    Random random = Random();
    return _applyHashAlgorithm(
      hashs.sha256,
      DateTime.now().microsecondsSinceEpoch.toString() +
          random.nextInt(1000000).toString(),
    );
  }

  static Future<DataExportDTO> exportData(String appKey) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    //IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    String baseFileKey = "";
    String dispositivo = "";
    if (Platform.isAndroid) {
      dispositivo = androidInfo.manufacturer + androidInfo.model;
      baseFileKey = _applyHashAlgorithm(
        hashs.sha256,
        dispositivo + androidInfo.id + androidInfo.id + _generatePasswordKey(),
      );
    } else if (Platform.isIOS) {}

    List<Password> passwords = await Password.findAll();
    String passwordsKey = _generatePasswordKey();
    List<String> keys = <String>[];

    for (Password password in passwords) {
      String key = _generatePasswordKey();
      password.title = await cipherString(password.title, key);
      password.credential = await cipherString(password.credential, key);
      password.basePassword = await cipherString(password.basePassword, key);
      keys.add(key);
    }

    String passwordsFileContent = await cipherString(
        passwords.map((password) => password.toJson()).toList().toString(),
        passwordsKey);
    String fileContent = await cipherString(
        toBase64(await cipherString(
            "$passwordsKey;${keys.join(';')};$passwordsFileContent",
            baseFileKey)),
        appKey);
    return DataExportDTO(fileKey: baseFileKey, fileContent: fileContent);
  }

  static Future<List<Password>> importPasswords(
    String fileContent,
    String key,
    String appKey,
  ) async {
    fileContent = await decipherString(
            fromBase64(await decipherString(fileContent, appKey) ?? ""), key) ??
        "";
    List<String> values = fileContent.split(';');
    String? passwordsJson =
        await HashCrypt.decipherString(values[values.length - 1], values[0]);

    List<Password> passwords = Password.serializeList(passwordsJson!);
    for (int index = 0; index < passwords.length; index++) {
      passwords[index].title = await HashCrypt.decipherString(
              passwords[index].title, values[index + 1]) ??
          '';
      passwords[index].credential = await HashCrypt.decipherString(
              passwords[index].credential, values[index + 1]) ??
          '';
      passwords[index].basePassword = await HashCrypt.decipherString(
              passwords[index].basePassword, values[index + 1]) ??
          '';
    }
    return passwords;
  }

  static String toBase64(String text) {
    return base64.encode(utf8.encode(text));
  }

  static String fromBase64(String textBase64) {
    return utf8.decode(base64.decode(textBase64));
  }

  static String _applyHashAlgorithm(hashs.Hash algorithm, String base) {
    var bytes = utf8.encode(base);
    var digest = algorithm.convert(bytes);
    return digest.toString();
  }

  static String _applyHash(HashAlgorithm algorithm, String text) {
    switch (algorithm) {
      case HashAlgorithm.SHA512:
        return _applyHashAlgorithm(hashs.sha512, text);
      case HashAlgorithm.MD5:
        return _applyHashAlgorithm(hashs.md5, text);
      case HashAlgorithm.SHA256:
        return _applyHashAlgorithm(hashs.sha256, text);
      case HashAlgorithm.SHA384:
        return _applyHashAlgorithm(hashs.sha384, text);
      case HashAlgorithm.SHA224:
        return _applyHashAlgorithm(hashs.sha224, text);
      case HashAlgorithm.SHA1:
        return _applyHashAlgorithm(hashs.sha1, text);
      case HashAlgorithm.HMAC:
        List<int> bytes = utf8.encode(text);
        return hashs.Hmac(hashs.sha256, bytes).convert(bytes).toString();
      default:
        return "";
    }
  }

  static Future<String> applyAlgorithms(
    HashAlgorithm algorithm,
    String password,
    bool isAdvanced,
    String? generalKey,
  ) async {
    String? decipheredPassword = await decipherString(password, generalKey);
    String truePassword = _applyHash(algorithm, decipheredPassword!);
    if (isAdvanced) {
      try {
        truePassword = (await FlutterAesEcbPkcs5.encryptString(
            truePassword, truePassword.substring(0, 32)))!;
        truePassword = base64Encode(truePassword.codeUnits);
        int length = truePassword.length;
        int numCaracteres = (length / 3) ~/ 10;
        List<int> numbers = <int>[];
        for (int index = 0; index < length; index++) {
          if (truePassword[index].contains(RegExp(r'[0-9]'))) {
            numbers.add(int.parse(truePassword[index]));
          }
        }
        _passwordNumbers = numbers;
        String halfPassword = _getSubStringPassword(truePassword);
        int newPassLen = halfPassword.length;
        int caracFrequency = newPassLen ~/ numCaracteres;
        int numCount = numbers.length ~/ 4;
        int numFrequency = newPassLen ~/ numCount;
        String realPassword = "";
        for (int index = 0,
                insertSpecialCarac = 0,
                insertNumber = 0,
                newChar = 0;
            index < newPassLen;
            index++, insertSpecialCarac++, insertNumber++) {
          if (insertSpecialCarac == caracFrequency) {
            realPassword += index % 2 == 0
                ? _getSpecialChar(++newChar)
                : _getSpecialChar(newChar += 2);
            insertSpecialCarac = 0;
          }
          if (insertNumber == numFrequency) {
            realPassword += _getPasswordNumber(index);
            insertNumber = 0;
          }
          realPassword += halfPassword[index];
        }
        return realPassword;
      } catch (error) {
        return error.toString();
      }
    }
    return truePassword;
  }

  static String _getSubStringPassword(String password) {
    String newPassword = password;
    while (newPassword.length > 50) {
      newPassword = newPassword.substring(0, newPassword.length ~/ 3);
    }
    return newPassword;
  }

  static Future<bool> isValidGeneralKey(String? generalKey) async {
    try {
      String? cipheredMessage = Configuration.configs
          .getString(_applyHashAlgorithm(hashs.sha512, "validateKey"));
      String? decipheredMessage =
          await decipherString(cipheredMessage!, generalKey);
      return decipheredMessage ==
          _applyHashAlgorithm(hashs.sha512,
              "Mensagem para verificar se a chave informada de fato está correta");
    } catch (error) {
      return false;
    }
  }

  static Future<bool> setGeneralKeyValidationMessage(String generalKey) async {
    String message = await cipherString(
      _applyHashAlgorithm(hashs.sha512,
          "Mensagem para verificar se a chave informada de fato está correta"),
      generalKey,
    );
    return Configuration.configs
        .setString(_applyHashAlgorithm(hashs.sha512, "validateKey"), message);
  }

  static Future<String?> decipherString(
      String ciphered, String? generalKey) async {
    try {
      String? key = await getGeneralKey(generalKey);
      return await FlutterAesEcbPkcs5.decryptString(ciphered, key!);
    } catch (error) {
      return error.toString();
    }
  }

  static Future<String> cipherString(String senha, String? chaveGeral) async {
    String? key = await getGeneralKey(chaveGeral);
    return (await FlutterAesEcbPkcs5.encryptString(senha, key!))!;
  }

  static String getGeneralKeyBase() {
    String key = Configuration.configs
        .getString(_applyHashAlgorithm(hashs.sha512, "key"))!;
    return fromBase64(key);
  }

  static Future<String?> getGeneralKey(String? base) async {
    if (base == null) {
      String key = Configuration.configs
          .getString(_applyHashAlgorithm(hashs.sha512, "key"))!;
      String generalKey =
          _applyHashAlgorithm(hashs.sha512, utf8.decode(base64.decode(key)))
              .substring(0, 32);
      return generalKey;
    } else {
      String key = _applyHashAlgorithm(hashs.sha512, base).substring(0, 32);
      return key;
    }
  }

  static Future<List<Password>> changeGeneralKey(
    String oldGeneralKey,
    String newKeyBase,
  ) async {
    try {
      List<Password> passwords = <Password>[];
      if (Configuration.instance.isBiometria) {
        await createGeneralKey(newKeyBase);
      }

      passwords = await Password.findAll();

      for (Password password in passwords) {
        String? decipheredPassword =
            await decipherString(password.basePassword, oldGeneralKey);
        password.basePassword =
            await cipherString(decipheredPassword!, newKeyBase);
        password.save();
      }

      await setGeneralKeyValidationMessage(newKeyBase);
      return passwords;
    } on Exception catch (_) {
      rethrow;
    }
  }

  static Future<bool> createGeneralKey(String baseKey) async {
    try {
      return Configuration.configs.setString(
          _applyHashAlgorithm(hashs.sha512, "key"), toBase64(baseKey));
    } catch (erro) {
      return false;
    }
  }
}
