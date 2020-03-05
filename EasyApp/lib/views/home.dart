import 'package:flutter/material.dart';
import 'package:EasyApp/model/user_info.dart';

/// Created by U-Demon
/// Date: 2020/3/4
class AppPage extends StatefulWidget {
  final UserInfo userInfo;

  AppPage(this.userInfo);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<AppPage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }

}
