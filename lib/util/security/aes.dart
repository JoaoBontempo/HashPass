import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:aescryptojs/aescryptojs.dart';

class AESHashPass {
  static Future<String> encrypt(String message, String key) async {
    final encrypter =
        Encrypter(AES(Key.fromUtf8(key), mode: AESMode.ecb, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(message);
    return base64.encode(encrypted.bytes);
  }

  static Future<String> decrypt(String message, String key) async {
    final encrypter =
        Encrypter(AES(Key.fromUtf8(key), mode: AESMode.ecb, padding: 'PKCS7'));
    final decrypted = encrypter.decrypt(Encrypted(base64.decode(message)));
    return decrypted;
  }

  static String encryptServer(String message, String key) {
    return encryptAESCryptoJS(message, key);
  }

  static String decryptServer(String message, String key) {
    return decryptAESCryptoJS(message, key);
  }
}
