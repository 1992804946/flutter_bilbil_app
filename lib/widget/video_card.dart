import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/model/video_model.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoModel;

  const VideoCard({super.key, required this.videoModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(videoModel.url);
      },
      child: Image.network(videoModel.cover),
    );
  }
}
