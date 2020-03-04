import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Created by U-Demon
/// Date: 2020/3/3
class Provider {

  static Database db;

  // 获取数据库中所有的表
  Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      targetList.add(item['name']);
    });
    return targetList;
  }

  // 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTableIsRight() async {

  }

  // 初始化数据库
  Future init(bool isCreate) async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'easy_app.db');
    print(path);
  }

}
