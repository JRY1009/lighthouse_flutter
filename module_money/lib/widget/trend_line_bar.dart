import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';

class TrendLineBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrendLineBarState();
}

class _TrendLineBarState extends State<TrendLineBar> {
  static const double barWidth = 6;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<BarChartGroupData> dataList = [];
    var random = Random();
    for (int i=0; i<20; i++) {
      bool above0 = random.nextBool() ;
      int rand = random.nextInt(20);
      double value = above0 ? rand.toDouble() : -rand.toDouble();
      var data = BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            y: value,
            width: barWidth,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
            rodStackItems: [
              BarChartRodStackItem(0, value, above0 ? Color(0xff2bdb90) : Color(0xffEC3944)),
            ],
          ),
        ],
      );
      dataList.add(data);
    }

    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: double.infinity,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: 20,
          minY: -20,
          groupsSpace: 12,
          barTouchData: BarTouchData(
            enabled: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: SideTitles(
                showTitles: false
            ),
            leftTitles: SideTitles(
              showTitles: false
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(color: Colours.gray_500, fontSize: 10),
              margin: 10,
              rotateAngle: 0,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return '     01/01';
                  case 19:
                    return '02/02     ';
                  default:
                    return '';
                }
              },
            ),
            rightTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(color: Colours.gray_500, fontSize: 10),
              rotateAngle: 45,
              getTitles: (double value) {
                if (value == 0) {
                  return '0';
                }
                return '${value.toInt()}0k';
              },
              interval: 10,
              margin: 8,
              reservedSize: 30,
            ),
          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (value) => value % 5 == 0,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(
                  color: const Color(0xffC6D9FF),
                  strokeWidth: 0.8,
                  dashArray: [3, 3],
                );
              }
              return FlLine(
                color: const Color(0xffC6D9FF),
                strokeWidth: 0.5,
                dashArray: [3, 3],
              );
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: dataList,
        ),
      ),
    );
  }
}
