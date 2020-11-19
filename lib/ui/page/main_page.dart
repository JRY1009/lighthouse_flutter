
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/main_jump_event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/dimens.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/page2nd/home_page.dart';
import 'package:lighthouse/ui/page2nd/info_page.dart';
import 'package:lighthouse/ui/page2nd/mine_page.dart';
import 'package:lighthouse/ui/page2nd/money_page.dart';
import 'package:lighthouse/ui/provider/main_provider.dart';
import 'package:lighthouse/ui/widget/image/local_image.dart';
import 'package:lighthouse/utils/device_util.dart';
import 'package:lighthouse/utils/double_tap_back_exit_app.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with BasePageMixin<MainPage> {

  StreamSubscription _userSubscription;
  StreamSubscription _mainJumpSubscription;

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

    FlutterBugly.init(androidAppId: '9e87287cfa', iOSAppId: 'ad8a0b5092');

    initData();

    _userSubscription = Event.eventBus.on<UserEvent>().listen((event) {

      if (event.state == UserEventState.logout) {
        Routers.navigateTo(context, Routers.loginPage);
      }
    });

    _mainJumpSubscription = Event.eventBus.on<MainJumpEvent>().listen((event) {

      if (event.page.value >= 0) {
        _pageController.jumpToPage(event.page.value);
      }
    });
  }

  @override
  void dispose() {
    if (_userSubscription != null) {
      _userSubscription.cancel();
    }
    if (_mainJumpSubscription != null) {
      _mainJumpSubscription.cancel();
    }

    _pageController.dispose();

    super.dispose();
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
      MoneyPage(key: _keyList[2]),
      MinePage(key: _keyList[3]),
    ];

    if (DeviceUtil.isAndroid) {
      FlutterBugly.onCheckUpgrade.listen((_upgradeInfo) {

        FlutterXUpdate.updateByInfo(
            updateEntity: UpdateEntity(
                hasUpdate: true,
                isIgnorable: _upgradeInfo.upgradeType == 1,
                isForce: _upgradeInfo.upgradeType == 2,
                versionCode: _upgradeInfo.versionCode,
                versionName: _upgradeInfo.versionName,
                updateContent: _upgradeInfo.newFeature,
                downloadUrl: _upgradeInfo.apkUrl,
                apkSize: (_upgradeInfo.fileSize / 1024).toInt(),
                apkMd5: _upgradeInfo.apkMd5
            ),
            themeColor: '#FF2872FC',
        );
      });
    }
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItem() {
    if (_bottomBarItemList == null) {
      const _tabImages = [
        [LocalImage('tab_home', width: _imageSize, color: Colours.unselected_item_color), LocalImage('tab_home', width: _imageSize, color: Colours.app_main_500)],
        [LocalImage('tab_info', width: _imageSize, color: Colours.unselected_item_color), LocalImage('tab_info', width: _imageSize, color: Colours.app_main_500)],
        [LocalImage('tab_money', width: _imageSize, color: Colours.unselected_item_color), LocalImage('tab_money', width: _imageSize, color: Colours.app_main_500)],
        [LocalImage('tab_mine', width: _imageSize, color: Colours.unselected_item_color), LocalImage('tab_mine', width: _imageSize, color: Colours.app_main_500)]
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
