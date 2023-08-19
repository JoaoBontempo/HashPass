import 'dart:convert';

enum DesktopOperation { COPY, SHOW }

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
      'operation': operation.index
    };
  }

  factory DesktopOperationDTO.fromMap(
    Map<String, dynamic> map,
    DataType Function(String) serialize,
  ) {
    return DesktopOperationDTO(
      message: map['message'] as String,
      success: map['success'] as bool,
      data: serialize(map['data']),
      operation: DesktopOperation.values
          .firstWhere((operation) => operation.index == map['operation']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DesktopOperationDTO.fromJson(
    String source,
    DataType Function(String) serialize,
  ) =>
      DesktopOperationDTO.fromMap(
        json.decode(source) as Map<String, dynamic>,
        serialize,
      );
}
