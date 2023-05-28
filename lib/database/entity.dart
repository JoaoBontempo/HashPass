import 'package:hashpass/database/database.dart';
import 'package:hashpass/database/enums.dart';

abstract class IEntity {
  Map<String, dynamic> toMap();

  void setPrimaryKey(int insertedPrimaryKey);

  DBTable table();
  String primaryKeyColumn();
  String idName();

  Future<int> save() async {
    int lastId = await DBUtil.save(table(), toMap());
    setPrimaryKey(lastId);
    return lastId;
  }

  Future<bool> delete() async {
    return DBUtil.remove(table(), primaryKeyColumn(), idName());
  }
}