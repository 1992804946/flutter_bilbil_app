import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/util/string_util.dart';
import 'package:flutter_bilbil_app/widget/login_input.dart';

import '../http/core/error.dart';
import '../http/dao/login_dao.dart';
import '../navigator/hi_navigator.dart';
import '../util/toast.dart';
import '../widget/appBar.dart';
import '../widget/login_button.dart';
import '../widget/login_effect.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onJumpToLogin;
  const RegistrationPage({Key? key, this.onJumpToLogin}) : super(key: key);
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? rePassword;
  String? password;
  String? imoocId;
  String? orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
        child: ListView(
          //自适应键盘弹起防止遮挡输入框
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              "用户名",
              "请输入用户名",
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              "密码",
              "请输入密码",
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              "确认密码",
              "请再次输入密码",
              obscureText: true,
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              "慕课网id",
              "请输入慕课网id",
              onChanged: (text) {
                imoocId = text;
                checkInput();
              },
            ),
            LoginInput(
              "课程订单号",
              "请输入课程订单号后四位",
              keyboardType: TextInputType.number,
              lineStretch: true,
              onChanged: (text) {
                orderId = text;
                checkInput();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton('注册',
                  enable: loginEnable, onPressed: checkParams),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable = true;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result =
          await LoginDao.registration(userName!, password!, imoocId!, orderId!);
      print(result);
      if (result['code'] == 0) {
        print("注册成功");
        showToast("注册成功");
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin!();
        } else {
          print(result['msg']);
          showWarnToast(result['msg']);
        }
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = "两次输入的密码不一致";
    } else if (orderId!.length != 4) {
      tips = "请输入订单号后四位";
    }
    if (tips != null) {
      print(tips);
      return;
    }
    send();
  }
}
