/// Created by U-Demon
/// Date: 2020/3/5
class Api {
  // 服务器地址
//  static const String BASE_URL = 'http://127.0.0.1:28100';

  static const String CHECK_LOGIN = BASE_URL + 'checkLogin'; //验证登陆

  static const String DO_LOGIN = BASE_URL + 'doLogin'; //登陆

  // 登录
  static Map<String, dynamic> LOGIN(String name, String pwd) {
    return {
      'cmd': '0',
      'name': name,
      'pwd': pwd
    };
  }

  // 获取数据表数据
  static Map<String, dynamic> GET_TABLE_DATA(String tableName, String token) {
    return {
      'token': token,
      'cmd': '2',
      'table_name': tableName
    };
  }

  // 获取指定列的数据
  static Map<String, dynamic> GET_TABLE_DATA_COLUMN(String tableName, List<String> cols, String token) {
    if (cols == null || cols.isEmpty)
      return GET_TABLE_DATA(tableName, token);
    return {
      'token': token,
      'cmd': '18',
      'table': tableName,
      'cols': cols.join(',')
    };
  }

  // 获取指定SN的数
  static Map<String, dynamic> GET_TABLE_DATA_BY_SN(String tableName, int sn, String token) {
    return {
      'token': token,
      'cmd': '5',
      'table': tableName,
      'sn': sn.toString()
    };
  }

  // 更新数据
  static Map<String, dynamic> UPDATE_TABLE_DATA(String tableName, int ver, int sn, String json, String token) {
    return {
      'token': token,
      'cmd': '6',
      'table': tableName,
      'sn': sn.toString(),
      'verNum': ver.toString(),
      'data': json,
    };
  }

}
