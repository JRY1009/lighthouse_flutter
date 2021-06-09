


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/model/quote_coin.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/utils/orientation_helper.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/nestedscroll/nested_refresh_indicator.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:module_quote/viewmodel/spot_detail_model.dart';
import 'package:module_quote/widget/spot_detail_happbar.dart';
import 'package:module_quote/widget/spot_kline_hbar.dart';

class SpotDetailHPage extends StatefulWidget {

  final String? coinCode;
  final QuoteCoin? quoteCoin;

  SpotDetailHPage({
    Key? key,
    this.coinCode = 'bitcoin',
    this.quoteCoin
  }) : super(key: key);

  @override
  _SpotDetailHPageState createState() => _SpotDetailHPageState();
}

class _SpotDetailHPageState extends State<SpotDetailHPage> with BasePageMixin<SpotDetailHPage>, SingleTickerProviderStateMixin {

  late SpotDetailModel _spotDetailModel;

  late  List<String> _tabTitles ;
  ShotController _tabBarSC = new ShotController();

  ScrollController _nestedController = ScrollController();
  final _nestedRefreshKey = GlobalKey<NestedRefreshIndicatorState>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    OrientationHelper.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    OrientationHelper.forceOrientation(DeviceOrientation.landscapeRight);

    _tabController = TabController(length: 2, vsync: this);

    initViewModel();
  }

  @override
  void dispose() {

    super.dispose();

    OrientationHelper.setPreferredOrientations([DeviceOrientation.portraitUp]);
    OrientationHelper.forceOrientation(DeviceOrientation.portraitUp);

    _tabController.dispose();
  }

  void initViewModel() {
    _tabTitles = [S.current.proDepthOrder, S.current.proLaststDeal];
    _spotDetailModel = SpotDetailModel(_tabTitles);
    _spotDetailModel.quoteCoin = widget.quoteCoin;
    _spotDetailModel.lastQuoteCoin = widget.quoteCoin;
    _spotDetailModel.listenEvent();
    _spotDetailModel.setSuccess();
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

  @override
  Widget build(BuildContext context) {

    return ProviderWidget<SpotDetailModel>(
        model: _spotDetailModel,
        builder: (context, model, child) {
          return model.isFirst ? Container(color: Colours.gray_100, child: FirstRefresh()) :
          Scaffold(
              backgroundColor: Colours.white,
              appBar: AppBar(
                elevation: 0,
                brightness: Brightness.light,
                backgroundColor: Colours.white,
                automaticallyImplyLeading: false,
                toolbarHeight: 1,
              ),
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    ProviderWidget<SpotKLineHandleModel>(
                        model: _spotDetailModel.spotKLineHandleModel,
                        builder: (context, model, child) {
                          return SpotDetailHAppbar(
                              showShadow: false,
                              quoteCoin: _spotDetailModel.quoteCoin,
                              numberSlideController: _spotDetailModel.quoteSlideController
                          );
                        }
                    ),


                    Expanded(child: SpotKlineHBar(coinCode: widget.coinCode ?? '', horizontal: true))
                  ],
                ),
              )
          );

        }

    );
  }
}
