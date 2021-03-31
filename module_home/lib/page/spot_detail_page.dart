

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/nestedscroll/nested_refresh_indicator.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:library_base/widget/tab/bubble_indicator.dart';
import 'package:module_home/page/spot_brief_page.dart';
import 'package:module_home/page/spot_data_page.dart';
import 'package:module_home/page/spot_quote_page.dart';
import 'package:module_home/viewmodel/spot_detail_model.dart';
import 'package:module_home/widget/spot_detail_appbar.dart';
import 'package:module_home/widget/spot_detail_kline_bar.dart';



class SpotDetailPage extends StatefulWidget {

  final String coinCode;

  SpotDetailPage({
    Key key,
    this.coinCode = 'bitcoin'
  }) : super(key: key);

  @override
  _SpotDetailPageState createState() => _SpotDetailPageState();
}

class _SpotDetailPageState extends State<SpotDetailPage> with WidgetsBindingObserver, BasePageMixin<SpotDetailPage>, SingleTickerProviderStateMixin {

  SpotDetailModel _spotDetailModel;

  List<String> _tabTitles ;
  ShotController _tabBarSC = new ShotController();

  ScrollController _nestedController = ScrollController();
  final _nestedRefreshKey = GlobalKey<NestedRefreshIndicatorState>();

  TabController _tabController;

  ValueNotifier<bool> _topBarExtentNofifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> _scrollExtentNofifier = ValueNotifier<bool>(false);

