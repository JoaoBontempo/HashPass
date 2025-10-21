import 'package:aescryptojs/aescryptojs.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';

class AES {
  static Future<String> encrypt(String message, String key) async {
    return (await FlutterAesEcbPkcs5.encryptString(message, key))!;
  }

  static Future<String> decrypt(String message, String key) async {
    return (await FlutterAesEcbPkcs5.decryptString(message, key))!;
  }

  static String encryptServer(String message, String key) {
    return encryptAESCryptoJS(message, key);
  }

  static String decryptServer(String message, String key) {
    return decryptAESCryptoJS(message, key);
  }
}
