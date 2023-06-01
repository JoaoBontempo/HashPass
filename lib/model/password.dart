import 'dart:convert';
import 'package:hashpass/database/database.dart';
import 'package:hashpass/database/entity.dart';
import 'package:hashpass/database/enums.dart';
import 'package:hashpass/util/cryptography.dart';

class Password extends IEntity {
  int? id;
  String title;
  String credential;
  String basePassword;
  bool isAdvanced;
  HashAlgorithm hashAlgorithm;
  bool useCriptography;
  int leakCount;
  Password({
    this.id,
    required this.title,
    required this.credential,
    required this.basePassword,
    required this.isAdvanced,
    required this.hashAlgorithm,
    required this.useCriptography,
    required this.leakCount,
  });

  static List<Password> serializeList(String data) {
    return List<dynamic>.from(json.decode(data))
        .map((x) => Password.fromMap(x))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'credential': credential,
      'basePassword': basePassword,
      'isAdvanced': isAdvanced ? 1 : 0,
      'useCriptography': useCriptography ? 1 : 0,
      'hashAlgorithm': hashAlgorithm.index,
      'leakCount': leakCount,
    };
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      credential: map['credential'] ?? '',
      basePassword: map['basePassword'] ?? '',
      isAdvanced: map['isAdvanced'] == 1 ? true : false,
      hashAlgorithm: HashAlgorithm.values.firstWhere((algorithm) =>
          algorithm.index == (map['hashAlgorithm']?.toInt() ?? 0)),
      useCriptography: map['useCriptography'] == 1 ? true : false,
      leakCount: map['leakCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Password.fromJson(String source) =>
      Password.fromMap(json.decode(source));

  HashAlgorithm get hashFunction => HashAlgorithm.values
      .firstWhere((function) => function.index == hashAlgorithm.index);

  @override
  String toString() {
    return 'Senha(id: $id, titulo: $title, credencial: $credential, senhaBase: $basePassword, avancado: $isAdvanced, algoritmo: $hashAlgorithm, criptografado: $useCriptography, leakCount: $leakCount)';
  }

  @override
  String idName() => id.toString();

  @override
  String primaryKeyColumn() => 'id';

  @override
  void setPrimaryKey(int insertedPrimaryKey) => id = insertedPrimaryKey;

  @override
  DBTable table() => DBTable.senha;

  static Future<List<Password>> findAll() async => findByWhere();

  static Future<List<Password>> findByWhere({String? whereClause}) async {
    List<Map<String, dynamic>> passwords =
        await DBUtil.getDbData(DBTable.senha, where: whereClause);

    return passwords.map((password) => Password.fromMap(password)).toList();
  }
}
