import 'dart:convert';

import 'package:hashpass/dto/desktop/desktopOperationDTO.dart';

class DesktopCopyPasswordDTO extends Serializable {
  String title;
  String password;
  DesktopCopyPasswordDTO({
    required this.title,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'password': password,
    };
  }

  factory DesktopCopyPasswordDTO.fromMap(Map<String, dynamic> map) {
    return DesktopCopyPasswordDTO(
      title: map['title'] as String,
      password: map['password'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory DesktopCopyPasswordDTO.fromJson(String source) =>
      DesktopCopyPasswordDTO.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
