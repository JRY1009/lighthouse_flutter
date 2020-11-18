
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/percent/linear_percent_indicator.dart';

class SpotDataCirculationBar extends StatefulWidget {

  final VoidCallback onPressed;

  const SpotDataCirculationBar({
    Key key,
    this.onPressed,
  }): super(key: key);


  @override
  _SpotDataCirculationBarState createState() => _SpotDataCirculationBarState();
}

class _SpotDataCirculationBarState extends State<SpotDataCirculationBar> {

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
        margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 9),
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          boxShadow: BoxShadows.normalBoxShadow,
        ),
        child: Column(
          children: [

            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 15, top: 18),
              child: Text(S.of(context).proCirculationRatio,
                style: TextStyles.textGray800_w400_15,
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
                  Text('50%',
                    style: TextStyles.textMain12,
                  ),
                  Text('50%',
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
                percent: 0.50,
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
                    child: Text('10000BTC / \$1,123,324.00',
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
                    child: Text('10000BTC / \$1,123,324.00',
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
