import 'package:flutter/material.dart';

import 'package:EasyApp/utils/constant.dart';
import 'package:EasyApp/event/event_bus.dart';
import 'package:EasyApp/utils/provider.dart';
import 'package:EasyApp/utils/data_utils.dart';
import 'package:EasyApp/model/user_info.dart';
import 'package:EasyApp/views/home.dart';
import 'package:EasyApp/views/login_page/login_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:event_bus/event_bus.dart';


// 启动入口
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Constant.PLATFORM() != WEB) {
    final provider = new Provider();
    await provider.init(true);
  }
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int themeColor = 0xFFC91B3A;
  bool _hasLogin = false;
  bool _isLoading = true;
  UserInfo _userInfo;

  _MyAppState() {
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
  }

  @override
  void initState() {
    super.initState();
    // 检查登录
    DataUtils.checkLogin().then((hasLogin) {
      if (hasLogin.runtimeType == UserInfo) {
        setState(() {
          _isLoading = false;
          _hasLogin = true;
          _userInfo = hasLogin;
          if (_userInfo.themeColor != "default") {
            themeColor = int.parse(_userInfo.themeColor);
          }
        });
      }
      else {
        setState(() {
          _isLoading = false;
          _hasLogin = hasLogin;
        });
      }
    }).catchError((onError) {
      setState(() {
        _hasLogin = false;
        _isLoading = false;
      });
      print('身份信息验证失败:$onError');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tool',
      theme: new ThemeData(
        primaryColor: Color(this.themeColor),
        backgroundColor: Color(0xFFEFEFEF),
        accentColor: Color(0xFF888888),
        textTheme: TextTheme(
          // 设置Material的默认字体样式
          body1: TextStyle(color: Color(0xFF888888), fontSize: 16.0),
        ),
        iconTheme: IconThemeData(
          color: Color(this.themeColor),
          size: 35.0,
        ),
      ),
      home: Scaffold(
        body: showWelcomePage(),
      ),
      debugShowCheckedModeBanner: false,
//      onGenerateRoute: Application.router.generator,
//      navigatorObservers: <NavigatorObserver>[Analytics.observer],
    );
  }

  // 显示欢迎页
  showWelcomePage() {
    if (_isLoading) {
      return Container(
        color: Color(this.themeColor),
        child: Center(child: showLoadingPage(),),
      );
    }
    else {
      // 判断是否已经登录
      if (_hasLogin) {
        return AppPage(_userInfo);
      }
      else {
        return LoginPage();
      }
    }
  }

  showLoadingPage() {
    if (Constant.PLATFORM() == WEB) {
      return Text('Loading');
    }
    else {
      return SpinKitPouringHourglass(color: Colors.white);
    }
  }
}
