import 'dart:convert';

import '../Model/senha.dart';

class DataExportDTO {
  String token;
  String key;
  List<Senha> passwords;

  DataExportDTO({
    required this.token,
    required this.key,
    required this.passwords,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'key': key,
      'passwords': passwords.map((x) => x.toMap()).toList(),
    };
  }

  factory DataExportDTO.fromMap(Map<String, dynamic> map) {
    return DataExportDTO(
      token: map['token'] ?? '',
      key: map['key'] ?? '',
      passwords: List<Senha>.from(map['passwords']?.map((x) => Senha.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DataExportDTO.fromJson(String source) => DataExportDTO.fromMap(json.decode(source));
}
