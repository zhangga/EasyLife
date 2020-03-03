import 'package:flutter/material.dart';

import 'package:EasyApp/utils/provider.dart';


// 启动入口
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  final provider = new Provider();
//  await provider.init(true);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int themeColor = 0xFFC91B3A;

  _MyAppState() {

  }

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'titles',
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
        appBar: AppBar(title: Text('welcome to flutter'),),
        body: Center(child: Text('hello world'),),
      ),
      debugShowCheckedModeBanner: false,
//      onGenerateRoute: Application.router.generator,
//      navigatorObservers: <NavigatorObserver>[Analytics.observer],
    );
  }
}
