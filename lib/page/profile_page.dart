import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/http/core/error.dart';
import 'package:flutter_bilbil_app/http/dao/profile_dao.dart';
import 'package:flutter_bilbil_app/model/profile_mo.dart';
import 'package:flutter_bilbil_app/util/toast.dart';
import 'package:flutter_bilbil_app/util/view_util.dart';
import 'package:flutter_bilbil_app/widget/hi_blur.dart';
import 'package:flutter_bilbil_app/widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileMo? _profileMo;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[_buildAppBar()];
        },
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('标题$index'),
            );
          },
          itemCount: 20,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      print(result);
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildHead() {
    if (_profileMo == null) return Container();
    return HiFlexibleHeader(
        name: _profileMo!.name,
        face: _profileMo!.face,
        controller: _controller);
  }

  _buildAppBar() {
    return SliverAppBar(
      //扩展高度
      expandedHeight: 160,
      //标题是否固定
      pinned: true,
      //定义股东空间
      flexibleSpace: FlexibleSpaceBar(
          //collapseMode实现视差滚动
          collapseMode: CollapseMode.parallax,
          titlePadding: EdgeInsets.only(left: 0),
          title: _buildHead(),
          background: Stack(
            children: [
              Positioned.fill(
                  child: cachedImage(
                      'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
              Positioned.fill(child: HiBlur(sigma: 20)),
              Positioned(
                  bottom: 0, left: 0, right: 0, child: _buildProfileTab())
            ],
          )),
    );
  }

  _buildProfileTab() {
    if (_profileMo == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏', _profileMo!.favorite),
          _buildIconText('点赞', _profileMo!.like),
          _buildIconText('浏览', _profileMo!.browsing),
          _buildIconText('金币', _profileMo!.coin),
          _buildIconText('粉丝', _profileMo!.fans),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 15, color: Colors.black87)),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
