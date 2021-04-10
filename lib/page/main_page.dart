import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/widget/double_tap_back_exit_app.dart';
import 'package:library_base/net/websocket_util.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/dimens.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/image/frame_animation_image.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:lighthouse/viewmodel/main_model.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver, BasePageMixin<MainPage> {

  static const double _imageSize = 25.0;

  List<GlobalKey<BasePageMixin>> _keyList;
  List<String> _appBarTitles;
  List<Widget> _pageList;
  List<BottomNavigationBarItem> _bottomBarItemList;

  MainModel _mainModel;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    initView();
    initViewModel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LogUtil.v('应用进入前台 resumed');
      WebSocketUtil.instance().openSocket();
    } else if (state == AppLifecycleState.paused) {
      LogUtil.v('应用进入后台 paused');
      WebSocketUtil.instance().closeSocket();
    } else if (state == AppLifecycleState.inactive) {
      LogUtil.v('应用进入非活动状态 inactive');
    } else if (state == AppLifecycleState.detached) {
      LogUtil.v('应用进入 detached 状态 detached');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    imageCache.clear();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initView() {
    _appBarTitles = [S.current.home, S.current.info, S.current.mine];
    //_appBarTitles = [S.current.home, S.current.info, S.current.money, S.current.mine];
    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[1]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[2]),
      //GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[3]),
    ];
    _pageList = [
      Routers.generatePage(context, Routers.homePage, parameters: Parameters()..putObj('key', _keyList[0])),
      Routers.generatePage(context, Routers.infoPage, parameters: Parameters()..putObj('key', _keyList[1])),
      //Routers.generatePage(context, Routers.moneyPage, parameters: Parameters()..putObj('key', _keyList[2])),
      Routers.generatePage(context, Routers.minePage, parameters: Parameters()..putObj('key', _keyList[2]))
    ];
  }

  void initViewModel() {

    if (Constant.isReleaseMode)
      WebSocketUtil.initWS();

    _mainModel = MainModel();
    _mainModel.listenEvent(context, _pageController, _keyList);
    _mainModel.initBugly();
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
        //[LocalImage('tab_money', gaplessPlayback: true, width: _imageSize, color: Colours.unselected_item_color), LocalImage('tab_money', gaplessPlayback: true, width: _imageSize, color: Colours.app_main)],
        [LocalImage('tab_mine', gaplessPlayback: true, width: _imageSize, color: Colours.unselected_item_color), FrameAnimationImage(animine, width: _imageSize, height: _imageSize)]
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

    precacheImage(AssetImage('assets/images/tab_home.png'), context);
    precacheImage(AssetImage('assets/images/tab_info.png'), context);
    //precacheImage(AssetImage('assets/images/tab_money.png'), context);
    precacheImage(AssetImage('assets/images/tab_mine.png'), context);

    return ProviderWidget<MainModel>(
      model: _mainModel,
      builder: (context, model, child) {
        return DoubleTapBackExitApp(
          child: Scaffold(
              bottomNavigationBar: Theme(
                  data: ThemeData(
                      brightness: Brightness.light,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colours.white,
                    items: _buildBottomNavigationBarItem(),
                    type: BottomNavigationBarType.fixed,
                    currentIndex: model.value,
                    elevation: 5.0,
                    iconSize: 21.0,
                    selectedFontSize: Dimens.font_sp10,
                    unselectedFontSize: Dimens.font_sp10,
                    selectedItemColor: Theme.of(context).primaryColor,
                    unselectedItemColor: Colours.unselected_item_color,
                    onTap: (index) {
                      if (model.value == index) {
                        _keyList[index].currentState?.refresh();
                      } else {
                        _pageController.jumpToPage(index);
                      }
                    },
                  )
              ),

              // 使用PageView的原因参看 https://zhuanlan.zhihu.com/p/58582876
              body: PageView(
                physics: const NeverScrollableScrollPhysics(), // 禁止滑动
                controller: _pageController,
                onPageChanged: (int index) => _mainModel.value = index,
                children: _pageList,
              )
          ),
        );
      },
    );
  }

}
