

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/milestone.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/page2nd/article_list_page.dart';
import 'package:lighthouse/ui/widget/appbar/home_flexible_appbar.dart';
import 'package:lighthouse/ui/widget/appbar/home_milestone_bar.dart';
import 'package:lighthouse/ui/widget/appbar/home_pinned_appbar.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:lighthouse/ui/widget/appbar/home_quote_treemap_bar.dart';


class HomePage extends StatefulWidget {

  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BasePageMixin<HomePage>, AutomaticKeepAliveClientMixin<HomePage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  double _appBarOpacity = 0;
  double _toolbarHeight = 90;

  ScrollController _nestedController = ScrollController();

  final _nestedRefreshKey = GlobalKey<NestedScrollViewRefreshIndicatorState>();
  final _articlePageKey = GlobalKey<BasePageMixin>();

  List<MileStone> _mileStones = [];

  @override
  void initState() {
    super.initState();

    _requestData().then((value) => setState((){}));
  }

  @override
  void dispose() {
    _nestedController.dispose();
    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    _nestedController.animateTo(-0.0001, duration: Duration(milliseconds: 100), curve: Curves.linear);
    _nestedRefreshKey.currentState?.show(atTop: true);

    return _refresh();
  }

  Future<void> _refresh()  {

    return Future.wait<dynamic>([
      _articlePageKey.currentState != null ?
      _articlePageKey.currentState.refresh(slient: true) :
      Future<void>.delayed(const Duration(milliseconds: 100)),

      _requestData()

    ]).then((e){
      setState(() {
      });
    });
  }

  Future<void> _requestData() {
    Map<String, dynamic> params = {
      'sex': 2,
    };

    return DioUtil.getInstance().post(Constant.URL_GET_MILESTONES, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            return;
          }

          List<MileStone> dataList = MileStone.fromJsonList(data['data']) ?? [];
          _mileStones.clear();
          _mileStones.addAll(dataList);
        },
        errorCallBack: (error) {

        });
  }

  void _scrollNotify(double scrollY) {
    if (scrollY > 100) {
      var opacity = (scrollY - 100) / 100;
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
      backgroundColor: Colours.normal_bg,
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
            controller: _nestedController,
            physics: const ClampingScrollPhysics(),
            pinnedHeaderSliverHeightBuilder: () {
              return _toolbarHeight;
            },
            innerScrollPositionKeyBuilder: () {
              return Key('Tab0');
            },
            headerSliverBuilder: (context, innerBoxIsScrolled) => _headerSliverBuilder(context),
            body: extended.NestedScrollViewInnerScrollPositionKeyWidget(
                Key('Tab0'),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 9),
                  decoration: BoxDecoration(
                    color: Colours.white,
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    boxShadow: BoxShadows.normalBoxShadow,
                  ),
                  child: ArticleListPage(key: _articlePageKey, isSupportPull: false),
                )

            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context) {
    return <Widget>[
      SliverAppBar(
          toolbarHeight: _toolbarHeight,
          titleSpacing: 0,
          elevation: 0.0,
          primary: false,
          actions: null,
          automaticallyImplyLeading : false,
          backgroundColor: Colours.normal_bg,
          brightness: _appBarOpacity > 0.5 ? Brightness.light : Brightness.dark,
          title: HomePinnedAppBar(height: _toolbarHeight, appBarOpacity: _appBarOpacity),
          centerTitle: true,
          expandedHeight: 490.0,
          floating: false, // 不随着滑动隐藏标题
          pinned: true, // 固定在顶部
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: HomeFlexibleAppBar(),
          )
      ),
      SliverToBoxAdapter(
        child: HomeQuoteTreemapBar(),
      ),
      SliverToBoxAdapter(
        child: HomeMileStoneBar(mileStones: _mileStones),
      ),
    ];
  }
}
