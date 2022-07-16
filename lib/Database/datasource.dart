import 'package:flutter/cupertino.dart';
import 'package:hashpass/Database/database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/senha.dart';

class SenhaDBSource {
  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) async {
        debugPrint('Creating DATABASE');
        await db.execute(CREATE_TABLE_SENHA);
      },
      version: DB_VERSION,
    );
  }

  Future<int> excluirSenha(int id) async {
    final Database db = await _getDatabase();

    return await db.delete(SENHA_TABLE_NAME, where: "id == ?", whereArgs: [id]);
  }

  Future<int> atualizarSenha(Senha senha) async {
    final Database db = await _getDatabase();
    debugPrint("Senha atualizada: ${senha.toString()}");
    return await db.update(
      SENHA_TABLE_NAME,
      senha.toMap(),
      where: "id == ?",
      whereArgs: [senha.id],
    );
  }

  Future<dynamic> inserirSenha(Senha senha) async {
    try {
      final Database db = await _getDatabase();

      senha.id = await db.rawInsert('''
          INSERT INTO $SENHA_TABLE_NAME 
            (
              $SENHA_TITULO_NAME, 
              $SENHA_CREDENCIAL_NAME, 
              $SENHA_SENHA_BASE_NAME, 
              $SENHA_AVANCADO_NAME,
              $SENHA_ALGORITMO_NAME, 
              $SENHA_CRIPTOGRAFADO_NAME,
              $PASSWORD_LEAK_COUNT
            ) 
          VALUES 
            ( 
              '${senha.titulo}', 
              '${senha.credencial}', 
              '${senha.senhaBase}', 
              ${senha.avancado ? 1 : 0}, 
              ${senha.algoritmo}, 
              ${senha.criptografado ? 1 : 0},
              ${senha.leakCount}
            )
      ''');

      return senha;
    } on Exception catch (erro) {
      debugPrint(erro.toString());
      return erro;
    }
  }

  Future<List<Senha>> getTodasSenhas() async {
    try {
      final Database db = await _getDatabase();

      final List<Map<String, dynamic>> senhas = await db.query(SENHA_TABLE_NAME, orderBy: "$SENHA_ID_NAME ASC");

      return List.generate(senhas.length, (i) {
        return Senha.fromMap(senhas[i]);
      });
    } catch (erro) {
      debugPrint('GET ERROR');
      debugPrint(erro.toString());
      return List.empty();
    }
  }
}
