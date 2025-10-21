import 'dart:convert';

class DesktopAuthDTO {
  String id;
  String publicKey;
  DesktopAuthDTO({
    required this.id,
    required this.publicKey,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'publicKey': publicKey,
    };
  }

  factory DesktopAuthDTO.fromMap(Map<String, dynamic> map) {
    return DesktopAuthDTO(
      id: map['id'] as String,
      publicKey: map['publicKey'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DesktopAuthDTO.fromJson(String source) =>
      DesktopAuthDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
