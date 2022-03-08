import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart' as hashs;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:hashpass/DTO/exportdata_dto.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/hash_function.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/util.dart';
import 'package:intl/intl.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../DTO/password_leak_dto.dart';
import '../Model/configuration.dart';
import 'http.dart';

class Criptografia {
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
    String passwordHash = _aplicarAlgoritmoHash(hashs.sha1, basePass);
    String response = await HTTPRequest.requestPasswordLeak(passwordHash);
    String passwordSubHash = passwordHash.substring(5).toUpperCase();

    List<String> leakedPasswords = response.split('\n');

    for (int index = 0, length = leakedPasswords.length; index < length; index += 1) {
      List<String> passwordInfo = leakedPasswords[index].split(':');
      if (passwordInfo[0] == passwordSubHash) {
        int leakCount = int.parse(passwordInfo[1]);
        return PasswordLeakDTO(message: 'Esta senha foi vazada pelo menos $leakCount vezes!', leakCount: leakCount);
      }
    }
    return PasswordLeakDTO(message: 'Sua senha tem grandes chances de não ter sido vazada!', leakCount: 0);
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

  static final List<HashFunction> algoritmos = [
    HashFunction(index: 0, label: "SHA-512"),
    HashFunction(index: 1, label: "MD-5"),
    HashFunction(index: 2, label: "SHA-256"),
    HashFunction(index: 3, label: "SHA-384"),
    HashFunction(index: 4, label: "SHA-224"),
    HashFunction(index: 5, label: "SHA-1"),
    HashFunction(index: 6, label: "HMAC"),
  ];

  static Future<String> gerarWebToken(String subject, Map<String, dynamic> payload, String key) async {
    try {
      final claimSet = JwtClaim(
          subject: subject,
          issuer: 'HashPass',
          //audience: <String>['audience1.example.com', 'audience2.example.com'],
          otherClaims: <String, dynamic>{
            'type': 'Dart JWT',
            "alg": "HS256",
          },
          payload: payload,
          maxAge: const Duration(minutes: 1));
      debugPrint('Gerou a base do token');
      String token = issueJwtHS256(claimSet, key);
      debugPrint('Token: $token');

      return token;
    } on Exception catch (erro) {
      debugPrint("$erro");
      return erro.toString();
    }
  }

  static String generateJWTKey(String? email) {
    if (email == null) {
      email = '';
    }
    Random random = Random();
    return _aplicarAlgoritmoHash(
      hashs.sha256,
      email + DateTime.now().microsecondsSinceEpoch.toString() + random.nextInt(1000000).toString(),
    );
  }

  static Future<String> exportarDados() async {
    try {
      String? emailUsuario = Configuration.getEmail();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      //IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      //debugPrint('Running on ${iosInfo.utsname.machine}');

      String baseFileKey = "";
      String dispositivo = "";
      String sistema = "";

      if (Platform.isAndroid) {
        dispositivo = androidInfo.manufacturer! + " " + androidInfo.model!;
        sistema = androidInfo.version.release!;
        baseFileKey = _aplicarAlgoritmoHash(hashs.sha256, emailUsuario! + dispositivo + androidInfo.id! + androidInfo.androidId!);
      } else if (Platform.isIOS) {}

      final key = generateJWTKey(emailUsuario);
      final date = DateTime.now();
      String token = await gerarWebToken(
        'data export',
        <String, dynamic>{
          "chave": baseFileKey,
          "SO": sistema,
          "dispositivo": dispositivo,
          "email": emailUsuario,
          "data": DateFormat("dd/MM/yyyy").format(date),
          "horario": DateFormat("HH:mm:ss").format(date)
        },
        key,
      );

      List<Senha> senhas = await SenhaDBSource().getTodasSenhas();

      for (Senha senha in senhas) {
        senha.titulo = await criptografarSenha(senha.titulo, baseFileKey);
        senha.credencial = await criptografarSenha(senha.credencial, baseFileKey);
        senha.senhaBase = await criptografarSenha(senha.senhaBase, baseFileKey);
      }

      String response = await HTTPRequest.postRequest(
        "/exportData",
        DataExportDTO(token: token, key: key, passwords: senhas).toJson(),
      );
      debugPrint(response);
      return response;
    } on Exception catch (erro) {
      debugPrint("$erro");
      return erro.toString();
    }
  }

  static Future<String> compressString(String originalString) async {
    try {
      String compressed;
      int cont = 0;
      for (compressed = originalString; compressed.length > 100; cont++) {
        debugPrint("Compressed before compress: $compressed, lenght: ${compressed.length}");
        List<int> bytes = const ZLibEncoder().encode(compressed.codeUnits);
        compressed = base64.encode(bytes);
        debugPrint("Compressão realizada: $compressed, length: ${compressed.length}");
        if (cont > 10) {
          break;
        }
      }
      return compressed;
    } catch (erro) {
      debugPrint("Erro: $erro");
      return erro.toString();
    }
  }

  static String _aplicarAlgoritmoHash(hashs.Hash algotimo, String base) {
    var bytes = utf8.encode(base);
    var digest = algotimo.convert(bytes);
    return digest.toString();
  }

