import 'dart:convert';

class Senha {
  int? id;
  String titulo;
  String credencial;
  String senhaBase;
  bool avancado;
  int algoritmo;
  bool criptografado;
  Senha({
    this.id,
    required this.titulo,
    required this.credencial,
    required this.senhaBase,
    required this.avancado,
    required this.algoritmo,
    required this.criptografado,
  });

  @override
  String toString() {
    return 'Senha(id: $id, titulo: $titulo, credencial: $credencial, senhaBase: $senhaBase, avancado: $avancado, algoritmo: $algoritmo)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'credencial': credencial,
      'senhaBase': senhaBase,
      'avancado': avancado ? 1 : 0,
      'criptografado': criptografado ? 1 : 0,
      'algoritmo': algoritmo,
    };
  }

  factory Senha.fromMap(Map<String, dynamic> map) {
    return Senha(
      id: map['id']?.toInt(),
      titulo: map['titulo'] ?? '',
      credencial: map['credencial'] ?? '',
      senhaBase: map['senhaBase'] ?? '',
      avancado: map['avancado'] == 1 ? true : false,
      algoritmo: map['algoritmo']?.toInt() ?? 0,
      criptografado: map['criptografado'] == 1 ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Senha.fromJson(String source) => Senha.fromMap(json.decode(source));
}
