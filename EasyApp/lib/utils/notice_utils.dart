import './constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Created by U-Demon
/// Date: 2020/3/7
class NoticeUtils {

  // Toast
  static showToast(BuildContext context, String msg) {
    if (Constant.PLATFORM() == Windows) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: Text(msg)));
    }
    else {
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

}
