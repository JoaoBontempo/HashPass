// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hashpass/dto/desktop/desktopOperationDTO.dart';

class BrowserImportDTO extends Serializable {
  String name;
  String password;
  String username;
  BrowserImportDTO({
    required this.name,
    required this.password,
    required this.username,
  });

  BrowserImportDTO copyWith({
    String? name,
    String? password,
    String? username,
  }) {
    return BrowserImportDTO(
      name: name ?? this.name,
      password: password ?? this.password,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'password': password,
      'username': username,
    };
  }

  factory BrowserImportDTO.fromMap(Map<String, dynamic> map) {
    return BrowserImportDTO(
      name: map['name'] as String,
      password: map['password'] as String,
      username: map['username'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory BrowserImportDTO.fromJson(String source) =>
      BrowserImportDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => toJson();

  @override
  bool operator ==(covariant BrowserImportDTO other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.password == password &&
        other.username == username;
  }

  @override
  int get hashCode => name.hashCode ^ password.hashCode ^ username.hashCode;
}
