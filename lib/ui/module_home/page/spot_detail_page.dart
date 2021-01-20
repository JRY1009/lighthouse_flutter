

import 'dart:typed_data';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/quote_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/module_base/page/base_page.dart';
import 'package:lighthouse/ui/module_base/widget/button/back_button.dart';
import 'package:lighthouse/ui/module_base/widget/dialog/dialog_util.dart';
import 'package:lighthouse/ui/module_base/widget/tab/bubble_indicator.dart';
import 'package:lighthouse/ui/module_home/page/spot_brief_info_page.dart';
import 'package:lighthouse/ui/module_home/page/spot_data_page.dart';
import 'package:lighthouse/ui/module_home/page/spot_quote_page.dart';
import 'package:lighthouse/ui/module_home/widget/spot_detail_appbar.dart';
import 'package:lighthouse/ui/module_home/widget/spot_detail_kline_bar.dart';
import 'package:lighthouse/ui/module_info/page/article_list_page.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:lighthouse/utils/log_util.dart';
import 'package:lighthouse/utils/num_util.dart';



class SpotDetailPage extends StatefulWidget {

  final String coin_code;

  SpotDetailPage({
    Key key,
    this.coin_code
  }) : super(key: key);

  @override
  _SpotDetailPageState createState() => _SpotDetailPageState();
}

class _SpotDetailPageState extends State<SpotDetailPage> with WidgetsBindingObserver, BasePageMixin<SpotDetailPage>, SingleTickerProviderStateMixin {

  QuoteBasic _quoteBasic;

  List<GlobalKey<BasePageMixin>> _keyList;
  List<String> _tabTitles ;

  ScrollController _nestedController = ScrollController();
  final _nestedRefreshKey = GlobalKey<NestedScrollViewRefreshIndicatorState>();

  TabController _tabController;

  double _appBarOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener((){
    });

    _tabTitles = [S.current.briefInfo, S.current.quote, S.current.data, S.current.info];

    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[1]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[2]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[3]),
    ];

    _requestData().then((value) => setState((){}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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

    return Future.wait<dynamic>([
      _keyList[_tabController.index]?.currentState.refresh(slient: true),

      _requestData()

    ]).then((e){
      setState(() {
      });
    });
  }

  Future<void> _requestData() {
    Map<String, dynamic> params = {
      'chain': 'bitcoin',
    };

    return DioUtil.getInstance().get(Constant.URL_GET_CHAIN_DETAIL, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            return;
          }

          _quoteBasic = QuoteBasic.fromJson(data['data']);

          setState(() {

          });
        },
        errorCallBack: (error) {

        });
  }

  void _scrollNotify(double scrollY) {
    if (scrollY > 50) {
      var opacity = (scrollY - 50) / 50;
      setState(() {
        _appBarOpacity = opacity <= 1 ? opacity : 1;
      });
    } else {
      setState(() {
        _appBarOpacity = 0;
      });
    }
  }

  Future<void> _share() async {

    _tabController.animateTo(0);

    Future.delayed(new Duration(milliseconds: 100), () async {

      Uint8List pngBytes = await _keyList[0]?.currentState.screenShot();
      DialogUtil.showShareDialog(context,
          children: [
            Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                color: Colours.white,
                child: Text(widget.coin_code, style: TextStyles.textBlack16)
            ),
            Container(
              color: Colours.gray_100,
              child: Column(
                children: [
                  SpotDetailAppbar(showShadow: false, quoteBasic: _quoteBasic),
                  SpotDetailKLineBar(coin_code: widget.coin_code),
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
      body: NestedScrollViewRefreshIndicator(
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
                        extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]), SpotBriefInfoPage(key: _keyList[0])),
                        extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]), SpotQuotePage(key: _keyList[1])),
                        extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[2]), SpotDataPage(key: _keyList[2])),
                        extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[3]), ArticleListPage(key: _keyList[3], isSupportPull: false, isSingleCard: true,))
                      ],
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context) {
    return <Widget>[
      SliverToBoxAdapter(
        child: SpotDetailAppbar(quoteBasic: _quoteBasic),
      ),
      SliverToBoxAdapter(
        child: SpotDetailKLineBar(coin_code: widget.coin_code),
      ),
    ];
  }

  Widget _titleBuilder() {
    double rate = _quoteBasic != null ? _quoteBasic.change_percent : 0;
    double price = _quoteBasic != null ? _quoteBasic.quote : 0;
    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
    String priceStr = NumUtil.getNumByValueDouble(price, 2).toString();

    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            child: Text(widget.coin_code, style: TextStyles.textBlack16,
            )),
        _appBarOpacity > 0.5 ? Container(
            child: Text(priceStr + '  ' + rateStr,
              style: rate >= 0 ? TextStyles.textGreen_w400_14 : TextStyles.textRed_w400_14,
            )
        ) : Gaps.empty
      ],
    );
  }

}
