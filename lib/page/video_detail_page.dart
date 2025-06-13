import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/widget/video_view.dart';
import '../model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const VideoDetailPage(this.videoModel);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text('商品详情页,vid${widget.videoModel.vid}'),
            Text('商品详情页,title${widget.videoModel.title}'),
            _videoView()
          ],
        ));
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(model.url!, cover: model.cover);
  }
}
