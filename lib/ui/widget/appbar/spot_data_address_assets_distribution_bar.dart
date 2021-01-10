
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/spot_address_assets_distribution.dart';
import 'package:lighthouse/net/model/spot_data_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/item/spot_address_assets_distribution_item.dart';

class SpotDataAddressAssetsDistributionBar extends StatefulWidget {

  final SpotDataBasic spotDataBasic;
  final List<SpotAddressAssetsDistribution> dataList;
  final VoidCallback onPressed;

  const SpotDataAddressAssetsDistributionBar({
    Key key,
    this.spotDataBasic,
    this.dataList,
    this.onPressed,
  }): super(key: key);


  @override
  _SpotDataAddressAssetsDistributionBarState createState() => _SpotDataAddressAssetsDistributionBarState();
}

class _SpotDataAddressAssetsDistributionBarState extends State<SpotDataAddressAssetsDistributionBar> {

  int touchedIndex;

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
              child: Text(S.of(context).proAddressAssetsDistribution,
                style: TextStyles.textGray800_w400_15,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 15, top: 8),
              child: Text(S.of(context).updateTime + ' : 2020-11-11 11:11',
                style: TextStyles.textGray300_w400_12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 15, top: 18, right: 15, ),
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).proAddressTotalAmount,
                    style: TextStyles.textGray500_w400_12,
                  ),
                  Text(S.of(context).proTotalVolum,
                    style: TextStyles.textGray500_w400_12,
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 15, top: 8, right: 15, ),
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.spotDataBasic.address_count.toString(),
                    style: TextStyles.textGray800_w400_12,
                  ),
                  Text(widget.spotDataBasic.total_supply.toString(),
                    style: TextStyles.textGray800_w400_12,
                  ),
                ],
              ),
            ),

            Container(
              alignment: Alignment.topCenter,
              height: 200,
              margin: const EdgeInsets.only(left: 15, top: 5, right: 15),
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse.touchInput is FlLongPressEnd ||
                            pieTouchResponse.touchInput is FlPanEnd) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex = pieTouchResponse.touchedSectionIndex;
                        }
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections()),
              ),
            ),

            Container(
              height: 35.0,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 15, top: 8, right: 15),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
              ),
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(S.of(context).proBalanceRange, style: TextStyles.textGray500_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,)
                  ),
                  Container(
                    width: 90,
                    alignment: Alignment.centerRight,
                    child: Text(S.of(context).proAddressAmount, style: TextStyles.textGray500_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),
                  ),
                  Container(
                    width: 70,
                    alignment: Alignment.centerRight,
                    child: Text(S.of(context).proProportion, style: TextStyles.textGray500_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),
                  ),
                  Container(
                    width: 70,
                    alignment: Alignment.centerRight,
                    child: Text(S.of(context).proCompareYesterday, style: TextStyles.textGray500_w400_12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.only(left: 15, right: 15),
              itemBuilder: (context, index) {
                return SpotAddressAssetsDistributionItem(
                  index: index,
                  balanceRange: widget.dataList[index].range,
                  addressAmount: widget.dataList[index].address_count.toString(),
                  proportion: '10.11%',
                  compareYesterday: widget.dataList[index].compare_yesterday_ratio,
                );
              },
              itemCount: widget.dataList.length,
            ),
          ],
        )
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
