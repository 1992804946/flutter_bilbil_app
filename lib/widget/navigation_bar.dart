import 'package:flutter/material.dart';
import '../util/view_util.dart';

///自定义样式的沉浸式导航栏
class NavigationBarPlus extends StatelessWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const NavigationBarPlus(
      {super.key,
      this.statusStyle = StatusStyle.DARK_CONTENT,
      this.color = Colors.white,
      this.height = 46,
      this.child});
  @override
  Widget build(BuildContext context) {
    _statusBarInit();
    //状态栏高度
    //top是有刘海屏手机的刘海屏高度
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      child: child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
    );
  }

  void _statusBarInit() {
    //沉浸式状态栏样式
    changeStatusBar(color: color, statusStyle: statusStyle);
  }
}
