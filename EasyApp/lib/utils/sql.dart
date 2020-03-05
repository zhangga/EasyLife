import 'package:sqflite/sqflite.dart';
import './provider.dart';

class BaseModel {
  Database db;
  final String table = "";
  var query;

  BaseModel(this.db) {
    query = db.query;
  }
}

class SQL extends BaseModel {
  final String tableName;

  SQL.setTable(String name) : tableName = name, super(Provider.db);

  // 获取整表数据
  Future<List> get() async {
    return await this.query(tableName);
  }

  String getTableName() {
    return tableName;
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> json) async {
    var id = await this.db.insert(tableName, json);
    json['id'] = id;
    return json;
  }

  Future<List> getByCondition({Map<dynamic, dynamic> conditions}) async {
    if (conditions == null || conditions.isEmpty) {
      return this.get();
    }

    String stringConditions = '';
    int index = 0;
    conditions.forEach((key, value) {
      if (value == null)
        return;
      if (value.runtimeType == String) {
        stringConditions = '$stringConditions $key = "$value"';
      }
      else if (value.runtimeType == int) {
        stringConditions = '$stringConditions $key = $value';
      }
      if (index >= 0 && index < conditions.length - 1) {
        stringConditions = '$stringConditions and';
      }
      index++;
    });
    return await this.query(tableName, where: stringConditions);
  }

  Future<int> deleteAll() async {
    return await this.db.delete(tableName);
  }
}
