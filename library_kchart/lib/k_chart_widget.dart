import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'chart_style.dart';
import 'entity/info_window_entity.dart';
import 'entity/k_line_entity.dart';
import 'renderer/chart_painter.dart';
import 'utils/kchart_date_format_util.dart';
import 'utils/kchart_number_util.dart';

enum MainState { MA, BOLL, NONE }
enum VolState { VOL, NONE }
enum SecondaryState { MACD, KDJ, RSI, WR, NONE }

class KChartWidget extends StatefulWidget {
  final List<KLineEntity> datas;
  final MainState mainState;
  final VolState volState;
  final SecondaryState secondaryState;
  final bool isLine;
  final bool isAutoScaled;
  final int gridRows;
  final int gridColumns;
  final Function(KLineEntity entity) onLongPressChanged;

  KChartWidget(
    this.datas, {
    this.mainState = MainState.MA,
    this.volState = VolState.VOL,
    this.secondaryState = SecondaryState.MACD,
    this.isLine,
    this.isAutoScaled = false,
    this.gridRows,
    this.gridColumns,
    this.onLongPressChanged,
    int fractionDigits = 2,
  }) {
    KChartNumberUtil.fractionDigits = fractionDigits;
  }

  @override
  _KChartWidgetState createState() => _KChartWidgetState();
}

