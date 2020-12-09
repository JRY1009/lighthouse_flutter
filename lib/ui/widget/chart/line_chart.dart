import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/net/model/quote.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/utils/num_util.dart';

class SimpleLineChart extends StatefulWidget {

  final List<Quote> quoteList;

  const SimpleLineChart({
    Key key,
    this.quoteList
  }): super(key: key);

  @override
  _SimpleLineChartState createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: LineChart(
        mainData(),
      ),
    );
  }

  LineChartData mainData() {

    int length = widget.quoteList != null ? widget.quoteList.length : 0;

    double minX = 0, maxX = length.toDouble(), minY = 0, maxY = 0;
    List<FlSpot> spotList = new List();
    for (int i=0; i<widget.quoteList?.length; i++) {
      FlSpot spot = FlSpot(i.toDouble(), widget.quoteList[i].quote);
      spotList.add(spot);

      minY = minY == 0 ? widget.quoteList[i].quote : min(widget.quoteList[i].quote, minY);
      maxY = max(widget.quoteList[i].quote, maxY);
    }

    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      borderData:  FlBorderData(show: true, border: Border.symmetric(horizontal: BorderSide(color: const Color(0xffC6D9FF), width: 0.5))),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: NumUtil.divideDec(maxY - minY, 3).ceilToDouble(),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            dashArray: [3, 3],
            color: const Color(0xffC6D9FF),
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => TextStyles.textGray500_w400_12,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '00:00';
              case 6:
                return '06:00';
              case 12:
                return '12:00';
              case 18:
                return '18:00';
              case 23:
                return '24:00';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(
          showTitles: true,
          interval: NumUtil.divideDec(maxY - minY, 3).floorToDouble(),
          getTextStyles: (value) => TextStyles.textGray500_w400_12,
          getTitles: (value) {
            return value.toInt().toString();
          },
          reservedSize: 28,
          margin: 10,
        ),
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spotList,
          isCurved: true,
          colors: [Colours.app_main],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradientFrom: Offset(0, 0),
            gradientTo: Offset(0, 1),
            colors: [Colours.app_main.withOpacity(0.2), Colours.app_main.withOpacity(0.0)],
            gradientColorStops: [0.2, 1.0],
          ),
        ),
      ],
    );
  }

}
