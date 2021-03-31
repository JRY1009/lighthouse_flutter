

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/nestedscroll/nested_refresh_indicator.dart';
import 'package:module_home/viewmodel/home_model.dart';
import 'package:module_home/widget/home_flexible_appbar.dart';
import 'package:module_home/widget/home_milestone_bar.dart';
import 'package:module_home/widget/home_pinned_appbar.dart';
import 'package:module_home/widget/home_quote_treemap_bar.dart';


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

  double _toolbarHeight = 90;

  HomeModel _homeModel;
  ValueNotifier<double> _opacityNofifier = ValueNotifier<double>(0);

  ScrollController _nestedController = ScrollController();
  final _nestedRefreshKey = GlobalKey<NestedRefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    initViewModel();
  }

  @override
  void dispose() {
    _nestedController.dispose();
    super.dispose();
  }

  void initViewModel() {
    _homeModel = HomeModel();
    _homeModel.getHomeAll();
    _homeModel.listenEvent();
  }

  @override
  Future<void> refresh({slient = false}) {
    _nestedController.animateTo(-0.0001, duration: Duration(milliseconds: 100), curve: Curves.linear);
    _nestedRefreshKey.currentState?.show(atTop: true);

    return _homeModel.getHomeAllWithChild();
  }

  void _scrollNotify(double scrollY) {
    if (scrollY > 100) {
      var opacity = (scrollY - 100) / 100;
      _opacityNofifier.value = opacity <= 1 ? opacity : 1;
    } else {
      _opacityNofifier.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colours.white,
        body: ProviderWidget<HomeModel>(
            model: _homeModel,
            builder: (context, model, child) {
              return model.isFirst ? FirstRefresh() : NestedRefreshIndicator(
                key: _nestedRefreshKey,
                onRefresh: model.getHomeAllWithChild,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
                      _scrollNotify(notification.metrics.pixels);
                    }
                    return false;
                  },
                  child: NestedScrollView(
                    controller: _nestedController,
                    physics: const ClampingScrollPhysics(),
                    headerSliverBuilder: (context, innerBoxIsScrolled) => _headerSliverBuilder(context),
                    body: Routers.generatePage(context, Routers.articleListPage,
                          parameters: Parameters()
                            ..putObj('key', model.articlePageKey)
                            ..putBool('isSupportPull', false)
                            ..putBool('isSingleCard', true))
                  ),
                ),
              );
            }
        )
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context) {
    return <Widget>[
      ProviderWidget<ValueNotifier<double>>(
          model: _opacityNofifier,
          builder: (context, model, child) {

            return SliverAppBar(
                toolbarHeight: _toolbarHeight,
                titleSpacing: 0,
                elevation: 0.0,
                primary: false,
                actions: null,
                automaticallyImplyLeading : false,
                backgroundColor: Colours.white,
                brightness: _opacityNofifier.value > 0.5 ? Brightness.light : Brightness.dark,
                title: HomePinnedAppBar(height: _toolbarHeight, appBarOpacity: _opacityNofifier.value),
                centerTitle: true,
                expandedHeight: 495.0,
                floating: false, // 不随着滑动隐藏标题
                pinned: true, // 固定在顶部
                flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    statusBarIconBrightness: _opacityNofifier.value <= 0.5 ? Brightness.light : Brightness.dark,
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: Colors.white,
                  ),
                  child: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: HomeFlexibleAppBar(),
                  ),
                )

            );
          }
      ),

      SliverToBoxAdapter(
        child: HomeQuoteTreemapBar(),
      ),
      SliverToBoxAdapter(
        child: HomeMileStoneBar(key: _homeModel.milestonePageKey),
      ),
    ];
  }
}