
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/spot_address_assets_distribution.dart';
import 'package:lighthouse/net/model/spot_data_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/item/spot_address_assets_distribution_item.dart';
import 'package:lighthouse/utils/num_util.dart';

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

    int total_count = 0;
    for (int i=0; i<widget.dataList.length; i++) {
      total_count += widget.dataList[i].address_count;
    }

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
                double proportion = total_count == 0 ? 0 : NumUtil.divide(widget.dataList[index].address_count, total_count).toDouble() * 100;
                String proportionStr = NumUtil.getNumByValueDouble(proportion, 2).toString() + "%";

                return SpotAddressAssetsDistributionItem(
                  index: index,
                  color: widget.dataList[index].getColor(index),
                  balanceRange: widget.dataList[index].range,
                  addressAmount: widget.dataList[index].address_count.toString(),
                  proportion: proportionStr,
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
    int total_count = 0;
    for (int i=0; i<widget.dataList.length; i++) {
      total_count += widget.dataList[i].address_count;
    }

    return List.generate(widget.dataList.length, (i) {

      double proportion = total_count == 0 ? 0 : NumUtil.divide(widget.dataList[i].address_count, total_count).toDouble() * 100;
      String proportionStr = NumUtil.getNumByValueDouble(proportion, 2).toString() + "%";

      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: widget.dataList[i].getColor(i),
        value: proportion,
        title: proportionStr,
        radius: radius,
        titleStyle: TextStyle(
            fontSize: proportion < 5 ? 0 : fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    });
  }
}
