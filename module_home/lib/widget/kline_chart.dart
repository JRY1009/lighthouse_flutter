
import 'package:flutter/material.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/easyrefresh/loading_empty_top.dart';
import 'package:library_kchart/entity/k_line_entity.dart';
import 'package:library_kchart/k_chart_widget.dart';
import 'package:library_kchart/utils/kchart_data_util.dart';
import 'package:module_home/model/quote.dart';

class KLineChart extends StatefulWidget {

  final List<Quote> quoteList;
  final Function(KLineEntity entity) onLongPressChanged;

  const KLineChart({
    Key key,
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
    bool _inited = widget.quoteList != null;
    int length = 0;

    if (widget.quoteList != null) {
      List<KLineEntity> entityList = [];

      length = widget.quoteList.length;
      for (int i=0; i<length; i++) {
        KLineEntity entity = KLineEntity(
          open: widget.quoteList[i].quote,
          close: widget.quoteList[i].quote,
          high: widget.quoteList[i].quote,
          low: widget.quoteList[i].quote,
          vol: 0,
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
      height: 180,
      width: double.infinity,
      child: !_inited ? FirstRefreshTop() : length == 0 ? LoadingEmptyTop(top: 20) : KChartWidget(
        datas,
        isLine: true,
        isAutoScaled: true,
        mainState: MainState.NONE,
        secondaryState: SecondaryState.NONE,
        volState: VolState.NONE,
        fractionDigits: 2,
        onLongPressChanged: widget.onLongPressChanged,
      ),
    );

  }

}
