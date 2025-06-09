import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/util/color.dart';

///登录输入框
class LoginInput extends StatefulWidget {
  final String? title;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final TextInputType? keyboardType;

  const LoginInput(
    this.title,
    this.hint, {
    Key? key,
    this.onChanged,
    this.focusChanged,
    this.lineStretch = false,
    this.obscureText = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _fousNode = FocusNode();

  @override
  void initState() {
    //是否获取光标监听
    super.initState();
    _fousNode.addListener(() {
      print("Has focus: ${_fousNode.hasFocus}");
      if (widget.focusChanged != null) {
        widget.focusChanged!(_fousNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _fousNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(widget.title ?? "",
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ),
            _input()
          ],
        ),
        //输入框的下划线
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: Divider(
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }

  _input() {
    return Expanded(
      child: TextField(
        focusNode: _fousNode,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        autofocus: !widget.obscureText,
        cursorColor: primary,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        //输入框的样式
        decoration: InputDecoration(
            hintText: widget.hint,
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 20, right: 20),
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
      ),
    );
  }
}
