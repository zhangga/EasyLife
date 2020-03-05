import 'package:EasyApp/utils/constant.dart';

/// 用户信息
/// Created by U-Demon
/// Date: 2020/3/5
class UserInfo {
  int id;
  String username;
  String password;
  String token;
  String avatarPic;
  String themeColor;

  UserInfo({
    this.id,
    this.username,
    this.password,
    this.token,
    this.avatarPic,
    this.themeColor,
  });

  bool isGuest() {
    return this.id == 0;
  }

  factory UserInfo.getGuest(String token) {
    return UserInfo(
      id: 0,
      username: GUEST_NAME,
      password: GUEST_PWD,
      token: token,
      avatarPic: "",
      themeColor: "0xFFC91B3A",
    );
  }

  factory UserInfo.getUser(String username, String passwrd, String token) {
    return UserInfo(
      id: 0,
      username: username,
      password: passwrd,
      token: token,
      avatarPic: "",
      themeColor: "0xFFC91B3A",
    );
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    print('fromJOSN $json   ${json['id'].runtimeType}');
    return UserInfo(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      token: "",
      avatarPic: "",
      themeColor: "0xFFC91B3A",
    );
  }
}
