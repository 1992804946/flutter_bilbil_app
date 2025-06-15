import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/model/video_detail_mo.dart';
import 'package:flutter_bilbil_app/model/video_model.dart';
import 'package:flutter_bilbil_app/util/format_util.dart';
import 'package:flutter_bilbil_app/util/view_util.dart';

class VideoToolBar extends StatelessWidget {
  final VideoDetailMo? detailMo;
  final VideoModel videoModel;
  final VoidCallback? onLike;
  final VoidCallback? onUnLike;
  final VoidCallback? onCoin;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const VideoToolBar(
      {super.key,
      this.detailMo,
      required this.videoModel,
      this.onLike,
      this.onUnLike,
      this.onCoin,
      this.onFavorite,
      this.onShare});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(border: borderLine(context)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconText(Icons.thumb_up_alt_rounded, videoModel.like,
                  OnClick: onLike, tint: detailMo?.isLike ?? false),
              _buildIconText(Icons.thumb_down_alt_rounded, '不喜欢',
                  OnClick: onUnLike),
              _buildIconText(Icons.monetization_on, videoModel.coin,
                  OnClick: onCoin),
              _buildIconText(Icons.grade_rounded, videoModel.favorite,
                  OnClick: onFavorite, tint: detailMo?.isFavorite ?? false),
              _buildIconText(Icons.share_rounded, videoModel.share,
                  OnClick: onShare),
            ],
          ),
        ));
  }

  _buildIconText(IconData iconData, text, {OnClick, bool tint = false}) {
    if (text is int) {
      //显示格式化
      text = countFormat(text);
    } else if (text == null) {
      text = '';
    }
    tint = tint == null ? false : tint;
    return InkWell(
      onTap: OnClick,
      child: Column(
        children: [
          Icon(
            iconData,
            color: tint ? _getTintColor(iconData) : Colors.grey,
            size: 20,
          ),
          hiSpace(height: 5),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Color _getTintColor(IconData iconData) {
    if (iconData == Icons.thumb_up_alt_rounded) {
      return Colors.red; // 点赞变红
    } else if (iconData == Icons.grade_rounded) {
      return Colors.orange; // 收藏变橙/黄
    } else if (iconData == Icons.monetization_on) {
      return Colors.amber; // 投币变金黄
    } else {
      return Colors.grey; // 默认颜色
    }
  }
}
