

import 'dart:typed_data';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/tab/bubble_indicator.dart';
import 'package:lighthouse/ui/module_home/page/spot_brief_page.dart';
import 'package:lighthouse/ui/module_home/page/spot_data_page.dart';
import 'package:lighthouse/ui/module_home/page/spot_quote_page.dart';
import 'package:lighthouse/ui/module_home/viewmodel/spot_detail_model.dart';
import 'package:lighthouse/ui/module_home/widget/spot_detail_appbar.dart';
import 'package:lighthouse/ui/module_home/widget/spot_detail_kline_bar.dart';
import 'package:lighthouse/ui/module_info/page/article_list_page.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/num_util.dart';



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

  ScrollController _nestedController = ScrollController();
  final _nestedRefreshKey = GlobalKey<NestedScrollViewRefreshIndicatorState>();

  TabController _tabController;

  ValueNotifier<double> _opacityNofifier = ValueNotifier<double>(0);

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
    _tabTitles = [S.current.briefInfo, S.current.quote, S.current.data, S.current.info];
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

  void _scrollNotify(double scrollY) {
    if (scrollY > 50) {
      var opacity = (scrollY - 50) / 50;
      _opacityNofifier.value = opacity <= 1 ? opacity : 1;
    } else {
      _opacityNofifier.value = 0;
    }
  }

  Future<void> _share() async {

    _tabController.animateTo(0);

    Future.delayed(new Duration(milliseconds: 100), () async {

      Uint8List pngBytes = await _spotDetailModel.keyList[0]?.currentState.screenShot();
      DialogUtil.showShareDialog(context,
          children: [
            Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                color: Colours.white,
                child: Text(widget.coinCode, style: TextStyles.textBlack16)
            ),
            Container(
              color: Colours.gray_100,
              child: Column(
                children: [
                  SpotDetailAppbar(showShadow: false, quoteCoin: _spotDetailModel.quoteCoin),
                  SpotDetailKLineBar(coinCode: widget.coinCode),
                  Image.memory(pngBytes),
                ],
              ),
            ),
          ]
      );
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.gray_100,
      appBar: AppBar(
          leading: BackButtonEx(),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.white,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share, color: Colours.black,),
                onPressed: _share
            ),
          ],
          centerTitle: true,
          title: _titleBuilder()
      ),
      body: ProviderWidget<SpotDetailModel>(
          model: _spotDetailModel,
          builder: (context, model, child) {
            return model.isFirst ? FirstRefresh() : NestedScrollViewRefreshIndicator(
              key: _nestedRefreshKey,
              onRefresh: _refresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification.depth == 0 && notification is ScrollUpdateNotification) {
                    _scrollNotify(notification.metrics.pixels);
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
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
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

                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]),
                                  SpotBriefPage(key: _spotDetailModel.keyList[0], coinCode: widget.coinCode)
                              ),
                              extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]),
                                  SpotQuotePage(key: _spotDetailModel.keyList[1], coinCode: widget.coinCode)
                              ),
                              extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[2]),
                                  SpotDataPage(key: _spotDetailModel.keyList[2], coinCode: widget.coinCode)
                              ),
                              extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[3]),
                                  ArticleListPage(key: _spotDetailModel.keyList[3],
                                    isSupportPull: false,
                                    isSingleCard: true,
                                    tag: widget.coinCode
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ),
              ),
            );
          }
      ),


    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context) {
    return <Widget>[
      SliverToBoxAdapter(
        child: SpotDetailAppbar(quoteCoin: _spotDetailModel.quoteCoin),
      ),
      SliverToBoxAdapter(
        child: SpotDetailKLineBar(coinCode: widget.coinCode),
      ),
    ];
  }

  Widget _titleBuilder() {

    return ProviderWidget<ValueNotifier<double>>(
        model: _opacityNofifier,
        builder: (context, model, child) {

          double rate = _spotDetailModel.quoteCoin != null ? _spotDetailModel.quoteCoin.change_percent : 0;
          double price = _spotDetailModel.quoteCoin != null ? _spotDetailModel.quoteCoin.quote : 0;
          String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
          String priceStr = NumUtil.getNumByValueDouble(price, 2).toString();

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  child: Text(widget.coinCode, style: TextStyles.textBlack16,
                  )),
              _opacityNofifier.value > 0.5 ? Container(
                  child: Text(priceStr + '  ' + rateStr,
                    style: rate >= 0 ? TextStyles.textGreen_w400_14 : TextStyles.textRed_w400_14,
                  )
              ) : Gaps.empty
            ],
          );
        }
    );

  }

}
