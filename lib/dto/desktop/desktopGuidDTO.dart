import 'dart:convert';

import 'package:hashpass/dto/desktop/desktopOperationDTO.dart';

class ExchangeKeyDTO {
  String key;
  ExchangeKeyDTO({
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
    };
  }

  factory ExchangeKeyDTO.fromMap(Map<String, dynamic> map) {
    return ExchangeKeyDTO(
      key: map['key'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExchangeKeyDTO.fromJson(String source) =>
      ExchangeKeyDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DesktopGuidDTO extends Serializable {
  String guid;
  DesktopGuidDTO({
    required this.guid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guid': guid,
    };
  }

  factory DesktopGuidDTO.fromMap(Map<String, dynamic> map) {
    return DesktopGuidDTO(
      guid: map['guid'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory DesktopGuidDTO.fromJson(String source) =>
      DesktopGuidDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
