import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart' as hashs;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:hashpass/Database/datasource.dart';
import 'package:hashpass/Model/hash_function.dart';
import 'package:hashpass/Model/senha.dart';
import 'package:hashpass/Util/util.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../Model/configuration.dart';
import 'http.dart';

class Criptografia {
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

      Random random = Random();
      debugPrint('Instanciou o random');
      final key = _aplicarAlgoritmoHash(
        hashs.sha256,
        emailUsuario! + DateTime.now().microsecondsSinceEpoch.toString() + random.nextInt(1000000).toString(),
      );

      String token = await gerarWebToken(
        'data export',
        <String, dynamic>{
          "chave": baseFileKey,
          "SO": sistema,
          "dispositivo": dispositivo,
          "email": emailUsuario,
        },
        key,
      );

      List<Senha> senhas = await SenhaDBSource().getTodasSenhas();

      for (Senha senha in senhas) {
        senha.titulo = await criptografarSenha(senha.titulo, baseFileKey);
        senha.credencial = await criptografarSenha(senha.credencial, baseFileKey);
        senha.senhaBase = await criptografarSenha(senha.senhaBase, baseFileKey);
      }

      String response = await HTTPRequest.postRequest("/export?token=$token&key=$key", jsonEncode(senhas));
      debugPrint(response);
      return response;
    } on Exception catch (erro) {
      debugPrint("$erro");
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
        senhaReal = "@!" + base64Encode(senhaReal.codeUnits) + "_%#";
      } catch (erro) {
        debugPrint(erro.toString());
        return erro.toString();
      }
    }
    return senhaReal;
  }

  static Future<bool> validarChaveInserida(String? chaveGeral) async {
    try {
      String? mensagemCifrada = Configuration.configs.getString(_aplicarAlgoritmoHash(hashs.sha512, "validateKey"));
      //debugPrint("Mensagem cifrada: $mensagemCifrada");
      String? mensagemDecifrada = await decifrarSenha(mensagemCifrada!, chaveGeral);
      //debugPrint("Mensagem decifrada: $mensagemDecifrada");
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
