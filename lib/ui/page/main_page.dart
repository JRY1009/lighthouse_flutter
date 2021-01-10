
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/main_jump_event.dart';
import 'package:lighthouse/event/user_event.dart';
import 'package:lighthouse/event/ws_event.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/quote_ws.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/dimens.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/page2nd/home_page.dart';
import 'package:lighthouse/ui/page2nd/info_page.dart';
import 'package:lighthouse/ui/page2nd/mine_page.dart';
import 'package:lighthouse/ui/provider/main_provider.dart';
import 'package:lighthouse/ui/widget/image/frame_animation_image.dart';
import 'package:lighthouse/ui/widget/image/local_image.dart';
import 'package:lighthouse/net/websocket_util.dart';
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

    WebSocketUtil.instance().initWebSocket(onOpen: () {

      Map<String, dynamic> params = {
        'op': 'subscribe',
        'message': 'quote.eth,quote.btc',
      };

      WebSocketUtil.instance().sendMessage(json.encode(params));

    }, onMessage: (data) {

      //print(data);
      Map<String, dynamic> dataMap = json.decode(data);
      if (dataMap != null) {
        QuoteWs quoteWs = QuoteWs.fromJson(dataMap);
        Event.eventBus.fire(WsEvent(quoteWs, WsEventState.quote));
      }

    }, onError: (e) {
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

    imageCache.clear();

    super.dispose();
  }

  void initData() {
    FlutterBugly.init(androidAppId: '9e87287cfa', iOSAppId: 'ad8a0b5092');

    _appBarTitles = [S.current.home, S.current.info, S.current.mine];
    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[1]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[2]),
    ];
    _pageList = [
      HomePage(key: _keyList[0]),
      InfoPage(key: _keyList[1]),
      MinePage(key: _keyList[2]),
    ];

    if (DeviceUtil.isAndroid) {
      FlutterBugly.onCheckUpgrade.listen((_upgradeInfo) {

        FlutterXUpdate.updateByInfo(
            updateEntity: UpdateEntity(
                hasUpdate: true,
                isIgnorable: false,
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
      List<String> anihome = [];
      List<String> aninews = [];
      List<String> animine = [];
      for(int i=0; i<18; i++) {
        anihome.add('assets/images/anihome/anihome${i.toString()}.png');
        aninews.add('assets/images/aninews/aninews${i.toString()}.png');
        animine.add('assets/images/animine/animine${i.toString()}.png');
      }

      List<List<Widget>> _tabImages = [
        [LocalImage('tab_home', gaplessPlayback: true, width: _imageSize, color: Colours.unselected_item_color), FrameAnimationImage(anihome, width: _imageSize, height: _imageSize)],
        [LocalImage('tab_info', gaplessPlayback: true, width: _imageSize, color: Colours.unselected_item_color), FrameAnimationImage(aninews, width: _imageSize, height: _imageSize)],
        [LocalImage('tab_mine', gaplessPlayback: true, width: _imageSize, color: Colours.unselected_item_color), FrameAnimationImage(animine, width: _imageSize, height: _imageSize)]
      ];

      _bottomBarItemList = List.generate(_tabImages.length, (i) {
        return BottomNavigationBarItem(
          backgroundColor: Colours.red,
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

    precacheImage(AssetImage('assets/images/tab_home.png'), context);
    precacheImage(AssetImage('assets/images/tab_info.png'), context);
    precacheImage(AssetImage('assets/images/tab_mine.png'), context);

    return ChangeNotifierProvider<MainProvider>(
      create: (_) => provider,
      child: DoubleTapBackExitApp(
        child: Scaffold(
            bottomNavigationBar: Consumer<MainProvider>(
              builder: (_, provider, __) {
                return Theme(
                    data: ThemeData(
                      brightness: Brightness.light,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent
                    ),
                    child: BottomNavigationBar(
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
                    )
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
