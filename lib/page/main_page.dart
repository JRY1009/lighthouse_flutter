import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/widget/double_tap_back_exit_app.dart';
import 'package:library_base/net/websocket_util.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/dimens.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/image/frame_animation_image.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:lighthouse/viewmodel/main_model.dart';
import 'package:uni_links/uni_links.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver, BasePageMixin<MainPage> {

  String? _latestLink = 'Unknown';
  Uri? _latestUri;
  StreamSubscription? _sub;

  static const double _imageSize = 25.0;

  List<GlobalKey<BasePageMixin>>? _keyList;
  late List<String> _appBarTitles;
  late List<Widget> _pageList;
  List<BottomNavigationBarItem>? _bottomBarItemList;

  late MainModel _mainModel;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    initView();
    initViewModel();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        initUniLinks();
      }
    });
  }

  Future<void> initUniLinks() async {
    if (!DeviceUtil.isMobile) {
      return;
    }

    try {
      _latestLink = await getInitialLink();
      LogUtil.v('initial link: $_latestLink');

      if (!ObjectUtil.isEmpty(_latestLink)) {
        _latestUri = Uri.parse(_latestLink!);
      }

      if (!mounted) return;

      _parseParams();

    } on PlatformException {
      LogUtil.e('Failed to get initial link.');
    }

    _sub = getLinksStream().listen((String? link) {
      _latestLink = link;
      LogUtil.v('got link: $link');

      if (!ObjectUtil.isEmpty(link)) {
        _latestUri = Uri.parse(link!);
      }

      if (!mounted) return;

      _parseParams();

    }, onError: (err) {
      LogUtil.e('got err: $err');
    });

  }

  void _parseParams() {
    LogUtil.v('queryParams: $_latestUri');

    final queryParams = _latestUri?.queryParametersAll.entries.toList();
    String? pageType;
    String? articleId;
    LogUtil.v('queryParams: $queryParams');
    if (queryParams != null) {
      for (var param in queryParams) {
        if (param.key == 'page') {
          pageType = param.value.length > 0 ? param.value[0] : null;
        } else if (param.key == 'article_id') {
          articleId = param.value.length > 0 ? param.value[0] : null;
        }
      }
    }

    if (pageType == 'article') {

      Parameters params = Parameters()
        ..putInt('article_id', num.parse(articleId!) as int);

      Routers.navigateTo(context, Routers.articleRequestPage, parameters: params);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LogUtil.v('应用进入前台 resumed');
      WebSocketUtil.instance()!.openSocket();
    } else if (state == AppLifecycleState.paused) {
      LogUtil.v('应用进入后台 paused');
      WebSocketUtil.instance()!.closeSocket();
    } else if (state == AppLifecycleState.inactive) {
      LogUtil.v('应用进入非活动状态 inactive');
    } else if (state == AppLifecycleState.detached) {
      LogUtil.v('应用进入 detached 状态 detached');
    }
  }

  @override
  void dispose() {
    if (_sub != null) _sub!.cancel();
    _pageController.dispose();
    imageCache!.clear();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void initView() {
    //_appBarTitles = [S.current.home, S.current.info, S.current.mine];
    _appBarTitles = [S.current.home, S.current.info, S.current.quote, S.current.mine];
    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[1]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[2]),
      GlobalKey<BasePageMixin>(debugLabel: _appBarTitles[3]),
    ];
    _pageList = [
      Routers.generatePage(context, Routers.homePage, parameters: Parameters()..putObj('key', _keyList![0]))!,
      Routers.generatePage(context, Routers.infoPage, parameters: Parameters()..putObj('key', _keyList![1]))!,
      Routers.generatePage(context, Routers.quotePage, parameters: Parameters()..putObj('key', _keyList![2]))!,
      Routers.generatePage(context, Routers.minePage, parameters: Parameters()..putObj('key', _keyList![3]))!
    ];
  }

  void initViewModel() {

    if (Constant.isReleaseMode)
      WebSocketUtil.initWS();

    _mainModel = MainModel();
    _mainModel.listenEvent(context, _pageController, _keyList);
    _mainModel.initBugly();
  }

  List<BottomNavigationBarItem>? _buildBottomNavigationBarItem() {
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
        [LocalImage('tab_quote', gaplessPlayback: true, width: _imageSize, color: Colours.unselected_item_color), LocalImage('tab_quote', gaplessPlayback: true, width: _imageSize, color: Colours.app_main)],
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
    precacheImage(AssetImage('assets/images/tab_money.png'), context);
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
                    items: _buildBottomNavigationBarItem()!,
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
                        _keyList![index].currentState?.refresh();
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
