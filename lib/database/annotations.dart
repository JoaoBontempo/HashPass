import 'enums.dart';

class Entity {
  const Entity(this.tableName);

  final String tableName;
}

class PrimaryKey {
  const PrimaryKey({this.setOnSave = true});
  final bool setOnSave;
}

class ForeignKey {
  const ForeignKey(
    this.type, {
    this.loadType = LoadType.EAGER,
  });
  final ForeignType type;
  final LoadType loadType;
}
