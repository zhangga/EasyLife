import 'dart:async';
import 'package:EasyApp/utils/sql.dart';
import './user_info.dart';

/// Created by U-Demon
/// Date: 2020/3/5
class UserInfoControl {

  final String table = "userInfo";
  SQL sql;

  UserInfoControl() {
    sql = SQL.setTable(table);
  }

  // 获取本地用户信息
  Future<UserInfo> getLocalUser() async {
    List<UserInfo> list = await getAllInfo();
    if (list.isEmpty)
      return null;
    return list[0];
  }

  // 插入新的缓存
  Future insert(UserInfo userInfo) {
    var result = sql.insert({'username': userInfo.username, 'password': userInfo.password});
    return result;
  }

  // 获取所有用户信息
  Future<List<UserInfo>> getAllInfo() async {
    List list = await sql.getByCondition();
    List<UserInfo> results = [];
    list.forEach((item) {
      results.add(UserInfo.fromJson(item));
    });
    return results;
  }

  Future deleteAll() async {
    return await sql.deleteAll();
  }

}
