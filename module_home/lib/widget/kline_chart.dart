
import 'package:flutter/material.dart';
import 'package:library_base/model/quote.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_kchart/entity/k_line_entity.dart';
import 'package:library_kchart/k_chart_widget.dart';
import 'package:library_kchart/utils/kchart_data_util.dart';

class KLineChart extends StatefulWidget {

  final double? height;
  final int? gridRows;
  final int? gridColumns;
  final List<Quote>? quoteList;
  final Function(KLineEntity? entity)? onLongPressChanged;

  const KLineChart({
    Key? key,
    this.height,
    this.gridRows,
    this.gridColumns,
    this.quoteList,
    this.onLongPressChanged
  }): super(key: key);

  @override
  _KLineChartState createState() => _KLineChartState();
}

class _KLineChartState extends State<KLineChart> {

  List<KLineEntity> datas = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    int length = 0;
    if (widget.quoteList != null) {
      List<KLineEntity> entityList = [];

      length = widget.quoteList!.length;
      for (int i=0; i<length; i++) {
        KLineEntity entity = KLineEntity(
          open: widget.quoteList![i].quote.toDouble(),
          close: widget.quoteList![i].quote.toDouble(),
          high: widget.quoteList![i].quote.toDouble(),
          low: widget.quoteList![i].quote.toDouble(),
          vol: 0,
          amount: 0,
          count: 0,
          id: widget.quoteList![i].id,
        );
        entityList.add(entity);
      }

      datas = entityList.reversed.toList().cast<KLineEntity>();
      KChartDataUtil.calculate(datas);
    }

    return Container(
      height: widget.height,
      width: double.infinity,
      child: length == 0 ? LoadingEmpty() : KChartWidget(
        datas,
        isLine: true,
        isAutoScaled: true,
        mainState: MainState.NONE,
        secondaryState: SecondaryState.NONE,
        volState: VolState.NONE,
        fractionDigits: 2,
        gridRows: widget.gridRows,
        gridColumns: widget.gridColumns,
        onLongPressChanged: widget.onLongPressChanged,
      ),
    );

  }

}
