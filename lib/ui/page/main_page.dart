
import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/dimens.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/page2nd/home_page.dart';
import 'package:lighthouse/ui/page2nd/info_page.dart';
import 'package:lighthouse/ui/page2nd/mine_page.dart';
import 'package:lighthouse/ui/page2nd/news_page.dart';
import 'package:lighthouse/ui/provider/main_provider.dart';
import 'package:lighthouse/ui/widget/image/local_image.dart';
import 'package:lighthouse/utils/double_tap_back_exit_app.dart';
import 'package:lighthouse/utils/log_util.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with BasePageMixin<MainPage> {

  StreamSubscription _userSubscription;

  static const double _imageSize = 25.0;

  List<GlobalKey<BasePageMixin>> _keyList;
  List<Widget> _pageList;
  List<String> _appBarTitles ;
  final PageController _pageController = PageController();

  MainProvider provider = MainProvider();

  List<BottomNavigationBarItem> _bottomBarItemList;

  @override
  void initState() {
    super.initState();
    initData();

    _userSubscription = Event.eventBus.on<UserEvent>().listen((event) {

      if (event.state == UserEventState.logout) {
        Routers.navigateTo(context, Routers.loginPage);
      }
    });
  }

  @override
  void dispose() {
    if (_userSubscription != null) {
      _userSubscription.cancel();
    }
    _pageController.dispose();
    super.dispose();
    LogUtil.v('_MainPageState dispose' );
  }
  
  void initData() {
    _appBarTitles = [S.current.home, S.current.info, S.current.money, S.current.mine];
    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[1]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[2]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[3]),
    ];
    _pageList = [
      HomePage(key: _keyList[0]),
      InfoPage(key: _keyList[1]),
      NewsPage(key: _keyList[2]),
      MinePage(key: _keyList[3]),
    ];
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItem() {
    if (_bottomBarItemList == null) {
      const _tabImages = [
        [
          LocalImage('tab_home', width: _imageSize, color: Colours.unselected_item_color,),
          LocalImage('tab_home', width: _imageSize, color: Colours.app_main_500,),
        ],
        [
          LocalImage('tab_info', width: _imageSize, color: Colours.unselected_item_color,),
          LocalImage('tab_info', width: _imageSize, color: Colours.app_main_500,),
        ],
        [
          LocalImage('tab_money', width: _imageSize, color: Colours.unselected_item_color,),
          LocalImage('tab_money', width: _imageSize, color: Colours.app_main_500,),
        ],
        [
          LocalImage('tab_mine', width: _imageSize, color: Colours.unselected_item_color,),
          LocalImage('tab_mine', width: _imageSize, color: Colours.app_main_500,),
        ]
      ];
      _bottomBarItemList = List.generate(_tabImages.length, (i) {
        return BottomNavigationBarItem(
          icon: Container(margin: EdgeInsets.only(bottom: 3), child: _tabImages[i][0]),
          activeIcon: Container(margin: EdgeInsets.only(bottom: 3), child: _tabImages[i][1]),
          label: _appBarTitles[i],
        );
      });
    }
    return _bottomBarItemList;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (_) => provider,
      child: DoubleTapBackExitApp(
        child: Scaffold(
          bottomNavigationBar: Consumer<MainProvider>(
            builder: (_, provider, __) {
              return BottomNavigationBar(
                backgroundColor: Colours.white,
                items: _buildBottomNavigationBarItem(),
                type: BottomNavigationBarType.fixed,
                currentIndex: provider.value,
                elevation: 5.0,
                iconSize: 21.0,
                selectedFontSize: Dimens.font_sp10,
                unselectedFontSize: Dimens.font_sp10,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colours.unselected_item_color,
                onTap: (index) {
                  if (provider.value == index) {
                    _keyList[index].currentState?.refresh();
                  } else {
                    _pageController.jumpToPage(index);
                  }
                },
              );
            },
          ),
          // 使用PageView的原因参看 https://zhuanlan.zhihu.com/p/58582876
          body: PageView(
            physics: const NeverScrollableScrollPhysics(), // 禁止滑动
            controller: _pageController,
            onPageChanged: (int index) => provider.value = index,
            children: _pageList,
          )
        ),
      ),
    );
  }

}
