import 'dart:convert';

class DesktopPublicKeyDTO {
  String publicKey;
  DesktopPublicKeyDTO({
    required this.publicKey,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'publicKey': publicKey,
    };
  }

  factory DesktopPublicKeyDTO.fromMap(Map<String, dynamic> map) {
    return DesktopPublicKeyDTO(
      publicKey: map['publicKey'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DesktopPublicKeyDTO.fromJson(String source) =>
      DesktopPublicKeyDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
