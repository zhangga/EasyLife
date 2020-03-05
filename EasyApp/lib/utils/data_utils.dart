import 'dart:async' show Future;
import 'package:EasyApp/api/api.dart';
import 'package:EasyApp/model/user_info.dart';
import 'package:EasyApp/model/user_info_cache.dart';
import './net_utils.dart';
import './constant.dart';

/// Created by U-Demon
/// Date: 2020/3/4
class DataUtils {
  // 验证登陆
  static Future checkLogin() async {
    // WEB默认游客登录
    if (Constant.PLATFORM() == WEB) {
      var response = await NetUtils.get(Api.BASE_URL, Api.LOGIN(GUEST_NAME, GUEST_PWD));
      if (response['ret']) {
        // 玩家信息
        UserInfo userInfo = UserInfo.getGuest(response['token']);
        return userInfo;
      }
    }
    // 从本地记录中获取信息，尝试登录
    else {
      UserInfo userInfo = await UserInfoControl().getLocalUser();
      if (userInfo != null) {
        var response = await NetUtils.get(Api.BASE_URL, Api.LOGIN(userInfo.username, userInfo.password));
        if (response['ret']) {
          return UserInfo.getUser(userInfo.username, userInfo.password, response['token']);
        }
      }
    }
    return false;
  }

  // 登录
  static Future doLogin(String name, String pwd) async {
    var response = await NetUtils.get(Api.BASE_URL, Api.LOGIN(name, pwd));
    if (!response['ret']) {
      return "用户名或密码错误";
    }
    return UserInfo.getUser(name, pwd, response['token']);
  }

  // 获取数据表数据
  static Future getTableDatas(String tableName) async {
    var response = await NetUtils.get(Api.BASE_URL, Api.GET_TABLE_DATA(tableName));
    print(response['data']);
  }
}
