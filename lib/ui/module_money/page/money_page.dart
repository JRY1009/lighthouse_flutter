

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/tab/bubble_indicator.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:library_base/utils/screen_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;



class MoneyPage extends StatefulWidget {

  MoneyPage({
    Key key,
  }) : super(key: key);

  @override
  _MoneyPageState createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> with BasePageMixin<MoneyPage>, AutomaticKeepAliveClientMixin<MoneyPage>, SingleTickerProviderStateMixin {

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
                          extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[0]), Container(color: Colors.red)),
                          extended.NestedScrollViewInnerScrollPositionKeyWidget(Key(_tabTitles[1]), Container(color: Colors.yellow)),
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
          titleSpacing: 0,
          elevation: 0.0,
          primary: true,
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
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colours.toast_warn,
            ),
            child: Container(
              height: 80.0,
              padding: const EdgeInsets.only(top: 8.0),
            ),
          ), 80.0,
        ),
      ),
    ];
  }

  Widget _titleBuilder() {
    return  Opacity(
      opacity: 1,
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