  static String _aplicacarHash(int algoritmo, String senha) {
    switch (algoritmo) {
      case 0:
        return _aplicarAlgoritmoHash(hashs.sha512, senha);
      case 1:
        return _aplicarAlgoritmoHash(hashs.md5, senha);
      case 2:
        return _aplicarAlgoritmoHash(hashs.sha256, senha);
      case 3:
        return _aplicarAlgoritmoHash(hashs.sha384, senha);
      case 4:
        return _aplicarAlgoritmoHash(hashs.sha224, senha);
      case 5:
        return _aplicarAlgoritmoHash(hashs.sha1, senha);
      case 6:
        var key = utf8.encode(senha);
        var bytes = utf8.encode(senha);
        var hmacSha256 = hashs.Hmac(hashs.sha256, key);
        var digest = hmacSha256.convert(bytes);
        return digest.toString();
      default:
        return "";
    }
  }

  static String gerarToken(String base) {
    return _aplicarAlgoritmoHash(hashs.sha256, base + DateTime.now().millisecondsSinceEpoch.toString());
  }

  static Future<String> aplicarAlgoritmos(int algoritmo, String senha, bool isAvancado, String? chaveGeral) async {
    String? senhaDecifrada = await decifrarSenha(senha, chaveGeral);
    String senhaReal = _aplicacarHash(algoritmo, senhaDecifrada!);
    if (isAvancado) {
      try {
        senhaReal = (await FlutterAesEcbPkcs5.encryptString(senhaReal, senhaReal.substring(0, 32)))!;
        senhaReal = base64Encode(senhaReal.codeUnits);
        int length = senhaReal.length;
        int numCaracteres = (length / 3) ~/ 10;
        List<int> numbers = <int>[];
        for (int index = 0; index < length; index++) {
          if (senhaReal[index].contains(new RegExp(r'[0-9]'))) {
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
        debugPrint(erro.toString());
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
      String? mensagemCifrada = Configuration.configs.getString(_aplicarAlgoritmoHash(hashs.sha512, "validateKey"));
      String? mensagemDecifrada = await decifrarSenha(mensagemCifrada!, chaveGeral);
      return mensagemDecifrada == _aplicarAlgoritmoHash(hashs.sha512, "Mensagem para verificar se a chave informada de fato está correta");
    } catch (erro) {
      debugPrint(erro.toString());
      return false;
    }
  }

  static Future<bool> adicionarHashValidacao(String chaveGeral) async {
    String message = await criptografarSenha(
      _aplicarAlgoritmoHash(hashs.sha512, "Mensagem para verificar se a chave informada de fato está correta"),
      chaveGeral,
    );
    return Configuration.configs.setString(_aplicarAlgoritmoHash(hashs.sha512, "validateKey"), message);
  }

  static Future<String?> decifrarSenha(String cripted, String? chaveGeral) async {
    try {
      String? key = await recuperarChaveGeral(chaveGeral);
      //debugPrint("Chave decifrar: $key");
      return await FlutterAesEcbPkcs5.decryptString(cripted, key!);
    } catch (erro) {
      debugPrint(erro.toString());
      return erro.toString();
    }
  }

  static Future<String> criptografarSenha(String senha, String? chaveGeral) async {
    String? key = await recuperarChaveGeral(chaveGeral);
    return (await FlutterAesEcbPkcs5.encryptString(senha, key!))!;
  }

  static String recuperarBaseChaveGeral() {
    String key = Configuration.configs.getString(_aplicarAlgoritmoHash(hashs.sha512, "key"))!;
    return utf8.decode(base64.decode(key));
  }

  static Future<String?> recuperarChaveGeral(String? base) async {
    if (base == null) {
      String key = Configuration.configs.getString(_aplicarAlgoritmoHash(hashs.sha512, "key"))!;
      String chave = _aplicarAlgoritmoHash(hashs.sha512, utf8.decode(base64.decode(key))).substring(0, 32);
      //debugPrint("Chave geral: " + chave);
      return chave;
    } else {
      String chave = _aplicarAlgoritmoHash(hashs.sha512, base).substring(0, 32);
      //debugPrint("Chave geral: " + chave);
      return chave;
    }
  }

  static Future<bool> alterarSenhaGeral(String chaveAntiga, String base) async {
    try {
      List<Senha> senhas = <Senha>[];
      if (Configuration.isBiometria) {
        await criarChaveGeral(base);
      }

      senhas = await SenhaDBSource().getTodasSenhas();

      for (Senha senha in senhas) {
        String? senhaDecifrada = await decifrarSenha(senha.senhaBase, chaveAntiga);
        senha.senhaBase = await criptografarSenha(senhaDecifrada!, base);
        SenhaDBSource().atualizarSenha(senha);
      }

      await adicionarHashValidacao(base);
      Util.senhas = await SenhaDBSource().getTodasSenhas();
      return true;
    } on Exception catch (erro) {
      debugPrint("$erro");
      return false;
    }
  }

  static Future<bool> criarChaveGeral(String baseKey) async {
    try {
      return Configuration.configs.setString(_aplicarAlgoritmoHash(hashs.sha512, "key"), base64.encode(utf8.encode(baseKey)));
    } catch (erro) {
      debugPrint(erro.toString());
      return false;
    }
  }
}
