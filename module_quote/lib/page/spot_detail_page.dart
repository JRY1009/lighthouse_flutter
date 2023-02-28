

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/orientation_helper.dart';
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
import 'package:module_quote/viewmodel/spot_depth_model.dart';
import 'package:module_quote/viewmodel/spot_detail_model.dart';
import 'package:module_quote/widget/spot_depth_bar.dart';
import 'package:module_quote/widget/spot_detail_appbar.dart';
import 'package:module_quote/widget/spot_kline_bar.dart';


class SpotDetailPage extends StatefulWidget {

  final String? coinCode;

  SpotDetailPage({
    Key? key,
    this.coinCode = 'bitcoin'
  }) : super(key: key);

  @override
  _SpotDetailPageState createState() => _SpotDetailPageState();
}

class _SpotDetailPageState extends State<SpotDetailPage> with BasePageMixin<SpotDetailPage>, SingleTickerProviderStateMixin {

  late SpotDetailModel _spotDetailModel;
  late SpotDepthModel _spotDepthModel;

  late List<String> _tabTitles ;
  ShotController _tabBarSC = new ShotController();

  ScrollController _nestedController = ScrollController();
  final _nestedRefreshKey = GlobalKey<NestedRefreshIndicatorState>();

  late TabController _tabController;

  ValueNotifier<bool> _topBarExtentNofifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> _scrollExtentNofifier = ValueNotifier<bool>(false);

  double _toolbarHeight = 90.0;
  double _tabBarHeight = 40.0;

  @override
  void initState() {
    super.initState();

    OrientationHelper.setPreferredOrientations([DeviceOrientation.portraitUp]);
    OrientationHelper.forceOrientation(DeviceOrientation.portraitUp);

    _tabController = TabController(length: 2, vsync: this);

    initViewModel();
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
  }

  void initViewModel() {
    _tabTitles = [S.current.proDepthOrder, S.current.proLaststDeal];
    _spotDetailModel = SpotDetailModel(_tabTitles);
    _spotDetailModel.listenEvent();
    _spotDetailModel.getSpotDetail(widget.coinCode ?? '');

    _spotDepthModel = SpotDepthModel();
    _spotDepthModel.getDepth('');
  }

  @override
  Future<void> refresh({slient = false}) {
    _nestedController.animateTo(-0.0001, duration: Duration(milliseconds: 100), curve: Curves.linear);
    _nestedRefreshKey.currentState?.show(atTop: true);

    return _refresh();
  }

  Future<void> _refresh()  {
    return _spotDetailModel.getSpotDetailWithChild(widget.coinCode ?? '', _tabController.index);
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

      String title =  _spotDetailModel.quoteCoin?.pair ?? '';

      Uint8List tabViewpngBytes = await _spotDetailModel.keyList[0].currentState!.screenShot()!;
      Uint8List tabBarPngBytes = await _tabBarSC.makeImageUint8List();
      DialogUtil.showShareDialog(context,
          children: [
            ShareQRHeader(),
            Container(
              color: Colours.white,
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  SpotDetailShareBar(showShadow: false, quoteCoin: _spotDetailModel.quoteCoin),
                  SpotKlineBar(coinCode: widget.coinCode ?? '', horizontal: false),
                  Image.memory(tabBarPngBytes),
                  Image.memory(tabViewpngBytes),
                ],
              ),
            ),
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
                systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
                backgroundColor: Colours.white,
                actions: <Widget>[
                  IconButton(
                      icon: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
                      onPressed: _share
                  ),
                ],
                centerTitle: true,
                //title: _titleBuilder()
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
                        return _toolbarHeight + _tabBarHeight;
                      },
                      innerScrollPositionKeyBuilder: () {
                        return Key(_tabTitles[_tabController.index]);
                      },
                      headerSliverBuilder: (context, innerBoxIsScrolled) => _headerSliverBuilder(context),
                      body: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]),
                            Routers.generatePage(context, Routers.spotDepthOrderPage,
                                parameters: Parameters()
                                  ..putObj('key', _spotDetailModel.keyList[0])
                            )!
                          ),
                          extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]),
                              Routers.generatePage(context, Routers.spotLatestDealPage,
                                  parameters: Parameters()
                                    ..putObj('key', _spotDetailModel.keyList[1])
                              )!
                          ),
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
            return SliverAppBar(
              toolbarHeight: _toolbarHeight,
              titleSpacing: 0,
              elevation: 0.0,
              primary: false,
              actions: null,
              automaticallyImplyLeading : false,
              backgroundColor: Colours.white,
              title: SpotDetailAppbar(
                  showShadow: false,
                  quoteCoin: _spotDetailModel.quoteCoin,
                  numberSlideController: _spotDetailModel.quoteSlideController
              ),
              centerTitle: true,
              expandedHeight: 0,
              floating: true, // 不随着滑动隐藏标题
              pinned: true, // 固定在顶部
            );
          }
      ),

      SliverToBoxAdapter(
        child: SpotKlineBar(coinCode: widget.coinCode ?? '', horizontal: false),
      ),

      ProviderWidget<SpotDepthModel>(
          model: _spotDepthModel,
          builder: (context, model, child) {
            return SliverToBoxAdapter(
              child: SpotDepthBar(bids: _spotDepthModel.bidsList ?? [], asks: _spotDepthModel.asksList ?? []),
            );
          }
      ),

      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          _tabBarBuilder(),
          _tabBarHeight,
        ),
      ),
    ];
  }

  Widget _tabBarBuilder() {
    return ShotView(
        controller: _tabBarSC,
        child: Container(
          alignment: Alignment.centerLeft,
          height: _tabBarHeight,
          child: Container(
            height: _tabBarHeight,
            child: TabBar(
              controller: _tabController,
              labelColor: Colours.app_main_500,
              labelStyle: TextStyles.textMain500_13,
              unselectedLabelColor: Colours.gray_400,
              unselectedLabelStyle: TextStyles.textGray400_w400_13,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: RoundTabIndicator(
                  borderSide: BorderSide(color: Colours.app_main, width: 2),
                  isRound: true,
                  insets: EdgeInsets.only(left: 8, right: 8)),
              isScrollable: true,
              tabs: <Tab>[
                Tab(text: _tabTitles[0]),
                Tab(text: _tabTitles[1]),
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