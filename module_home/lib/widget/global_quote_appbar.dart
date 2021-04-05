
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/parameters.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:module_home/viewmodel/global_quote_model.dart';
import 'package:module_home/viewmodel/home_model.dart';
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

    num btcRate = homeModel.btcUsdPair != null ? homeModel.btcUsdPair.change_percent : 0;
    num btcPrice = homeModel.btcUsdPair != null ? homeModel.btcUsdPair.quote : 0;
    String btcRateStr = (btcRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(btcRate.toDouble(), 2).toString() + '%';
    String btcPriceStr = '\$' + NumUtil.formatNum(btcPrice, point: 2);

    num ethRate = homeModel.ethUsdPair != null ? homeModel.ethUsdPair.change_percent : 0;
    num ethPrice = homeModel.ethUsdPair != null ? homeModel.ethUsdPair.quote : 0;
    String ethRateStr = (ethRate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(ethRate.toDouble(), 2).toString() + '%';
    String ethPriceStr = '\$' + NumUtil.formatNum(ethPrice, point: 2);

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
                    parameters: Parameters()..putString('coinCode', HomeModel.COIN_BITCOIN)),
                child: Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: Colours.white80,
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
                              child: Text(homeModel.btcUsdPair != null ? homeModel.btcUsdPair.pair : '', style: TextStyles.textGray800_w400_15,
                              )),
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
                      parameters: Parameters()..putString('coinCode', HomeModel.COIN_ETHEREUM)),
                  child: Container(
                      height: widget.height,
                      decoration: BoxDecoration(
                        color: Colours.white80,
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
                              child: Text(homeModel.ethUsdPair != null ? homeModel.ethUsdPair.pair : '', style: TextStyles.textGray800_w400_15,)
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
              )
          ),
        ],
      ),
    );
  }
}
