import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bilbil_app/db/hi_cache.dart';
import 'package:flutter_bilbil_app/http/core/error.dart';
import 'package:flutter_bilbil_app/http/core/hi_net.dart';
import 'package:flutter_bilbil_app/http/dao/login_dao.dart';
import 'package:flutter_bilbil_app/navigator/hi_navigator.dart';
import 'package:flutter_bilbil_app/page/login_page.dart';
import 'package:flutter_bilbil_app/page/registration_page.dart';
import 'package:flutter_bilbil_app/util/color.dart';
import 'package:flutter_bilbil_app/util/toast.dart';
import 'model/video_model.dart';
import 'navigator/bottom_navigator.dart';
import 'page/video_detail_page.dart';

void main() {
  runApp(const BilBilApp());
}

class BilBilApp extends StatefulWidget {
  const BilBilApp({super.key});

  @override
  State<BilBilApp> createState() => _BilBilAppState();
}

class _BilBilAppState extends State<BilBilApp> {
  BilBilRouteDelegate _routeDelegate = BilBilRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
      //进行初始化
      future: HiCache.preInit(),
      builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
        //定义route
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(routerDelegate: _routeDelegate)
            : Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );

        return MaterialApp(
          home: widget,
          theme: ThemeData(primarySwatch: white),
        );
      },
    );
  }
}

class BilBilRouteDelegate extends RouterDelegate<BilBilRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BilBilRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  //为Navigator设置一个key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  BilBilRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //实现路由跳转
    HiNavigator.getInstance().registerRouteJump(
      RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
        _routeStatus = routeStatus;
        if (routeStatus == RouteStatus.detail) {
          this.videoModel = args!['videoModel'];
        }
        notifyListeners(); //通知路由更新
      }),
    );
    //设置网络错误拦截器
    HiNet.getInstance().setErrorInterceptor((error) {
      if (error is NeedLogin) {
        //清空失效的登录令牌
        HiCache.getInstance().remove(LoginDao.BOARDING_PASS);
        //跳转到登录页面
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }
    });
  }
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      tempPages = pages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      //跳转首页时将栈中其他页面进行出栈，因为首页不可回退
      tempPages.clear();
      page = pageWarp(BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWarp(VideoDetailPage(videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWarp(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWarp(LoginPage());
    }
    //重新创建一个数组，否则pages因引用没有改变路由不生效
    tempPages = [...tempPages, page];
    //通知路由发生变化
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;
    return WillPopScope(
      onWillPop: () async {
        // 尝试弹出当前路由
        if (navigatorKey.currentState == null) return true;
        bool canPop = await navigatorKey.currentState!.maybePop();
        debugPrint("onWillPop: canPop:$canPop");
        if (!canPop) {
          // 如果没有页面可以返回，直接退出app
          SystemNavigator.pop();
          return false;
        }
        // 已经弹出页面，不需要系统默认操作
        return false;
      },
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          if (route.settings is MaterialPage) {
            // 登录页未登录返回拦截
            if ((route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                showWarnToast("请先登录");
                return false; // 阻止页面出栈
              }
            }
          }
          if (!route.didPop(result)) {
            return false; // 页面没有被pop，返回false
          }
          var temPages = [...pages];
          pages.removeLast();
          // 通知路由发生变化
          HiNavigator.getInstance().notify(pages, temPages);
          return true; // 返回true表示页面被pop
        },
      ),
    );
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;
  @override
  Future<void> setNewRoutePath(BilBilRoutePath path) async {}
}

class BilBilRoutePath {
  final String location;
  BilBilRoutePath.home() : location = '/';
  BilBilRoutePath.detail() : location = '/detail';
}
    
/* void testLogin() async {
    try {
      var result =
          await LoginDao.registration('ljl', '199280', '3302779', '3206');

      ///var result = await LoginDao.login('ljl', '199280');
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    }
  } */