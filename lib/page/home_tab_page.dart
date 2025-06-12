import 'package:flutter/material.dart';
import '../model/video_model.dart';
import '../navigator/hi_navigator.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  const HomeTabPage({super.key, required this.name});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(widget.name),
        MaterialButton(
          onPressed: () => {
            HiNavigator.getInstance()
                .onJumpTo(RouteStatus.detail, args: {'videoMo': VideoModel(1)})
          },
          child: Text('跳转到详情页'),
        )
      ]),
    );
  }
}
