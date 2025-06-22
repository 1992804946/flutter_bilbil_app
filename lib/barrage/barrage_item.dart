import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/barrage/barrage_transition.dart';

class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;

  BarrageItem(
      {super.key,
      required this.id,
      required this.top,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000),
      required this.child});

//fix动画状态错乱
  var _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: top,
        child: BarrageTransition(
          duration: duration,
          onComplete: (v) {
            onComplete(id);
          },
          child: child,
          key: _key,
        ));
  }
}
