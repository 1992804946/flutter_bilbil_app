import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//带lottie动画的加载进度条组件
class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  //加载动画是否覆盖原有界面
  final bool cover;

  const LoadingContainer(
      {super.key,
      required this.isLoading,
      required this.child,
      this.cover = false});

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: [child, isLoading ? _loadingView : Container()],
      );
    } else {
      return isLoading ? _loadingView : child;
    }
  }

  Widget get _loadingView {
    return Center(
      child: Lottie.asset('assets/loading.json'),
    );
  }
}
