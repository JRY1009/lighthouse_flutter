

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/screen_util.dart';
import 'package:library_base/widget/button/check_text_button.dart';
import 'package:library_base/widget/dialog/popup_window.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/tab/round_indicator.dart';
import 'package:library_kchart/k_chart_widget.dart';
import 'package:module_quote/viewmodel/spot_detail_model.dart';
import 'package:module_quote/viewmodel/spot_kline_model.dart';
import 'package:module_quote/widget/kline_chart.dart';
import 'package:module_quote/widget/kline_select_menu.dart';
import 'package:provider/provider.dart';

class SpotKlineHBar extends StatefulWidget {

  final String coinCode;
  final bool horizontal;

  const SpotKlineHBar({
    Key key,
    this.coinCode,
    this.horizontal = false
  }): super(key: key);


  @override
  _SpotKlineHBarState createState() => _SpotKlineHBarState();
}

class _SpotKlineHBarState extends State<SpotKlineHBar> with AutomaticKeepAliveClientMixin<SpotKlineHBar>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  SpotKlineModel _spotKlineModel;

  TabController _tabController;

  MainState mainState = MainState.MA;
  VolState volState = VolState.VOL;
  SecondaryState secondaryState = SecondaryState.NONE;

  final GlobalKey<KLineChartMixin> keyChart = GlobalKey();
  final GlobalKey _tabKey = GlobalKey();
  final GlobalKey _bodyKey = GlobalKey();
  double _tabHeight = 24;

  double _height;

  int _initIndex = 2;
  int _lastIndex = 2;
  int _subIndex;
  int _tablength = 7;

  @override
  void initState() {
    super.initState();

    _height = widget.horizontal ? double.infinity : max(295, ScreenUtil.instance().screenHeight * 0.5);

    _tabController = TabController(initialIndex:_initIndex, length: _tablength, vsync: this);
    initViewModel();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initViewModel() {
    _spotKlineModel = SpotKlineModel(keyChart);
    _spotKlineModel.listenEvent();
    _spotKlineModel.getQuote(widget.coinCode, _initIndex);
  }

  @override
  Future<void> refresh({slient = false}) {
    return _spotKlineModel.getQuote(widget.coinCode, _tabController.index);
  }

  void _showSortMenu() {
    // 获取点击控件的坐标
    final RenderBox tab = _tabKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox body = _bodyKey.currentContext?.findRenderObject() as RenderBox;

    showPopupWindow<void>(
      context: context,
      offset: const Offset(0.0, 0.0),
      anchor: tab,
      child: KlineSelectMenu(
        crossAxisCount: 8,
        data: _spotKlineModel.moreList,
        height: body.size.height - tab.size.height,
        sortIndex: _subIndex,
        onSelected: (index, name) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _subIndex = index;
            _lastIndex = _tabController.index;
            if (_spotKlineModel.getQuoteList(_tabController.index) != null) {
              _spotKlineModel.notifyListeners();
            } else {
              _spotKlineModel.getQuote(widget.coinCode, _tabController.index);
            }
          });
        },
        onCancel: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_lastIndex != _tablength - 1) {
              _subIndex = null;
            }
            _tabController.index = _lastIndex;
            _spotKlineModel?.spotKlineTabModel.notifyListeners();
          });
        },
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
        height: _height,
        color: Colours.white,
        margin: EdgeInsets.only(bottom: 9),
        child: ProviderWidget<SpotKlineModel>(
            model: _spotKlineModel,
            builder: (context, model, child) {
              return  Column(
                key: _bodyKey,
                children: [
                  ProviderWidget<SpotKlineTabModel>(
                      model: _spotKlineModel.spotKlineTabModel,
                      builder: (context, model, child) {
                        return Container(
                          key: _tabKey,
                          height: _tabHeight,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                            labelColor: Colours.app_main_500,
                            labelStyle: TextStyles.textMain500_12,
                            unselectedLabelColor: Colours.gray_400,
                            unselectedLabelStyle: TextStyles.textGray400_w400_12,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: RoundTabIndicator(
                                borderSide: BorderSide(color: Colours.app_main, width: 2),
                                isRound: true,
                                insets: EdgeInsets.only(left: 1, right: 1)),
//              ),
                            isScrollable: true,
                            tabs: <Tab>[
                              Tab(text: S.of(context).timeline),
                              Tab(text: S.of(context).kline1h),
                              Tab(text: S.of(context).kline24h),
                              Tab(text: S.of(context).kline1week),
                              Tab(text: S.of(context).kline1month),
                              Tab(text: S.of(context).kline1year),
                              Tab(child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  width: 28,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Text(_subIndex == null ? S.of(context).more : _spotKlineModel.moreList[_subIndex],
                                            style: (_tabController.index == _tablength - 1) ? TextStyles.textMain500_12 : TextStyles.textGray400_w400_12),
                                      ),

                                      Positioned(
                                          right: 0,
                                          bottom: 1,
                                          child: LocalImage('arrow_right_bottom', color: (_tabController.index == _tablength - 1) ? Colours.app_main_500 : Colours.gray_400, package: Constant.moduleQuote, width: 4, height: 4)
                                      )
                                    ],
                                  )
                              )),
                            ],
                            onTap: (index) {
                              if (index == _tablength - 1) {
                                _showSortMenu();
                                model.notifyListeners();
                              } else {
                                _subIndex = null;
                                _lastIndex = index;
                                if (_spotKlineModel.getQuoteList(_tabController.index) != null) {
                                  _spotKlineModel.notifyListeners();
                                } else {
                                  _spotKlineModel.getQuote(widget.coinCode, index);
                                }
                              }
                            },
                          ),
                        );
                      }
                  ),

                  Expanded(
                    child: Row(
                      children: [

                        Expanded(
                            child: Container(
                                height: _height - 85,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: model.isBusy ? FirstRefresh() : KLineChart(
                                  key: keyChart,
                                  height: _height - 85,
                                  gridRows: 3,
                                  mainState: mainState,
                                  volState: volState,
                                  secondaryState: secondaryState,
                                  isAutoScaled: false,
                                  isLine: _tabController.index == 0,
                                  quoteList: model.getQuoteList(_tabController.index),
                                  onLongPressChanged: (entity) {
                                    SpotDetailModel spotDetailModel = Provider.of<SpotDetailModel>(context, listen: false);
                                    spotDetailModel?.handleKLineLongPress(entity);
                                  },
                                )
                            )
                        ),


                        Container(
                          width: 44,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CheckTextButton(value: mainState == MainState.MA, text: 'MA', onChanged: (value) {
                                setState(() {mainState = value ? MainState.MA : MainState.NONE;});
                              }),
                              CheckTextButton(value: mainState == MainState.BOLL, text: 'BOLL', onChanged: (value) {
                                setState(() {mainState = value ? MainState.BOLL : MainState.NONE;});
                              }),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: SizedBox(width: 11, height: 1.0, child: Divider(height: 1, color: Colours.gray_400)),
                              ),
                              CheckTextButton(value: volState == VolState.VOL, text: 'VOL', onChanged: (value) {
                                setState(() {volState = value ? VolState.VOL : VolState.NONE;});
                              }),
                              CheckTextButton(value: secondaryState == SecondaryState.MACD, text: 'MACD', onChanged: (value) {
                                setState(() {secondaryState = value ? SecondaryState.MACD : SecondaryState.NONE;});
                              }),
                              CheckTextButton(value: secondaryState == SecondaryState.RSI, text: 'RSI', onChanged: (value) {
                                setState(() {secondaryState = value ? SecondaryState.RSI : SecondaryState.NONE;});
                              }),
                              CheckTextButton(value: secondaryState == SecondaryState.KDJ, text: 'KDJ', onChanged: (value) {
                                setState(() {secondaryState = value ? SecondaryState.KDJ : SecondaryState.NONE;});
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  )

                ],
              );
            }
        )

    );
  }
}
