import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/http/core/error.dart';
import 'package:flutter_bilbil_app/http/dao/profile_dao.dart';
import 'package:flutter_bilbil_app/model/profile_mo.dart';
import 'package:flutter_bilbil_app/util/toast.dart';
import 'package:flutter_bilbil_app/util/view_util.dart';
import 'package:flutter_bilbil_app/widget/hi_blur.dart';

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
          return <Widget>[
            SliverAppBar(
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
                    ],
                  )),
            )
          ];
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

    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: 30, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: cachedImage(_profileMo!.face, width: 46, height: 46),
          ),
          hiSpace(width: 8),
          Text(
            _profileMo!.name,
            style: TextStyle(fontSize: 11, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
