

import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/page2nd/article_page.dart';
import 'package:lighthouse/ui/widget/appbar/spot_detail_appbar.dart';
import 'package:lighthouse/ui/widget/appbar/spot_detail_kline_bar.dart';
import 'package:lighthouse/ui/widget/button/back_button.dart';
import 'package:lighthouse/ui/widget/tab/bubble_indicator.dart';
import 'package:lighthouse/utils/image_util.dart';
import 'package:lighthouse/utils/screen_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;



class SpotDetailPage extends StatefulWidget {

  SpotDetailPage({
    Key key,
  }) : super(key: key);

  @override
  _SpotDetailPageState createState() => _SpotDetailPageState();
}

class _SpotDetailPageState extends State<SpotDetailPage> with BasePageMixin<SpotDetailPage>, AutomaticKeepAliveClientMixin<SpotDetailPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  List<GlobalKey<BasePageMixin>> _keyList;
  List<String> _tabTitles ;

  TabController _tabController;

  double _appBarOpacity = 0;
  double _toolbarHeight = 80;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabTitles = [S.current.x724, S.current.article];

    _keyList = [
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[0]),
      GlobalKey<BasePageMixin>(debugLabel: _tabTitles[1]),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _keyList[_tabController.index]?.currentState.refresh();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colours.gray_100,
      appBar: AppBar(
          leading: BackButtonEx(),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colours.white,
          centerTitle: true,
          title: _titleBuilder()
      ),
      body: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification.depth == 0 && notification is ScrollUpdateNotification) {
                _scrollNotify(notification.metrics.pixels);
              }
              return false;
            },
            child: extended.NestedScrollView(
                physics: const ClampingScrollPhysics(),
                pinnedHeaderSliverHeightBuilder: () {
                  return _toolbarHeight;
                },
                innerScrollPositionKeyBuilder: () {
                  return Key(_tabTitles[_tabController.index]);
                },
                headerSliverBuilder: (context, innerBoxIsScrolled) => _headerSliverBuilder(context),
                body: Column(
                  children: <Widget>[
                    TabBar(
                      controller: _tabController,
                      labelColor: Colours.app_main,
                      indicatorColor: Colours.app_main,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: new BubbleTabIndicator(
                        indicatorHeight: 30.0,
                        indicatorRadius: 10,
                        indicatorColor: Colours.gray_200,
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      ),
                      indicatorWeight: 2.0,
                      isScrollable: false,
                      unselectedLabelColor: Colours.unselected_item_color,
                      tabs: <Tab>[
                        Tab(text: _tabTitles[0]),
                        Tab(text: _tabTitles[1]),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]), ArticlePage(key: _keyList[0], isSupportPull: true)),
                          extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]), ArticlePage(key: _keyList[1], isSupportPull: true)),
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context) {
    return <Widget>[
      SliverToBoxAdapter(
        child: SpotDetailAppbar(),
      ),
      SliverToBoxAdapter(
        child: SpotDetailKLineBar(),
      ),
    ];
  }

  Widget _titleBuilder() {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text('BTC', style: TextStyles.textBlack16,
            )),
        _appBarOpacity > 0.5 ? Container(
            alignment: Alignment.centerLeft,
            child: Text('12342.21 1.23%', style: TextStyles.textGray400_w400_14,
            )
        ) : Gaps.empty
      ],
    );
  }

}
