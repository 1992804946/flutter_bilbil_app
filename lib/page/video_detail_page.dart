import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/util/view_util.dart';
import 'package:flutter_bilbil_app/widget/appBar.dart';
import 'package:flutter_bilbil_app/widget/navigation_bar.dart';
import 'package:flutter_bilbil_app/widget/video_view.dart';
import '../model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const VideoDetailPage(this.videoModel);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    //黑色状态栏,仅限安卓
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
            removeTop: Platform.isIOS,
            context: context,
            child: Column(
              children: [
                //ios黑色状态栏
                NavigationBarPlus(
                  color: Colors.black,
                  statusStyle: StatusStyle.LIGHT_CONTENT,
                  height: Platform.isAndroid ? 0 : 46,
                ),
                _videoView(),
              ],
            )));
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
    );
  }
}
