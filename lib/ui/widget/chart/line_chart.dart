import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';

class SimpleLineChart extends StatefulWidget {
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
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      borderData:  FlBorderData(show: true, border: Border.symmetric(horizontal: BorderSide(color: const Color(0xffC6D9FF), width: 0.5))),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
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
          getTextStyles: (value) => TextStyles.textGray500_w400_12,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '1000';
              case 1:
                return '2000';
              case 2:
                return '3000';
              case 3:
                return '4000';
            }
            return '';
          },
          reservedSize: 28,
          margin: 10,
        ),
      ),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 3,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 0.5),
            FlSpot(2.6, 2.2),
            FlSpot(4.9, 2.4),
            FlSpot(6.8, 1.1),
            FlSpot(8, 1.4),
            FlSpot(9, 0.7),
            FlSpot(11, 2.6),
            FlSpot(13, 2),
            FlSpot(14, 1.5),
            FlSpot(15, 2.5),
            FlSpot(17, 2.8),
            FlSpot(19, 2.5),
          ],
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
