import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'home_tab_page.dart';
import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//AutomaticKeepAliveClientMixin 的主要作用是保持页面状态，防止页面在切换时重新构建
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  late TabController _controller;
  var tabs = ["推荐", "热门", "追番", "搞笑", "日常", "综合", "游戏", "短片·手书·配音"];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    HiNavigator.getInstance().addListener(listener = (current, pre) {
      // 监听路由跳转
      print('home_page: current: ${current.page}');
      print('home_page: pre: ${pre?.page}');
      if (widget == current || current.page is HomePage) {
        print('打开了首页:onResume');
      } else if (widget == pre || pre?.page is HomePage) {
        print('首页:onPause');
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(listener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
            child: TabBarView(
              controller: _controller,
              children: tabs.map((tab) => HomeTabPage(name: tab)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      labelColor: Colors.black,
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round,
        borderSide: BorderSide(color: primary, width: 3),
        insets: EdgeInsets.only(left: 15, right: 15),
      ),
      tabs: tabs.map<Tab>((tab) {
        return Tab(
          child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                tab,
                style: TextStyle(fontSize: 16),
              )),
        );
      }).toList(),
    );
  }
}
