import 'package:flutter/services.dart';
import 'package:hashpass/database/enums.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum DBOperation {
  equal,
  notEqual,
  higher,
  minor,
  minorEqual,
  higherEqual;

  @override
  String toString() => name
      .toLowerCase()
      .replaceAll(RegExp(r'equal'), '=')
      .replaceAll(RegExp(r'minor'), '<')
      .replaceAll(RegExp(r'not'), '!')
      .replaceAll(RegExp(r'higher'), '>');
}

class DBUtil {
  static int dbVersion = 3;
  static Database? _dbConnection;

  static Future<String> _getSQLVersion(int version, DBAction action) async =>
      await rootBundle.loadString('assets/sql/db${action.name}v$version.sql');

  static Future<void> _checkConnection() async {
    if (!(_dbConnection?.isOpen ?? false)) {
      _dbConnection = await openDatabase(
        join(await getDatabasesPath(), 'hashpass_db'),
        version: DBUtil.dbVersion,
        onCreate: (db, version) async {
          return await _executeSQL(
            db,
            await _getSQLVersion(
              version,
              DBAction.create,
            ),
          );
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          for (int version = oldVersion + 1; version <= newVersion; version++) {
            await _executeSQL(
              db,
              await _getSQLVersion(version, DBAction.update),
            );
          }
        },
      );
    }
  }

  static Future<void> _executeSQL(Database db, String sql) async {
    List<String> statements = sql.split(';');
    for (String statement in statements) {
      await db.execute(statement);
    }
  }

  static Future<int> save(
    DBTable table,
    Map<String, dynamic> data, {
    ConflictAlgorithm onCoflict = ConflictAlgorithm.replace,
    bool closeOnFinish = true,
  }) async {
    try {
      await _checkConnection();
      int lastId = await _dbConnection!
          .insert(table.name, data, conflictAlgorithm: onCoflict);
      if (closeOnFinish) await close();
      return lastId > 0 ? lastId : -1;
    } on DatabaseException catch (_) {
      return save(table, data);
    }
  }

  static Future<bool> remove(
    DBTable table,
    String primaryKeyColumn,
    String id, {
    DBOperation operation = DBOperation.equal,
  }) async {
    try {
      await _checkConnection();
      int rowsAffected = await _dbConnection!.delete(
        table.name,
        where: '$primaryKeyColumn ${operation.toString()} ?',
        whereArgs: [id],
      );
      await close();
      return rowsAffected > 0;
    } on DatabaseException catch (_) {
      return remove(table, primaryKeyColumn, id);
    }
  }

  static Future<void> close() async {
    await _dbConnection!.close();
  }

  static Future<List<Map<String, dynamic>>> getDbData(DBTable table,
      {String? where}) async {
    await _checkConnection();
    List<Map<String, dynamic>> data =
        await _dbConnection!.query(table.name, where: where);
    await close();
    return data;
  }

  static Future<void> execute(String query) async {
    await _checkConnection();
    await _dbConnection!.execute(query);
  }
}
