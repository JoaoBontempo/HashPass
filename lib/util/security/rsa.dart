import 'package:crypton/crypton.dart';

class RSA {
  static RSAKeypair generateKeyPair({int keySize = 2048}) {
    return RSAKeypair.fromRandom(keySize: keySize);
  }

  static String encrypt(RSAPublicKey key, String message) {
    return key.encrypt(message);
  }

  static String decrypt(RSAPrivateKey key, String message) {
    return key.decrypt(message);
  }
}