  double _tabBarHeight = 58.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 4, vsync: this);

    initViewModel();
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void initViewModel() {
    _tabTitles = [S.current.quote, S.current.info, S.current.briefInfo, S.current.data];
    _spotDetailModel = SpotDetailModel(_tabTitles);
    _spotDetailModel.listenEvent();
    _spotDetailModel.getSpotDetail(widget.coinCode);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LogUtil.v('SpotDetailPage: resumed', tag: 'SpotDetailPage');
    } else if (state == AppLifecycleState.paused) {
      LogUtil.v('SpotDetailPage: paused', tag: 'SpotDetailPage');
    } else if (state == AppLifecycleState.inactive) {
      LogUtil.v('SpotDetailPage: inactive', tag: 'SpotDetailPage');
    } else if (state == AppLifecycleState.detached) {
      LogUtil.v('SpotDetailPage: detached', tag: 'SpotDetailPage');
    }
  }

  @override
  Future<void> refresh({slient = false}) {
    _nestedController.animateTo(-0.0001, duration: Duration(milliseconds: 100), curve: Curves.linear);
    _nestedRefreshKey.currentState?.show(atTop: true);

    return _refresh();
  }

  Future<void> _refresh()  {
    return _spotDetailModel.getSpotDetailWithChild(widget.coinCode, _tabController.index);
  }

  void _scrollNotify(double scrollY, double maxExtent) {
    if (scrollY > 50) {
      var opacity = (scrollY - 50) / 50;
      opacity = opacity <= 1 ? opacity : 1;
      bool extent = (opacity > 0.5);
      
      if (extent != _topBarExtentNofifier.value) {
        _topBarExtentNofifier.value = extent;
      }
      
    } else {
      if (_topBarExtentNofifier.value) {
        _topBarExtentNofifier.value = false;
      }
    }

    if (scrollY >= maxExtent) {
      if (!_scrollExtentNofifier.value) {
        _scrollExtentNofifier.value = true;
      }
    } else {
      if (_scrollExtentNofifier.value) {
        _scrollExtentNofifier.value = false;
      }
    }
  }

  Future<void> _share() async {

    _tabController.animateTo(0);

    Future.delayed(new Duration(milliseconds: 100), () async {

      String title = _spotDetailModel.quoteCoin != null ? _spotDetailModel.quoteCoin.pair : '';

      Uint8List tabViewpngBytes = await _spotDetailModel.keyList[0]?.currentState.screenShot();
      Uint8List tabBarPngBytes = await _tabBarSC.makeImageUint8List();
      DialogUtil.showShareDialog(context,
          children: [
            Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                color: Colours.white,
                child: Text(title, style: TextStyles.textBlack16)
            ),
            Container(
              color: Colours.gray_100,
              child: Column(
                children: [
                  SpotDetailShareBar(showShadow: false, quoteCoin: _spotDetailModel.quoteCoin),
                  SpotDetailKLineBar(coinCode: widget.coinCode),
                  Image.memory(tabBarPngBytes),
                  Image.memory(tabViewpngBytes),
                ],
              ),
            ),
            ShareQRFoooter(),
          ]
      );
    });

  }

  @override
  Widget build(BuildContext context) {

    return ProviderWidget<SpotDetailModel>(
        model: _spotDetailModel,
        builder: (context, model, child) {
          return model.isFirst ? Container(color: Colours.gray_100, child: FirstRefresh()) :
          Scaffold(
              backgroundColor: Colours.gray_100,
              appBar: AppBar(
                  leading: BackButtonEx(),
                  elevation: 0,
                  brightness: Brightness.light,
                  backgroundColor: Colours.white,
                  actions: <Widget>[
                    IconButton(
                        icon: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
                        onPressed: _share
                    ),
                  ],
                  centerTitle: true,
                  title: _titleBuilder()
              ),
              body: NestedRefreshIndicator(
                key: _nestedRefreshKey,
                onRefresh: _refresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
                      _scrollNotify(notification.metrics.pixels, notification.metrics.maxScrollExtent);
                    }
                    return false;
                  },
                  child: NestedScrollView(
                      physics: const ClampingScrollPhysics(),
                      headerSliverBuilder: (context, innerBoxIsScrolled) => _headerSliverBuilder(context),
                      body: Column(
                        children: <Widget>[
                          _tabBarBuilder(),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                SpotQuotePage(key: _spotDetailModel.keyList[0], coinCode: widget.coinCode),
                                Routers.generatePage(context, Routers.articleListPage,
                                    parameters: Parameters()
                                      ..putObj('key', _spotDetailModel.keyList[1])
                                      ..putBool('isSupportPull', false)
                                      ..putBool('isSingleCard', true)
                                      ..putString('tag', widget.coinCode)
                                ),
                                SpotBriefPage(key: _spotDetailModel.keyList[2], coinCode: widget.coinCode),
                                SpotDataPage(key: _spotDetailModel.keyList[3], coinCode: widget.coinCode),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ),
              )
          );

        }

    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context) {
    return <Widget>[
      ProviderWidget<SpotKLineHandleModel>(
          model: _spotDetailModel.spotKLineHandleModel,
          builder: (context, model, child) {
            return SliverToBoxAdapter(
              child: SpotDetailAppbar(
                  showShadow: false,
                  quoteCoin: _spotDetailModel.quoteCoin,
                  numberSlideController: _spotDetailModel.quoteSlideController
              ),
            );
          }
      ),

      SliverToBoxAdapter(
        child: SpotDetailKLineBar(coinCode: widget.coinCode),
      )

//      SliverPersistentHeader(
//        pinned: true,
//        delegate: SliverAppBarDelegate(
//          _tabBarBuilder(),
//          _tabBarHeight,
//        ),
//      ),
    ];
  }

  Widget _titleBuilder() {

    return ProviderWidget2(
        model1: _spotDetailModel.spotHeaderModel,
        model2: _topBarExtentNofifier,
        builder: (context, model1, model2, child) {

          String title = _spotDetailModel.quoteCoin != null ? _spotDetailModel.quoteCoin.pair : '';
          double rate = _spotDetailModel.quoteCoin != null ? _spotDetailModel.quoteCoin.change_percent : 0;
          double price = _spotDetailModel.quoteCoin != null ? _spotDetailModel.quoteCoin.quote : 0;
          String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
          String priceStr = NumUtil.getNumByValueDouble(price, 2).toString();

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  child: Text(title, style: TextStyles.textBlack16,
                  )),
              _topBarExtentNofifier.value ? Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(priceStr + '  ' + rateStr,
                    style: rate >= 0 ? TextStyles.textGreen_w400_14 : TextStyles.textRed_w400_14,
                  )
              ) : Gaps.empty
            ],
          );
        }
    );

  }

  Widget _tabBarBuilder() {
    return ProviderWidget<ValueNotifier<bool>>(
        model: _scrollExtentNofifier,
        builder: (context, model, child) {
          return ShotView(
              controller: _tabBarSC,
              child: Container(
                height: _tabBarHeight,
                decoration: BoxDecoration(
                  color: model.value ? Colours.white : Colours.transparent,
                  boxShadow: model.value ? BoxShadows.normalBoxShadow : null,
                ),
                child: Container(
                  height: 40,
                  margin: model.value ? EdgeInsets.all(0) : EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  padding: model.value ? EdgeInsets.symmetric(horizontal: 12, vertical: 9) : EdgeInsets.all(0),
                  decoration: model.value ? BoxDecoration(
                    color: Colours.white,
                  ): BoxDecoration(
                    color: Colours.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: BoxShadows.normalBoxShadow,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colours.gray_800,
                    indicatorColor: Colours.gray_100,
                    unselectedLabelColor: Colours.gray_500,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: new BubbleTabIndicator(
                      insets: const EdgeInsets.symmetric(horizontal: 3),
                      indicatorHeight: 34.0,
                      indicatorRadius: 14,
                      indicatorColor: Colours.gray_100,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    isScrollable: false,
                    tabs: <Tab>[
                      Tab(text: _tabTitles[0]),
                      Tab(text: _tabTitles[1]),
                      Tab(text: _tabTitles[2]),
                      Tab(text: _tabTitles[3]),
                    ],
                  ),
                ),
              )
          );
        }
        );
  }
}


class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;
  SliverAppBarDelegate(this.widget, this.height);

  // minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}