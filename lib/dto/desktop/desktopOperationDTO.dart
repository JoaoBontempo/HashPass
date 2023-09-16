import 'dart:convert';

enum DesktopOperation { COPY, SHOW, BROWSER_FILE, EXCHANGE_KEY }

class Serializable<DataType> {
  String toJson() => '';
  DataType? fromJson() => null;
}

class DesktopOperationDTO<DataType extends Serializable> {
  String message;
  bool success;
  DesktopOperation operation;
  DataType data;
  DesktopOperationDTO({
    required this.message,
    required this.success,
    required this.data,
    required this.operation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'success': success,
      'data': data.toJson(),
      'operation': operation.name
    };
  }

  factory DesktopOperationDTO.fromMap(
    Map<String, dynamic> map,
    DataType Function(Map<String, dynamic>)? serialize,
  ) {
    return DesktopOperationDTO(
      message: (map['message'] ?? '') as String,
      success: (map['success'] ?? true) as bool,
      data: serialize == null ? map['data'] : serialize(map['data']),
      operation: DesktopOperation.values
          .firstWhere((operation) => operation.name == map['operation']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DesktopOperationDTO.fromJson(
    String source, {
    DataType Function(Map<String, dynamic>)? serialize,
  }) =>
      DesktopOperationDTO.fromMap(
        json.decode(source) as Map<String, dynamic>,
        serialize,
      );
}
