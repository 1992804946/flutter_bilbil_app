import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/navigator/hi_navigator.dart';
import 'package:flutter_bilbil_app/page/favorite_page.dart';
import 'package:flutter_bilbil_app/page/home_page.dart';
import 'package:flutter_bilbil_app/page/profile_page.dart';
import 'package:flutter_bilbil_app/util/color.dart';
import 'package:flutter_bilbil_app/page/ranking_page.dart';

//底部导航栏
class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defautColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  static int initialPage = 0;
  final PageController _controller = PageController(initialPage: initialPage);
  late List<Widget> _pages;
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(
        onJumpTo: (index) => _onJumpTo(index, pageChage: false),
      ),
      RankingPage(),
      FavoritePage(),
      ProfilePage()
    ];
    if (!_hasBuild) {
      //页面第一次打开时通知打开的是哪个tab
      HiNavigator.getInstance().onBottomTabChanged(
        _pages[initialPage],
        initialPage,
      );
      _hasBuild = true;
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (index) => _onJumpTo(index, pageChage: true),
        physics: NeverScrollableScrollPhysics(), //禁止滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        //设置底部导航栏的图标和文字一起显示
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.person, 3),
        ],
      ),
    );
  }

  void _onJumpTo(int index, {pageChage = false}) {
    if (!pageChage) {
      //让Pageview展示对应的tab
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChanged(_pages[index], index);
    }
    setState(() {
      //控制选中第一个tab
      _currentIndex = index;
    });
  }

  _bottomItem(String s, IconData icon, int i) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defautColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activeColor,
      ),
      label: s,
    );
  }
}
