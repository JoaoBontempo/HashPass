import 'dart:convert';

import '../Util/criptografia.dart';

class VerificarUsuarioDTO {
  String destinatario;
  String? token;
  VerificarUsuarioDTO({
    required this.destinatario,
    this.token,
  });

  String construirToken() {
    String tk = Criptografia.gerarToken(destinatario);
    token = tk;
    return tk;
  }

  Map<String, dynamic> toMap() {
    return {
      'destinatario': destinatario,
      'token': token,
    };
  }

  factory VerificarUsuarioDTO.fromMap(Map<String, dynamic> map) {
    return VerificarUsuarioDTO(
      destinatario: map['destinatario'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VerificarUsuarioDTO.fromJson(String source) => VerificarUsuarioDTO.fromMap(json.decode(source));

  @override
  String toString() => 'VerificarUsuarioDTO(destinatario: $destinatario, token: $token)';
}
