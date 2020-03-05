/// Created by U-Demon
/// Date: 2020/3/5
class Api {
  // 服务器地址
  static const String BASE_URL = 'http://127.0.0.1:28100';
//  static const String BASE_URL = 'http://172.17.145.203:28100/';

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
  static Map<String, dynamic> GET_TABLE_DATA(String tableName) {
    return {
      'token': '',
      'cmd': '2',
      'table_name': tableName
    };
  }

}
