import 'dart:convert';

class SendTokenDTO {
  String token;
  String key;
  SendTokenDTO({
    required this.token,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'key': key,
    };
  }

  factory SendTokenDTO.fromMap(Map<String, dynamic> map) {
    return SendTokenDTO(
      token: map['token'] ?? '',
      key: map['key'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SendTokenDTO.fromJson(String source) => SendTokenDTO.fromMap(json.decode(source));
}
