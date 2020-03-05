import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:EasyApp/event/event_bus.dart';
import 'package:EasyApp/utils/data_utils.dart';
import 'package:EasyApp/model/user_info.dart';
import 'package:EasyApp/model/user_info_cache.dart';
import 'package:EasyApp/utils/constant.dart';
import 'package:EasyApp/views/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Created by U-Demon
/// Date: 2020/3/4
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserInfoControl _userInfoContr = new UserInfoControl();
  TextEditingController _userNameEditingContr = new TextEditingController();
  TextEditingController _passwordEditingContr = new TextEditingController();
  // 利用FocusNode和_focusScopeNode来控制焦点 可以通过FocusNode.of(context)来获取widget树中默认的_focusScopeNode
  FocusNode _usernameFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusScopeNode _focusScopeNode = new FocusScopeNode();

  GlobalKey<FormState> _signInFormKey = new GlobalKey();

  String username = '';
  String password = '';
  bool isLoading = false;
  bool isShowPassWord = false;

  _LoginPageState() {
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
  }

  @override
  void initState() {
    super.initState();
    try {
      _userInfoContr.getLocalUser().then((_userInfo) {
        if (_userInfo != null) {
          setState(() {
            _userNameEditingContr.text = _userInfo.username;
            _passwordEditingContr.text = _userInfo.password;
            username = _userInfo.username;
            password = _userInfo.password;
          });
        }
      });
    } catch (err) {
      print('读取用户本地存储的用户信息出错 $err');
    }

    ApplicationEvent.event.on().listen((event) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/paimaiLogo.png'),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 35.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/gitHub.png', fit: BoxFit.contain, width: 60.0, height: 60.0,),
                          Image.asset('assets/images/arrow.png', fit: BoxFit.contain, width: 40.0, height: 30.0,),
                          Image.asset('assets/images/FlutterGo.png', fit: BoxFit.contain, width: 60.0, height: 60.0,),
                        ],
                      ),
                      buildSignInTextForm(),
                      buildSignInButton(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 创建登录界面的TextForm
  Widget buildSignInTextForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 190,
      //  * Flutter提供了一个Form widget，它可以对输入框进行分组，然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: TextFormField(
                  controller: _userNameEditingContr,
                  // 关联焦点
                  focusNode: _usernameFocusNode,
                  onEditingComplete: () {
                    if (_focusScopeNode == null) {
                      _focusScopeNode = FocusScope.of(context);
                    }
                    _focusScopeNode.requestFocus(_passwordFocusNode);
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.email, color: Colors.black,),
                    hintText: "SVN用户名",
                    border: InputBorder.none
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  // 验证
                  validator: (value) {
                    if (value.isEmpty) return "用户名不可为空";
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: TextFormField(
                  controller: _passwordEditingContr,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock, color: Colors.black,),
                    hintText: "SVN登录密码",
                    border: InputBorder.none,
                    suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye, color: Colors.black,), onPressed: showPassword)
                  ),
                  // 输入密码，需要用******显示
                  obscureText: !isShowPassWord,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "密码不可为空!";
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  }
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
          ],
        )
      ),
    );
  }

  Widget buildSignInButton() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).primaryColor
        ),
        child: Text("登录", style: TextStyle(fontSize: 25, color: Colors.white),),
      ),
      onTap: () {
        // 利用key来获取widget的状态FormState,可以用过FormState对Form的子孙FromField进行统一的操作
        if (_signInFormKey.currentState.validate()) {
          // 调用所有自孩子��save回调，保存表单内容
          doLogin();
        }
      },
    );
  }

  // 登陆操作
  doLogin() {
    _signInFormKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    DataUtils.doLogin(username, password).then((result) {
      setState(() {
        isLoading = false;
      });
      // 登录成功
      if (result.runtimeType == UserInfo) {
        try {
          _userInfoContr.deleteAll().then((delRet) {
            _userInfoContr.insert(result).then((insRet) {
              print('存储成功:$result');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AppPage(result)),
                (route) => route == null
              );
          });
          });
        } catch(err) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AppPage(result)),
            (route) => route == null
          );
        }
      }
      // 登录失败
      else if (result.runtimeType == String) {
        _showToast(result);
      }
    }).catchError((errorMsg) {
      setState(() {
        isLoading = false;
      });
      _showToast(errorMsg.toString());
    });
  }

  _showToast(String msg) {
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

  void showPassword() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }
}
