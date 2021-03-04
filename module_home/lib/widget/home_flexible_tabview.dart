
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:module_home/model/quote_pair.dart';
import 'package:module_home/widget/kline_chart.dart';

class HomeFlexibleTabView extends StatefulWidget {

  final QuotePair quotePair;
  final VoidCallback onPressed;

  const HomeFlexibleTabView({
    Key key,
    this.quotePair,
    this.onPressed,
  }): super(key: key);


  @override
  _HomeFlexibleTabViewState createState() => _HomeFlexibleTabViewState();
}

class _HomeFlexibleTabViewState extends State<HomeFlexibleTabView> with AutomaticKeepAliveClientMixin<HomeFlexibleTabView>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => Routers.navigateTo(
          context,
          Routers.spotDetailPage,
          parameters: Parameters()..putString('coinCode', widget.quotePair != null ? widget.quotePair.coin_code : '')),
      child: Container(
        height: 255,
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: Colours.transparent,
        child: Column(
          children: [
            Container(
              height: 180,
              child: KLineChart(
                  height: 180,
                  quoteList: widget.quotePair?.quote_24h
              ),
            ),
            Container(
              height: 75,
              child: Row (
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: 15,
                              alignment: Alignment.centerLeft,
                              child: Text(S.of(context).proMarketValue + '（\$）',
                                style: TextStyles.textGray400_w400_12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                          Gaps.vGap5,
                          Container(
                              height: 24,
                              alignment: Alignment.centerLeft,
                              child: Text(NumUtil.getBigVolumFormat(widget.quotePair?.market_val, fractionDigits: 0).toString(),
                                style: TextStyles.textBlack20,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: 15,
                              alignment: Alignment.centerLeft,
                              child: Text(S.of(context).pro24hTradeVolume + '（${widget.quotePair != null ? widget.quotePair.pair.split('/').first : ''}）',
                                style: TextStyles.textGray400_w400_12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                          Gaps.vGap5,
                          Container(
                              height: 24,
                              alignment: Alignment.centerLeft,
                              child: Text(NumUtil.getNumByValueDouble(widget.quotePair?.vol_24h, 0).toString(),
                                style: TextStyles.textBlack20,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: 15,
                              alignment: Alignment.centerLeft,
                              child: Text(S.of(context).proComputePower,
                                style: TextStyles.textGray400_w400_12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                          Gaps.vGap5,
                          Container(
                              height: 24,
                              alignment: Alignment.centerLeft,
                              child: Text(widget.quotePair != null ? widget.quotePair.hashrate : '0',
                                style: TextStyles.textBlack20,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),

          ],
        ),
      )
    );
  }
}
