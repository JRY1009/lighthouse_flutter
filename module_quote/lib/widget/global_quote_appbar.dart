
import 'package:flutter/material.dart';
import 'package:library_base/model/quote_pair.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/widget/image/round_image.dart';
import 'package:module_quote/viewmodel/global_quote_model.dart';
import 'package:provider/provider.dart';

class GlobalQuoteAppBar extends StatefulWidget {

  final double height;

  const GlobalQuoteAppBar({
    Key key,
    @required this.height,
  }): super(key: key);


  @override
  _GlobalQuoteAppBarState createState() => _GlobalQuoteAppBarState();
}

class _GlobalQuoteAppBarState extends State<GlobalQuoteAppBar> {

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
    GlobalQuoteModel homeModel = Provider.of<GlobalQuoteModel>(context);

    num btcRate = homeModel?.btcUsdPair?.change_percent ?? 0;
    num btcPrice = homeModel?.btcUsdPair?.quote ?? 0;
    String btcRateStr = (btcRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(btcRate.toDouble(), 2).toString() + '%';
    String btcPriceStr = NumUtil.formatNum(btcPrice, point: 2);

    num ethRate = homeModel?.ethUsdPair?.change_percent ?? 0;
    num ethPrice = homeModel?.ethUsdPair?.quote ?? 0;
    String ethRateStr = (ethRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(ethRate.toDouble(), 2).toString() + '%';
    String ethPriceStr = NumUtil.formatNum(ethPrice, point: 2);

    return Container(
      height: widget.height,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => Routers.navigateTo(
                    context,
                    Routers.spotDetailPage,
                    parameters: Parameters()..putString('coinCode', Apis.COIN_BITCOIN)),
                child: Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: Colours.whitea0,
                      borderRadius: BorderRadius.all(Radius.circular(11.0)),
                      boxShadow: BoxShadows.normalBoxShadow,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                    width: 18,
                                    height: 18,
                                    child:  RoundImage(homeModel?.btcUsdPair?.icon ?? '',
                                      width: 18,
                                      height: 18,
                                      borderRadius: BorderRadius.all(Radius.circular(18)),
                                      fadeInDuration: const Duration(milliseconds: 10),
                                    )
                                ),
                                Gaps.hGap5,
                                Text(homeModel?.btcUsdPair?.coin_code ?? '', style: TextStyles.textGray800_w700_15)
                              ],
                            ),
                          ),
                          Gaps.vGap5,
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                Text.rich(TextSpan(
                                    children: [
                                      TextSpan(text: '\$', style: btcRate >= 0 ? TextStyles.textGreen_w600_10 : TextStyles.textRed_w600_10),
                                      TextSpan(text: btcPriceStr, style: btcRate >= 0 ? TextStyles.textGreen_w600_14 : TextStyles.textRed_w600_14),
                                    ]
                                )),
                                Gaps.hGap8,
                                Container(
                                  height: 18,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: btcRate >= 0 ? Color(0x1a22C29B) : Color(0x1aEC3944),
                                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  ),
                                  child: Text(btcRateStr,
                                    style: btcRate >= 0 ? TextStyles.textGreen_w400_10 : TextStyles.textRed_w400_10,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          )
                        ]
                    )
                ),
              )


          ),
          Gaps.hGap12,
          Expanded(
              flex: 1,
              child: GestureDetector(
                  onTap: () => Routers.navigateTo(
                      context,
                      Routers.spotDetailPage,
                      parameters: Parameters()..putString('coinCode', Apis.COIN_ETHEREUM)),
                  child: Container(
                      height: widget.height,
                      decoration: BoxDecoration(
                        color: Colours.whitea0,
                        borderRadius: BorderRadius.all(Radius.circular(11.0)),
                        boxShadow: BoxShadows.normalBoxShadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                    width: 18,
                                    height: 18,
                                    child:  RoundImage(homeModel?.ethUsdPair?.icon ?? '',
                                      width: 18,
                                      height: 18,
                                      borderRadius: BorderRadius.all(Radius.circular(18)),
                                      fadeInDuration: const Duration(milliseconds: 10),
                                    )
                                ),
                                Gaps.hGap5,
                                Text(homeModel?.ethUsdPair?.coin_code ?? '', style: TextStyles.textGray800_w700_15)
                              ],
                            ),
                          ),
                          Gaps.vGap5,
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                Text.rich(TextSpan(
                                    children: [
                                      TextSpan(text: '\$', style: ethRate >= 0 ? TextStyles.textGreen_w600_10 : TextStyles.textRed_w600_10),
                                      TextSpan(text: ethPriceStr, style: ethRate >= 0 ? TextStyles.textGreen_w600_14 : TextStyles.textRed_w600_14),
                                    ]
                                )),
                                Gaps.hGap8,
                                Container(
                                  height: 18,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: ethRate >= 0 ? Color(0x1a22C29B) : Color(0x1aEC3944),
                                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  ),
                                  child: Text(ethRateStr,
                                    style: ethRate >= 0 ? TextStyles.textGreen_w400_10 : TextStyles.textRed_w400_10,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  )
              )
          ),
        ],
      ),
    );
  }
}

class GlobalQuoteShareBar extends StatelessWidget {

  final QuotePair btcUsdPair;
  final QuotePair ethUsdPair;

  const GlobalQuoteShareBar({
    Key key,
    this.btcUsdPair,
    this.ethUsdPair
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    String btcIco = btcUsdPair?.icon ?? '';
    num btcRate = btcUsdPair?.change_percent ?? 0;
    num btcPrice = btcUsdPair?.quote ?? 0;
    String btcRateStr = (btcRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(btcRate.toDouble(), 2).toString() + '%';
    String btcPriceStr = '\$' + NumUtil.formatNum(btcPrice, point: 2);

    String ethIco = ethUsdPair?.icon ?? '';
    num ethRate = ethUsdPair?.change_percent ?? 0;
    num ethPrice = ethUsdPair?.quote ?? 0;
    String ethRateStr = (ethRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(ethRate.toDouble(), 2).toString() + '%';
    String ethPriceStr = '\$' + NumUtil.formatNum(ethPrice, point: 2);

    return Container(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  height: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 12),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              RoundImage(btcIco,
                                width: 18,
                                height: 18,
                                borderRadius: BorderRadius.all(Radius.circular(0)),
                              ),
                              Gaps.hGap5,
                              Text(btcUsdPair?.coin_code ?? '', style: TextStyles.textGray800_w700_15)
                            ],
                          ),
                        ),
                        Gaps.vGap5,
                        Container(
                            margin: EdgeInsets.only(left: 12),
                            alignment: Alignment.centerLeft,
                            child: Text(btcPriceStr + '  ' + btcRateStr,
                              style: btcRate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                            )
                        ),
                      ]
                  )
              )


          ),
          Gaps.hGap12,
          Expanded(
              flex: 1,
              child: Container(
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        alignment: Alignment.centerLeft,
                        child: Row(

                          children: [
                            RoundImage(ethIco,
                              width: 18,
                              height: 18,
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ),
                            Gaps.hGap5,
                            Text(ethUsdPair?.coin_code ?? '', style: TextStyles.textGray800_w700_15)
                          ],
                        ),
                      ),
                      Gaps.vGap5,
                      Container(
                          margin: EdgeInsets.only(left: 12),
                          alignment: Alignment.centerLeft,
                          child: Text(ethPriceStr + '  ' + ethRateStr,
                            style: ethRate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
                          )
                      ),
                    ],
                  )
              )
          ),
        ],
      ),
    );
  }
}
