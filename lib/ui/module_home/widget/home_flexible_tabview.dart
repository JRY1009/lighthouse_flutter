
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/quote_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/widget/chart/line_chart.dart';
import 'package:lighthouse/utils/num_util.dart';

class HomeFlexibleTabView extends StatefulWidget {

  final QuoteBasic quoteBasic;
  final VoidCallback onPressed;

  const HomeFlexibleTabView({
    Key key,
    this.quoteBasic,
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

    return Container(
      height: 270,
      padding: EdgeInsets.symmetric(horizontal: 12),
      color: Colours.transparent,
      child: Column(
        children: [
          Container(
            height: 170,
            child: SimpleLineChart(quoteList: widget.quoteBasic?.quote_24h),
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
                            alignment: Alignment.centerLeft,
                            child: Text(S.of(context).proTotalMarketValue + '（\$）',
                              style: TextStyles.textGray400_w400_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(NumUtil.getBigVolumFormat(widget.quoteBasic?.market_val, fractionDigits: 2).toString(),
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
                            alignment: Alignment.centerLeft,
                            child: Text(S.of(context).pro24hVolume + '（${widget.quoteBasic != null ? widget.quoteBasic.pair.split('/').first : ''}）',
                              style: TextStyles.textGray400_w400_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(NumUtil.getNumByValueDouble(widget.quoteBasic?.vol_24h, 2).toString(),
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
                            alignment: Alignment.centerLeft,
                            child: Text(S.of(context).proComputePower,
                              style: TextStyles.textGray400_w400_12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Gaps.vGap5,
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(NumUtil.getNumByValueDouble(widget.quoteBasic?.hashrate, 2).toString(),
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
          InkWell(
            onTap: () => Routers.navigateTo(context, Routers.spotDetailPage, params: {'coin_code': widget.quoteBasic != null ? widget.quoteBasic.pair.split('/').first : ''}),
            child: Container(
              height: 20,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(S.of(context).viewDetail,
                          style: TextStyles.textGray500_w400_12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colours.gray_500, size: 20),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
