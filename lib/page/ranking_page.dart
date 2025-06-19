import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/http/dao/ranking_dao.dart';
import 'package:flutter_bilbil_app/page/ranking_tab_page.dart';
import 'package:flutter_bilbil_app/util/view_util.dart';
import 'package:flutter_bilbil_app/widget/hi_tab.dart';
import 'package:flutter_bilbil_app/widget/navigation_bar.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with TickerProviderStateMixin {
  static const TARS = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"}
  ];
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: TARS.length, vsync: this);
    RankingDao.get("like");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildNavigationBar(), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar() {
    return NavigationBarPlus(
      child: Container(
        decoration: bottomBoxShadow(),
        alignment: Alignment.center,
        child: _tabBar(),
      ),
    );
  }

  _buildTabView() {
    return Flexible(
      child: TabBarView(
          controller: _controller,
          children: TARS.map((tab) {
            return RankingTabPage(sort: tab['key'] as String);
          }).toList()),
    );
  }

  _tabBar() {
    return HiTab(
      TARS.map<Tab>((tab) {
        return Tab(
          text: tab['name'],
        );
      }).toList(),
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      controller: _controller,
    );
  }
}