class _KChartWidgetState extends State<KChartWidget> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  double mScaleX = 1.0, mScrollX = 0.0, mSelectX = 0.0;
  StreamController<InfoWindowEntity> mInfoWindowStream;
  StreamController<InfoWindowEntity> mInfoOutStream;
  StreamSubscription _streamSubscription;

  double mWidth = 0;
  AnimationController _scrollXController;

  double getMinScrollX() {
    return mScaleX;
  }

  double _lastScale = 1.0;
  bool isScale = false, isDrag = false, isLongPress = false;

  @override
  void initState() {
    super.initState();
    mInfoWindowStream = StreamController<InfoWindowEntity>();
    mInfoOutStream = StreamController<InfoWindowEntity>();
    _streamSubscription = mInfoOutStream.stream.listen((event) {
      KLineEntity entity = event?.kLineEntity;
      if (widget.onLongPressChanged != null) {
        widget.onLongPressChanged(entity);
      }
    });

    _controller = AnimationController(duration: const Duration(milliseconds: 850), vsync: this);
    _animation = Tween(begin: 0.9, end: 0.1).animate(_controller)..addListener(() => setState(() {}));
    _scrollXController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500), lowerBound: double.negativeInfinity, upperBound: double.infinity);
    _scrollListener();
  }

  void _scrollListener() {
    _scrollXController.addListener(() {
      mScrollX = _scrollXController.value;
      if (mScrollX <= 0) {
        mScrollX = 0;
        _stopAnimation();
      } else if (mScrollX >= ChartPainter.maxScrollX) {
        mScrollX = ChartPainter.maxScrollX;
        _stopAnimation();
      } else {
        notifyChanged();
      }
    });
    _scrollXController.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        isDrag = false;
        notifyChanged();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mWidth = MediaQuery.of(context).size.width;
  }

  @override
  void didUpdateWidget(KChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.datas != widget.datas) {
      if (isScale || isLongPress) return;
      mScrollX = mSelectX = 0.0;
    }
  }

  @override
  void dispose() {
    mInfoWindowStream?.close();
    mInfoOutStream?.close();
    _streamSubscription?.cancel();
    _controller?.dispose();
    _scrollXController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.datas == null || widget.datas.isEmpty) {
      mScrollX = mSelectX = 0.0;
      mScaleX = 1.0;
    }
    return GestureDetector(
      onHorizontalDragDown: widget.isAutoScaled ? null : (details) {
        _stopAnimation();
        isDrag = true;
      },
      onHorizontalDragUpdate: widget.isAutoScaled ? null : (details) {
        if (isScale || isLongPress) return;
        mScrollX = (details.primaryDelta / mScaleX + mScrollX).clamp(0.0, ChartPainter.maxScrollX);
        notifyChanged();
      },
      onHorizontalDragEnd: widget.isAutoScaled ? null : (DragEndDetails details) {
        // isDrag = false;
        final Tolerance tolerance = Tolerance(
          velocity:
              1.0 / (0.050 * WidgetsBinding.instance.window.devicePixelRatio), // logical pixels per second
          distance: 1.0 / WidgetsBinding.instance.window.devicePixelRatio, // logical pixels
        );

        ClampingScrollSimulation simulation = ClampingScrollSimulation(
          position: mScrollX,
          velocity: details.primaryVelocity,
          tolerance: tolerance,
        );
        _scrollXController.animateWith(simulation);
      },
      onHorizontalDragCancel: widget.isAutoScaled ? null : () => isDrag = false,
      onScaleStart: (_) {
        isScale = true;
      },
      onScaleUpdate: (details) {
        if (isDrag || isLongPress) return;
        mScaleX = (_lastScale * details.scale).clamp(0.5, 2.2);
        notifyChanged();
      },
      onScaleEnd: (_) {
        isScale = false;
        _lastScale = mScaleX;
      },
      onLongPressStart: (details) {
        isLongPress = true;
        if (mSelectX != details.localPosition.dx) {
          mSelectX = details.localPosition.dx;
          notifyChanged();
        }
      },
      onLongPressMoveUpdate: (details) {
        if (mSelectX != details.localPosition.dx) {
          mSelectX = details.localPosition.dx;
          notifyChanged();
        }
      },
      onLongPressEnd: (details) {
        isLongPress = false;
        mInfoWindowStream?.sink?.add(null);
        mInfoOutStream?.sink.add(null);
        notifyChanged();
      },
      child: Stack(
        children: <Widget>[
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: ChartPainter(
                datas: widget.datas,
                scaleX: mScaleX,
                isAutoScaled: widget.isAutoScaled,
                scrollX: mScrollX,
                selectX: mSelectX,
                gridRows: widget.gridRows,
                gridColumns: widget.gridColumns,
                isLongPass: isLongPress,
                mainState: widget.mainState,
                volState: widget.volState,
                secondaryState: widget.secondaryState,
                isLine: widget.isLine,
                sink: mInfoWindowStream?.sink,
                outsink: widget.onLongPressChanged != null ? mInfoOutStream?.sink : null,
                opacity: _animation.value,
                controller: _controller),
          ),
          _buildInfoDialog()
        ],
      ),
    );
  }

  void _stopAnimation() {
    if (_scrollXController != null && _scrollXController.isAnimating) {
      _scrollXController.stop();
      isDrag = false;
      notifyChanged();
    }
  }

  void notifyChanged() => setState(() {});

  List<String> infoNames = ["时间", "开", "高", "低", "收", "涨跌额", "涨幅", "成交量"];
  List infos;

  Widget _buildInfoDialog() {
    return StreamBuilder<InfoWindowEntity>(
        stream: mInfoWindowStream?.stream,
        builder: (context, snapshot) {
          if (!isLongPress || widget.isLine == true || !snapshot.hasData || snapshot.data.kLineEntity == null)
            return Container();
          KLineEntity entity = snapshot.data.kLineEntity;
          double upDown = entity.close - entity.open;
          double upDownPercent = upDown / entity.open * 100;
          infos = [
            getDate(entity.id),
            KChartNumberUtil.format(entity.open),
            KChartNumberUtil.format(entity.high),
            KChartNumberUtil.format(entity.low),
            KChartNumberUtil.format(entity.close),
            "${upDown > 0 ? "+" : ""}${KChartNumberUtil.format(upDown)}",
            "${upDownPercent > 0 ? "+" : ''}${upDownPercent.toStringAsFixed(2)}%",
            KChartNumberUtil.volFormat(entity.vol)
          ];
          return Align(
            alignment: snapshot.data.isLeft ? Alignment.topLeft : Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 25),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                  color: ChartColors.markerBgColor,
                  border: Border.all(color: ChartColors.markerBorderColor, width: 0.5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    List.generate(infoNames.length, (i) => _buildItem(infos[i].toString(), infoNames[i])),
              ),
            ),
          );
        });
  }

  Widget _buildItem(String info, String infoName) {
    Color color = Colors.white;
    if (info.startsWith("+"))
      color = Colors.green;
    else if (info.startsWith("-"))
      color = Colors.red;
    else
      color = Colors.white;
    return Container(
      constraints: BoxConstraints(minWidth: 95, maxWidth: 110, maxHeight: 14.0, minHeight: 14.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("$infoName", style: TextStyle(color: Colors.white, fontSize: ChartStyle.defaultTextSize)),
          SizedBox(width: 5),
          Text(info, style: TextStyle(color: color, fontSize: ChartStyle.defaultTextSize)),
        ],
      ),
    );
  }

  String getDate(int date) {
    return dateFormat(
        DateTime.fromMillisecondsSinceEpoch(date * 1000), [yy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }
}
