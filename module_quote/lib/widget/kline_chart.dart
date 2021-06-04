
import 'package:flutter/material.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_kchart/entity/k_line_entity.dart';
import 'package:library_kchart/k_chart_widget.dart';
import 'package:library_kchart/utils/kchart_data_util.dart';
import 'package:library_base/model/quote.dart';

mixin KLineChartMixin<T extends StatefulWidget> on State<T> {

  void addLastData(Quote quote) {
  }

  void updateLastData(Quote quote) {
  }
}

class KLineChart extends StatefulWidget {

  final double height;
  final int gridRows;
  final int gridColumns;
  final MainState mainState;
  final VolState volState;
  final SecondaryState secondaryState;
  final bool isLine;
  final bool isAutoScaled;
  final List<Quote> quoteList;
  final Function(KLineEntity entity) onLongPressChanged;

  const KLineChart({
    Key key,
    this.height,
    this.gridRows,
    this.gridColumns,
    this.mainState = MainState.NONE,
    this.volState = VolState.NONE,
    this.secondaryState = SecondaryState.NONE,
    this.isAutoScaled = true,
    this.isLine = true,
    this.quoteList,
    this.onLongPressChanged
  }): super(key: key);

  @override
  KLineChartState createState() => KLineChartState();
}

class KLineChartState extends State<KLineChart> with KLineChartMixin<KLineChart> {

  List<KLineEntity> datas = [];

  @override
  void initState() {
    super.initState();

    if (ImageUtil.kline_logo == null) {
      ImageUtil.loadImage('packages/library_base/assets/images/kline_logo.png', 127, 31).then((res) {
        setState(() {
          ImageUtil.kline_logo = res;
        });
      });
    }
  }

  @override
  void addLastData(Quote quote) {

    KLineEntity entity = KLineEntity(
      open: quote.open.toDouble(),
      close: quote.close.toDouble(),
      high: quote.high.toDouble(),
      low: quote.low.toDouble(),
      vol: quote.vol.toDouble(),
      amount: 0,
      count: 0,
      id: quote.id,
    );

    KChartDataUtil.addLastData(datas, entity);
  }

  @override
  void updateLastData(Quote quote) {

    KLineEntity entity = KLineEntity(
      open: quote.open.toDouble(),
      close: quote.close.toDouble(),
      high: quote.high.toDouble(),
      low: quote.low.toDouble(),
      vol: quote.vol.toDouble(),
      amount: 0,
      count: 0,
      id: quote.id,
    );

    datas.last = entity;
    KChartDataUtil.updateLastData(datas);
  }

  @override
  Widget build(BuildContext context) {

    int length = 0;
    if (widget.quoteList != null) {
      List<KLineEntity> entityList = [];

      length = widget.quoteList.length;
      for (int i=0; i<length; i++) {
        KLineEntity entity = KLineEntity(
          open: widget.quoteList[i].open.toDouble(),
          close: widget.quoteList[i].close.toDouble(),
          high: widget.quoteList[i].high.toDouble(),
          low: widget.quoteList[i].low.toDouble(),
          vol: widget.quoteList[i].vol.toDouble(),
          amount: 0,
          count: 0,
          id: widget.quoteList[i].id,
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
        isLine: widget.isLine,
        isAutoScaled: widget.isAutoScaled,
        mainState: widget.mainState,
        secondaryState: widget.secondaryState,
        volState: widget.volState,
        fractionDigits: 2,
        gridRows: widget.gridRows,
        gridColumns: widget.gridColumns,
        onLongPressChanged: widget.onLongPressChanged,
        logoImage: ImageUtil.kline_logo,
      ),
    );

  }

}
