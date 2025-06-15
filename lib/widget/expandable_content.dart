import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/model/video_model.dart';
import 'package:flutter_bilbil_app/util/view_util.dart';

class ExpandableContent extends StatefulWidget {
  final VideoModel videoModel;
  const ExpandableContent({super.key, required this.videoModel});

  @override
  State<ExpandableContent> createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  bool _expand = false;
  //用来管理Animation
  late AnimationController _controller;
  //生成动画高度
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 200));
    _heightFactor = _controller.drive(_easeInTween);
    _controller.addListener(() {
      //监听动画变化
      print(_heightFactor.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        children: [
          _buildTitle(),
          Padding(padding: EdgeInsets.only(bottom: 8)),
          _buildInfo(),
          _buildDes()
        ],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //通过Expand让Text获得最大宽度，以方便显示省略号
          Expanded(
              child: Text(
            widget.videoModel.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          Padding(padding: EdgeInsets.only(left: 15)),
          Icon(
            _expand
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            color: Colors.grey,
            size: 16,
          )
        ],
      ),
    );
  }

  _buildInfo() {
    var style = TextStyle(fontSize: 12, color: Colors.grey);
    var dateStr = widget.videoModel.createTime.length > 10
        ? widget.videoModel.createTime.substring(5, 10)
        : widget.videoModel.createTime;
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.videoModel.view),
        Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconText(Icons.list_alt, widget.videoModel.reply),
        Text(
          '  $dateStr',
          style: style,
        )
      ],
    );
  }

  _buildDes() {
    var child = _expand
        ? Text(widget.videoModel.desc,
            style: TextStyle(fontSize: 12, color: Colors.grey))
        : null;
    //构建动画的通用widget
    return AnimatedBuilder(
        animation: _controller.view,
        child: child,
        builder: (BuildContext context, Widget? child) {
          return Align(
            heightFactor: _heightFactor.value,
            //fix从布局之上的位置开始展开
            alignment: Alignment.topCenter,
            child: Container(
              //撑满宽度后，让内容对其
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 8),
              child: child,
            ),
          );
        });
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        //执行动画
        _controller.forward();
      } else {
        //反向执行动画
        _controller.reverse();
      }
    });
  }
}
