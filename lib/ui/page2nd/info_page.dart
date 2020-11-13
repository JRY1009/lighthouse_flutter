

import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/page2nd/article_page.dart';
import 'package:lighthouse/ui/page2nd/news_page.dart';
import 'package:lighthouse/utils/image_util.dart';
import 'package:lighthouse/utils/screen_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;



class InfoPage extends StatefulWidget {

  InfoPage({
    Key key,
  }) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with BasePageMixin<InfoPage>, AutomaticKeepAliveClientMixin<InfoPage>, SingleTickerProviderStateMixin {

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
                    indicatorSize: TabBarIndicatorSize.label,
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
      SliverAppBar(
          toolbarHeight: _toolbarHeight,
          titleSpacing: 0,
          elevation: 0.0,
          primary: false,
          actions: null,
          automaticallyImplyLeading : false,
          brightness: _appBarOpacity > 0.5 ? Brightness.light : Brightness.dark,
          backgroundColor: Colours.normal_bg,
          title: _titleBuilder(),
          centerTitle: true,
          expandedHeight: 500.0,
          floating: false, // 不随着滑动隐藏标题
          pinned: true, // 固定在顶部
          flexibleSpace: _flexibleSpeceBuilder()
      ),
    ];
  }

  Widget _titleBuilder() {
    return  Opacity(
      opacity: _appBarOpacity,
      child: Container(
        padding: EdgeInsets.only(top: ScreenUtil.getStatusBarH(context)),
        height: _toolbarHeight,
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: BoxShadows.normalBoxShadow,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: Text('标题', style: TextStyles.textBlack16,
                        )),
                    Gaps.vGap5,
                    Container(
                        margin: EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: Text('副标题', style: TextStyles.textGray400_w400_14,
                        )),
                  ],)
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('标题2', style: TextStyles.textBlack16,)
                    ),
                    Gaps.vGap5,
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('副标题2', style: TextStyles.textGray400_w400_14,)
                    ),
                  ],)
            ),
          ],
        ),
      ),
    );
  }

  Widget _flexibleSpeceBuilder() {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Stack(
        children: <Widget>[
          Container(
              height: 285,
              decoration: BoxDecoration(
                color: Colours.transparent,
                image: DecorationImage(
                  image: AssetImage(ImageUtil.getImgPath('bg_home')),
                  fit: BoxFit.fill,
                ),
              )
          ),
          Container(  //占满
            color: Colours.transparent,
          ),
        ],
      ),
    );
  }
}
