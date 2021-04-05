

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
import 'package:library_base/widget/nestedscroll/nested_scroll_view_inner_scroll_position_key_widget.dart' as extended;
import 'package:library_base/widget/nestedscroll/old_extended_nested_scroll_view.dart' as extended;
import 'package:library_base/widget/shot_view.dart';
import 'package:library_base/widget/tab/round_indicator.dart';
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

class _SpotDetailPageState extends State<SpotDetailPage> with BasePageMixin<SpotDetailPage>, SingleTickerProviderStateMixin {

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

    _tabController = TabController(length: 4, vsync: this);

    initViewModel();
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
  }

  void initViewModel() {
    _tabTitles = [S.current.quote, S.current.info, S.current.briefInfo, S.current.data];
    _spotDetailModel = SpotDetailModel(_tabTitles);
    _spotDetailModel.listenEvent();
    _spotDetailModel.getSpotDetail(widget.coinCode);
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
              color: Colours.white,
              child: Column(
                children: [
                  SpotDetailShareBar(showShadow: false, quoteCoin: _spotDetailModel.quoteCoin),
                  SpotDetailKLineBar(coinCode: widget.coinCode),
                  SpotDetailBottomBar(quoteCoin: _spotDetailModel.quoteCoin),
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
              backgroundColor: Colours.white,
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
                  child: extended.NestedScrollView(
                      physics: const ClampingScrollPhysics(),
                      pinnedHeaderSliverHeightBuilder: () {
                        return 0;
                      },
                      innerScrollPositionKeyBuilder: () {
                        return Key(_tabTitles[_tabController.index]);
                      },
                      headerSliverBuilder: (context, innerBoxIsScrolled) => _headerSliverBuilder(context),
                      body: Column(
                        children: <Widget>[
                          _tabBarBuilder(),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]),
                                    SpotQuotePage(key: _spotDetailModel.keyList[0], coinCode: widget.coinCode)
                                ),
                                extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]),
                                    Routers.generatePage(context, Routers.articleListPage,
                                        parameters: Parameters()
                                          ..putObj('key', _spotDetailModel.keyList[1])
                                          ..putBool('isSupportPull', false)
                                          ..putBool('isSingleCard', false)
                                          ..putString('tag', widget.coinCode)
                                    )
                                ),
                                extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[2]),
                                    SpotBriefPage(key: _spotDetailModel.keyList[2], coinCode: widget.coinCode)
                                ),
                                extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[3]),
                                    SpotDataPage(key: _spotDetailModel.keyList[3], coinCode: widget.coinCode)
                                ),
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
      ),

      SliverToBoxAdapter(
        child: SpotDetailBottomBar(quoteCoin: _spotDetailModel.quoteCoin),
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
        model1: _spotDetailModel.spotAppbarModel,
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
    return ShotView(
        controller: _tabBarSC,
        child: Container(
          alignment: Alignment.centerLeft,
          height: _tabBarHeight,
          child: Container(
            height: 40,
            child: TabBar(
              controller: _tabController,
              labelColor: Colours.text_black,
              labelStyle: TextStyles.textBlack18,
              unselectedLabelColor: Colours.gray_400,
              unselectedLabelStyle: TextStyles.textGray400_w400_14,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: RoundTabIndicator(
                  borderSide: BorderSide(color: Colours.text_black, width: 3),
                  isRound: true,
                  insets: EdgeInsets.only(left: 8, right: 8)),
              isScrollable: true,
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