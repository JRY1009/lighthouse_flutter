
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/widget/percent/linear_percent_indicator.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:module_quote/model/index_data.dart';

class IndexCirculationBar extends StatefulWidget {

  final IndexData? indexData;
  final VoidCallback? onPressed;

  const IndexCirculationBar({
    Key? key,
    this.indexData,
    this.onPressed,
  }): super(key: key);


  @override
  _IndexCirculationBarState createState() => _IndexCirculationBarState();
}

class _IndexCirculationBarState extends State<IndexCirculationBar> {

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
    String pair = widget.indexData?.pair ?? '';
    num total_supply = widget.indexData?.total_supply ?? 0;
    num total_supply_market_vol = widget.indexData?.total_supply_market_vol ?? 0;

    num turnover = widget.indexData?.turnover ?? 0;
    num turnover_market_vol = total_supply == 0 ? 0 : NumUtil.getNumByValueDouble(NumUtil.multiply(NumUtil.divide(total_supply_market_vol, total_supply), turnover), 0)!;

    num percent = total_supply == 0 ? 0 : NumUtil.getNumByValueDouble(NumUtil.divideDec(turnover, total_supply).toDouble(), 2)!.clamp(0.0, 1.0);
    num lp = total_supply == 0 ? 0 : NumUtil.divideDec(turnover, total_supply).toDouble().clamp(0.0, 1.0) * 100;
    num rp = total_supply == 0 ? 0 : NumUtil.divideDec(total_supply - turnover, total_supply).toDouble().clamp(0.0, 1.0) * 100;
    String lpStr = NumUtil.getNumByValueDouble(lp.toDouble(), 2).toString() + "%";
    String rpStr = NumUtil.getNumByValueDouble(rp.toDouble(), 2).toString() + "%";

    return percent == 0 ? Gaps.empty: Container(
        child: Column(
          children: [

            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 15, top: 18),
              child: Text(S.of(context).proCirculationRatio,
                style: TextStyles.textGray800_w700_18,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 15, top: 18, right: 15, ),
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lpStr,
                    style: TextStyles.textMain12,
                  ),
                  Text(rpStr,
                    style: TextStyles.textGreenLight_w400_12,
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 9, top: 5, right: 9),
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 8.0,
                animationDuration: 1000,
                percent: percent as double,
                animateFromLastPercent: true,
                linearStrokeCap: LinearStrokeCap.roundHalf,
                progressColor: Colours.app_main,
                backgroundColor: Colours.text_green_light,
                //widgetIndicator: RotatedBox(quarterTurns: 1, child: Icon(Icons.airplanemode_active, size: 50)),
              ),
            ),

            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 15, top: 18, right: 15, ),
              child: Row (
                children: [
                  Container(
                    width: 4,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colours.app_main,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(left: 9),
                    child: Text(S.of(context).proCirculation + '/' + S.of(context).proMarketValue,
                      style: TextStyles.textGray500_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    child: Text(turnover.toString() + pair + ' / \$' + turnover_market_vol.toString(),
                      style: TextStyles.textGray800_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 15, top: 13, right: 15, bottom: 18),
              child: Row (
                children: [
                  Container(
                    width: 4,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colours.text_green_light,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(left: 9),
                    child: Text(S.of(context).proTotalVolum + '/' + S.of(context).proMarketValue,
                      style: TextStyles.textGray500_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    child: Text(total_supply.toString() + pair + ' / \$' + total_supply_market_vol.toString(),
                      style: TextStyles.textGray800_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}
