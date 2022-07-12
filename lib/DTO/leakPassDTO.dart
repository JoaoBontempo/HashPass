import 'dart:convert';

class PasswordLeakDTO {
  String message;
  int leakCount;
  PasswordLeakDTO({
    required this.message,
    required this.leakCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'leakCount': leakCount,
    };
  }

  factory PasswordLeakDTO.fromMap(Map<String, dynamic> map) {
    return PasswordLeakDTO(
      message: map['message'] ?? '',
      leakCount: map['leakCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordLeakDTO.fromJson(String source) => PasswordLeakDTO.fromMap(json.decode(source));

  @override
  String toString() => 'PasswordLeakDTO(message: $message, leakCount: $leakCount)';
}
