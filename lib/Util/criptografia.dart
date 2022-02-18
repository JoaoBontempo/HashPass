import 'dart:convert';

import 'package:crypto/crypto.dart' as hashs;
import 'package:flutter/material.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:hashpass/Model/hash_function.dart';

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

  static Future<String> aplicarAlgoritmos(int algoritmo, String senha, bool isAvancado) async {
    String senhaReal = _aplicacarHash(algoritmo, senha);
    if (isAvancado) {
      try {
        senhaReal = (await FlutterAesEcbPkcs5.encryptString(senhaReal, senhaReal.substring(0, 32)))!;
        senhaReal = "@!" + base64Encode(senhaReal.codeUnits) + "_%#";
      } catch (erro) {
        debugPrint(erro.toString());
        return erro.toString();
      }
    }

    debugPrint(senhaReal);
    return senhaReal;
  }
}
