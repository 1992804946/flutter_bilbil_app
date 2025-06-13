import 'package:flutter/material.dart';

abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setSate(fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      print('HiState:页面已销毁,本次setSate不执行:${toString()}');
    }
  }
}
