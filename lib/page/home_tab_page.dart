import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/http/core/error.dart';
import 'package:flutter_bilbil_app/http/dao/home_dao.dart';
import 'package:flutter_bilbil_app/model/home_mo.dart';
import 'package:flutter_bilbil_app/util/toast.dart';
import 'package:flutter_bilbil_app/widget/hi_banner.dart';
import 'package:flutter_bilbil_app/util/color.dart';
import 'package:flutter_bilbil_app/widget/video_card.dart';
import 'package:flutter_nested/flutter_nested.dart';
import '../model/video_model.dart';
import '../navigator/hi_navigator.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;
  const HomeTabPage({super.key, this.bannerList, required this.categoryName});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  bool _loading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print('dia$dis');
      //当距离底部不足300时加载更多
      if (dis < 300 && !_loading) {
        print("-----_loadData-----");
        _loadData();
      }
    });
    //首次加载
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: _loadData,
      color: primary,
      //MediaQuery.removePadding去除使用listView造成的顶部空行
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: HiNestedScrollView(
              itemCount: videoList.length,
              controller: _scrollController,
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              headers: [
                if (widget.bannerList != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: _banner(),
                  )
              ],
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.82),
              itemBuilder: (BuildContext context, int index) {
                return VideoCard(videoModel: videoList[index]);
              })),
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: HiBanner(widget.bannerList!),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('loading:currentIndex$currentIndex');
    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            //合成一个新数组
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }
}


/* child: Column(children: [
        Text(widget.name),
        MaterialButton(
          onPressed: () => {
            HiNavigator.getInstance()
                .onJumpTo(RouteStatus.detail, args: {'videoMo': VideoModel(1)})
          },
          child: Text('跳转到详情页'),
        )
      ]), */
    