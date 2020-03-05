import 'dart:io';

// 平台
const int IOS = 1;
const int Android = 2;
const int Windows = 3;
const int MacOS = 4;
const int Linux = 5;
const int Fuchsia = 6;
const int WEB = 7;

const String GUEST_NAME = 'builder';
const String GUEST_PWD = 'builder@clover';

/// Created by U-Demon
/// Date: 2020/3/5
class Constant {
  // 获取当前平台
  static int _platform = 0;
  static int PLATFORM() {
    if (_platform == 0) {
      try {
        if (Platform.isWindows) {
          _platform = Windows;
        }
        else if (Platform.isAndroid) {
          _platform = Android;
        }
        else if (Platform.isIOS) {
          _platform = IOS;
        }
        else if (Platform.isFuchsia) {
          _platform = Fuchsia;
        }
        else if (Platform.isLinux) {
          _platform = Linux;
        }
        else if (Platform.isMacOS) {
          _platform = MacOS;
        }
      } catch (e) {
        print('无法获取Platform，应该是WEB。');
        _platform = WEB;
      }
    }
    return _platform;
  }
}