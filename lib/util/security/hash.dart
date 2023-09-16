import 'dart:convert';
import 'package:crypto/crypto.dart' as hashes;

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

class Hash {
  static String _applyHashAlgorithm(hashes.Hash algorithm, String base) {
    var bytes = utf8.encode(base);
    var digest = algorithm.convert(bytes);
    return digest.toString();
  }

  static String applyHash(hashes.Hash algorithm, String base) {
    var bytes = utf8.encode(base);
    var digest = algorithm.convert(bytes);
    return digest.toString();
  }

  static String applyHashPass(HashAlgorithm algorithm, String text) {
    switch (algorithm) {
      case HashAlgorithm.SHA512:
        return _applyHashAlgorithm(hashes.sha512, text);
      case HashAlgorithm.MD5:
        return _applyHashAlgorithm(hashes.md5, text);
      case HashAlgorithm.SHA256:
        return _applyHashAlgorithm(hashes.sha256, text);
      case HashAlgorithm.SHA384:
        return _applyHashAlgorithm(hashes.sha384, text);
      case HashAlgorithm.SHA224:
        return _applyHashAlgorithm(hashes.sha224, text);
      case HashAlgorithm.SHA1:
        return _applyHashAlgorithm(hashes.sha1, text);
      case HashAlgorithm.HMAC:
        List<int> bytes = utf8.encode(text);
        return hashes.Hmac(hashes.sha256, bytes).convert(bytes).toString();
      default:
        return "";
    }
  }
}
