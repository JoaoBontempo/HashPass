import 'dart:convert';

import 'package:crypto/crypto.dart' as hashs;
import 'package:flutter/material.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:hashpass/Model/hash_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static String basePass = "";

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
    final configs = await SharedPreferences.getInstance();
    String? mensagemCifrada = configs.getString(_aplicarAlgoritmoHash(hashs.sha512, "validateKey"));
    String? mensagemDecifrada = await decifrarSenha(mensagemCifrada!, chaveGeral);

    return mensagemDecifrada == _aplicarAlgoritmoHash(hashs.sha512, "Mensagem para verificar se a chave informada de fato está correta");
  }

  static Future<bool> adicionarHashValidacao() async {
    final configs = await SharedPreferences.getInstance();
    String message =
        await criptografarSenha(_aplicarAlgoritmoHash(hashs.sha512, "Mensagem para verificar se a chave informada de fato está correta"), null);
    return configs.setString(_aplicarAlgoritmoHash(hashs.sha512, "validateKey"), message);
  }

  static Future<String?> decifrarSenha(String cripted, String? chaveGeral) async {
    String? key = await recuperarChaveGeral(chaveGeral);
    return await FlutterAesEcbPkcs5.decryptString(cripted, key!);
  }

  static Future<String> criptografarSenha(String senha, String? chaveGeral) async {
    String? key = await recuperarChaveGeral(chaveGeral);
    return (await FlutterAesEcbPkcs5.encryptString(senha, key!))!;
  }

  static Future<String?> recuperarChaveGeral(String? base) async {
    if (base == null) {
      final configs = await SharedPreferences.getInstance();
      String key = configs.getString(_aplicarAlgoritmoHash(hashs.sha512, "key"))!;
      return _aplicarAlgoritmoHash(hashs.sha512, key).substring(0, 32);
    } else {
      return _aplicarAlgoritmoHash(hashs.sha512, base64Encode(base.codeUnits)).substring(0, 32);
    }
  }

  static Future<bool> criarChaveGeral(String baseKey) async {
    try {
      final configs = await SharedPreferences.getInstance();
      return configs.setString(_aplicarAlgoritmoHash(hashs.sha512, "key"), base64Encode(baseKey.codeUnits));
    } catch (erro) {
      debugPrint(erro.toString());
      return false;
    }
  }
}
