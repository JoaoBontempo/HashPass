import 'dart:typed_data';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'dart:convert';

class AES {
  static Future<String> encrypt(String message, String key) async {
    return (await FlutterAesEcbPkcs5.encryptString(message, key))!;
  }

  static Future<String> decrypt(String message, String key) async {
    return (await FlutterAesEcbPkcs5.decryptString(message, key))!;
  }

  static Future<String> encryptServer(String message, String key) async {
    return (await FlutterAesEcbPkcs5.encryptString(message, key))!;
  }

  static String decryptServer(String message, String key) {
    final crypt = AesCrypt(key);
    Uint8List keyBytes = Uint8List.fromList(utf8.encode(key));
    print(keyBytes);
    crypt.setPassword(key);
    crypt.aesSetKeys(keyBytes, keyBytes);
    crypt.aesSetMode(AesMode.cbc);
    return utf8.decode(crypt.aesDecrypt(base64.decode(message)));
  }
}
