
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:module_quote/item/assets_distribution_item.dart';
import 'package:module_quote/model/index_data.dart';

class AssetsDistributionBar extends StatefulWidget {

  final IndexData? indexData;
  final List<AssetsDistribution>? dataList;
  final VoidCallback? onPressed;

  const AssetsDistributionBar({
    Key? key,
    this.indexData,
    this.dataList,
    this.onPressed,
  }): super(key: key);


  @override
  _SpotDataAddressAssetsDistributionBarState createState() => _SpotDataAddressAssetsDistributionBarState();
}

class _SpotDataAddressAssetsDistributionBarState extends State<AssetsDistributionBar> {

  ShotController _shotController = new ShotController();
  int? touchedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _share() async {

    Future.delayed(new Duration(milliseconds: 100), () async {

      Uint8List tabBarPngBytes = await _shotController.makeImageUint8List();
      DialogUtil.showShareDialog(context,
          children: [
            Container(
              color: Colours.white,
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(15, 18, 16, 9),
                      height: 24,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(S.of(context).proAddressAssetsDistribution,
                                style: TextStyles.textGray800_w700_18,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Image.memory(tabBarPngBytes),
                  Gaps.vGap18,
                  ShareQRFoooter(),
                ],
              ),
            ),
          ]
      );
    });

  }

  @override
  Widget build(BuildContext context) {

    num total_count = 0;
    for (int i=0; i<widget.dataList!.length; i++) {
      total_count += widget.dataList![i].address_count!;
    }

    num turnover = widget.indexData?.turnover ?? 0;
    String update_time = widget.indexData?.update_time ?? '';
    String pair = widget.indexData?.pair ?? '';

    return Container(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(15, 18, 16, 9),
                height: 24,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(S.of(context).proAddressAssetsDistribution,
                          style: TextStyles.textGray800_w700_18,
                        ),
                      ),
                    ),
                    GestureDetector(
                        child: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
                        onTap: _share
                    ),
                  ],
                )
            ),
            ShotView(
                controller: _shotController,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 15, top: 8),
                      child: Text(S.of(context).updateTime + ' : $update_time',
                        style: TextStyles.textGray300_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 18, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          border: Border.all(width: 0.6, color: Colours.default_line)
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 13, top: 12, right: 13),
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
                            margin: const EdgeInsets.only(left: 15, top: 8, right: 15, bottom: 10),
                            child: Row (
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(total_count.toString(),
                                  style: TextStyles.textGray800_w400_14,
                                ),
                                Text(turnover.toString() + pair,
                                  style: TextStyles.textGray800_w400_14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),


                    Container(
                      alignment: Alignment.center,
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
                        double proportion = total_count == 0 ? 0 : NumUtil.divide(widget.dataList![index].address_count!, total_count).toDouble() * 100;
                        String proportionStr = NumUtil.getNumByValueDouble(proportion, 2).toString() + "%";

                        return AssetsDistributionItem(
                          isLast: index == widget.dataList!.length - 1,
                          color: widget.dataList![index].getColor(index),
                          balanceRange: widget.dataList![index].range,
                          addressAmount: widget.dataList![index].address_count.toString(),
                          proportion: proportionStr,
                          compareYesterday: widget.dataList![index].compare_yesterday_ratio,
                        );
                      },
                      itemCount: widget.dataList!.length,
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }

  List<PieChartSectionData> showingSections() {
    int total_count = 0;
    for (int i=0; i<widget.dataList!.length; i++) {
      total_count += widget.dataList![i].address_count as int;
    }

    return List.generate(widget.dataList!.length, (i) {

      double proportion = total_count == 0 ? 0 : NumUtil.divide(widget.dataList![i].address_count!, total_count).toDouble() * 100;
      String proportionStr = NumUtil.getNumByValueDouble(proportion, 2).toString() + "%";

      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: widget.dataList![i].getColor(i),
        value: proportion,
        title: proportionStr,
        radius: radius,
        titleStyle: TextStyle(
            fontSize: proportion < 5 ? 0 : fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    });
  }
}
