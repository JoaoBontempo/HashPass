import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart' as hashs;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:hashpass/DTO/dataExportDTO.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/hashFunction.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/util.dart';
import '../DTO/leakPassDTO.dart';
import '../Model/configuration.dart';
import 'http.dart';

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

  static final List<HashFunction> algoritmos = [
    HashFunction(index: 0, label: "SHA-512"),
    HashFunction(index: 1, label: "MD-5"),
    HashFunction(index: 2, label: "SHA-256"),
    HashFunction(index: 3, label: "SHA-384"),
    HashFunction(index: 4, label: "SHA-224"),
    HashFunction(index: 5, label: "SHA-1"),
    HashFunction(index: 6, label: "HMAC"),
  ];

  static Future<PasswordLeakDTO> verifyPassowordLeak(String basePass) async {
    String passwordHash = _applyHashAlgorithm(hashs.sha1, basePass);
    String response = await HTTPRequest.requestPasswordLeak(passwordHash);

    if (response.isEmpty) {
      return PasswordLeakDTO(leakCount: -1);
    }

    String passwordSubHash = passwordHash.substring(5).toUpperCase();

    List<String> leakedPasswords = response.split('\n');

    for (int index = 0, length = leakedPasswords.length; index < length; index += 1) {
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
    return String.fromCharCode(_specialCharCodes[index % 2 == 0 ? _specialCharCodes.length - index + 1 : index]);
  }

  static String _getPasswordNumber(int index) {
    if (index > _passwordNumbers.length) {
      return _passwordNumbers[index ~/ 3].toString();
    }
    return _passwordNumbers[index % 2 == 0 ? _passwordNumbers.length - index + 1 : index].toString();
  }

  static String _generatePasswordKey() {
    Random random = Random();
    return _applyHashAlgorithm(
      hashs.sha256,
      DateTime.now().microsecondsSinceEpoch.toString() + random.nextInt(1000000).toString(),
    );
  }

  static Future<DataExportDTO> exportData(String appKey) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    //IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    String baseFileKey = "";
    String dispositivo = "";
    if (Platform.isAndroid) {
      dispositivo = androidInfo.manufacturer! + androidInfo.model!;
      baseFileKey = _applyHashAlgorithm(
        hashs.sha256,
        dispositivo + androidInfo.id! + androidInfo.androidId! + _generatePasswordKey(),
      );
    } else if (Platform.isIOS) {}

    List<Senha> passwords = await SenhaDBSource().getTodasSenhas();
    String passwordsKey = _generatePasswordKey();
    List<String> keys = <String>[];

    for (Senha password in passwords) {
      String key = _generatePasswordKey();
      password.titulo = await cipherString(password.titulo, key);
      password.credencial = await cipherString(password.credencial, key);
      password.senhaBase = await cipherString(password.senhaBase, key);
      keys.add(key);
    }

    String passwordsFileContent = await cipherString(passwords.map((password) => password.toJson()).toList().toString(), passwordsKey);
    String fileContent =
        await cipherString(toBase64(await cipherString("$passwordsKey;${keys.join(';')};$passwordsFileContent", baseFileKey)), appKey);
    return DataExportDTO(fileKey: baseFileKey, fileContent: fileContent);
  }

  static Future<List<Senha>> importPasswords(String fileContent, String key, String appKey) async {
    fileContent = await decipherString(fromBase64(await decipherString(fileContent, appKey) ?? ""), key) ?? "";
    List<String> values = fileContent.split(';');
    String? passwordsJson = await HashCrypt.decipherString(values[values.length - 1], values[0]);
    List<Senha> senhas = Senha.serializeList(passwordsJson!);
    for (int index = 0; index < senhas.length; index++) {
      senhas[index].titulo = await HashCrypt.decipherString(senhas[index].titulo, values[index + 1]) ?? '';
      senhas[index].credencial = await HashCrypt.decipherString(senhas[index].credencial, values[index + 1]) ?? '';
      senhas[index].senhaBase = await HashCrypt.decipherString(senhas[index].senhaBase, values[index + 1]) ?? '';
    }
    return senhas;
  }

  static String toBase64(String text) {
    return base64.encode(utf8.encode(text));
  }

  static String fromBase64(String textBase64) {
    return utf8.decode(base64.decode(textBase64));
  }

  static String _applyHashAlgorithm(hashs.Hash algotimo, String base) {
    var bytes = utf8.encode(base);
    var digest = algotimo.convert(bytes);
    return digest.toString();
  }

  static String _applyHash(int algorithm, String text) {
    switch (algorithm) {
      case 0:
        return _applyHashAlgorithm(hashs.sha512, text);
      case 1:
        return _applyHashAlgorithm(hashs.md5, text);
      case 2:
        return _applyHashAlgorithm(hashs.sha256, text);
      case 3:
        return _applyHashAlgorithm(hashs.sha384, text);
      case 4:
        return _applyHashAlgorithm(hashs.sha224, text);
      case 5:
        return _applyHashAlgorithm(hashs.sha1, text);
      case 6:
        List<int> bytes = utf8.encode(text);
        return hashs.Hmac(hashs.sha256, bytes).convert(bytes).toString();
      default:
        return "";
    }
  }

  static Future<String> applyAlgorithms(int algoritmo, String senha, bool isAvancado, String? chaveGeral) async {
    String? senhaDecifrada = await decipherString(senha, chaveGeral);
    String senhaReal = _applyHash(algoritmo, senhaDecifrada!);
    if (isAvancado) {
      try {
        senhaReal = (await FlutterAesEcbPkcs5.encryptString(senhaReal, senhaReal.substring(0, 32)))!;
        senhaReal = base64Encode(senhaReal.codeUnits);
        int length = senhaReal.length;
        int numCaracteres = (length / 3) ~/ 10;
        List<int> numbers = <int>[];
        for (int index = 0; index < length; index++) {
          if (senhaReal[index].contains(RegExp(r'[0-9]'))) {
            numbers.add(int.parse(senhaReal[index]));
          }
        }
        _passwordNumbers = numbers;
        String halfPassword = _getSubStringPassword(senhaReal);
        int newPassLen = halfPassword.length;
        int caracFrequency = newPassLen ~/ numCaracteres;
        int numCount = numbers.length ~/ 4;
        int numFrequency = newPassLen ~/ numCount;
        String realPassword = "";
        for (int index = 0, insertSpecialCarac = 0, insertNumber = 0, newChar = 0;
            index < newPassLen;
            index++, insertSpecialCarac++, insertNumber++) {
          if (insertSpecialCarac == caracFrequency) {
            realPassword += index % 2 == 0 ? _getSpecialChar(++newChar) : _getSpecialChar(newChar += 2);
            insertSpecialCarac = 0;
          }
          if (insertNumber == numFrequency) {
            realPassword += _getPasswordNumber(index);
            insertNumber = 0;
          }
          realPassword += halfPassword[index];
        }
        return realPassword;
      } catch (erro) {
        return erro.toString();
      }
    }
    return senhaReal;
  }

  static String _getSubStringPassword(String password) {
    String newPassword = password;
    while (newPassword.length > 50) {
      newPassword = newPassword.substring(0, newPassword.length ~/ 3);
    }
    return newPassword;
  }

  static Future<bool> validarChaveInserida(String? chaveGeral) async {
    try {
      String? mensagemCifrada = Configuration.configs.getString(_applyHashAlgorithm(hashs.sha512, "validateKey"));
      String? mensagemDecifrada = await decipherString(mensagemCifrada!, chaveGeral);
      return mensagemDecifrada == _applyHashAlgorithm(hashs.sha512, "Mensagem para verificar se a chave informada de fato está correta");
    } catch (erro) {
      return false;
    }
  }

  static Future<bool> adicionarHashValidacao(String chaveGeral) async {
    String message = await cipherString(
      _applyHashAlgorithm(hashs.sha512, "Mensagem para verificar se a chave informada de fato está correta"),
      chaveGeral,
    );
    return Configuration.configs.setString(_applyHashAlgorithm(hashs.sha512, "validateKey"), message);
  }

  static Future<String?> decipherString(String cripted, String? chaveGeral) async {
    try {
      String? key = await getDefaultKey(chaveGeral);
      return await FlutterAesEcbPkcs5.decryptString(cripted, key!);
    } catch (erro) {
      return erro.toString();
    }
  }

  static Future<String> cipherString(String senha, String? chaveGeral) async {
    String? key = await getDefaultKey(chaveGeral);
    return (await FlutterAesEcbPkcs5.encryptString(senha, key!))!;
  }

  static String recuperarBaseChaveGeral() {
    String key = Configuration.configs.getString(_applyHashAlgorithm(hashs.sha512, "key"))!;
    return fromBase64(key);
  }

  static Future<String?> getDefaultKey(String? base) async {
    if (base == null) {
      String key = Configuration.configs.getString(_applyHashAlgorithm(hashs.sha512, "key"))!;
      String chave = _applyHashAlgorithm(hashs.sha512, utf8.decode(base64.decode(key))).substring(0, 32);
      return chave;
    } else {
      String chave = _applyHashAlgorithm(hashs.sha512, base).substring(0, 32);
      return chave;
    }
  }

  static Future<bool> alterarSenhaGeral(String chaveAntiga, String base) async {
    try {
      List<Senha> senhas = <Senha>[];
      if (Configuration.instance.isBiometria) {
        await createDefaultKey(base);
      }

      senhas = await SenhaDBSource().getTodasSenhas();

      for (Senha senha in senhas) {
        String? senhaDecifrada = await decipherString(senha.senhaBase, chaveAntiga);
        senha.senhaBase = await cipherString(senhaDecifrada!, base);
        SenhaDBSource().atualizarSenha(senha);
      }

      await adicionarHashValidacao(base);
      Util.senhas = await SenhaDBSource().getTodasSenhas();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  static Future<bool> createDefaultKey(String baseKey) async {
    try {
      return Configuration.configs.setString(_applyHashAlgorithm(hashs.sha512, "key"), toBase64(baseKey));
    } catch (erro) {
      return false;
    }
  }
}
