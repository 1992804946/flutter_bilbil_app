import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/util/view_util.dart';
import 'package:flutter_bilbil_app/widget/appBar.dart';
import 'package:flutter_bilbil_app/widget/hi_tab.dart';
import 'package:flutter_bilbil_app/widget/navigation_bar.dart';
import 'package:flutter_bilbil_app/widget/video_header.dart';
import 'package:flutter_bilbil_app/widget/video_view.dart';
import '../model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const VideoDetailPage(this.videoModel);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论"];
  VideoModel? videoModel;

  @override
  void initState() {
    super.initState();
    //黑色状态栏,仅限安卓
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
  }

  @override
  void dispose() {
    _controller.dispose();
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
                _buildTabNavigation(),
                Flexible(
                    child: TabBarView(
                  controller: _controller,
                  children: [
                    _buildDetailList(),
                    Container(
                      child: Text('敬请期待...'),
                    )
                  ],
                ))
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

  _buildTabNavigation() {
    //使用Material实现阴影效果
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((name) {
        return Tab(
          text: name,
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents()],
    );
  }

  buildContents() {
    return [
      Container(
        child: VideoHeader(
          owner: videoModel!.owner,
        ),
      )
    ];
  }

  buildVideoList() {}
}
