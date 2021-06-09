import 'dart:async' show StreamSink;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:library_kchart/entity/k_line_entity.dart';
import 'package:library_kchart/utils/kchart_date_format_util.dart';
import 'package:library_kchart/entity/info_window_entity.dart';

import 'base_chart_painter.dart';
import 'base_chart_renderer.dart';
import 'main_renderer.dart';
import 'secondary_renderer.dart';
import 'vol_renderer.dart';

class ChartPainter extends BaseChartPainter {
  static get maxScrollX => BaseChartPainter.maxScrollX;
  BaseChartRenderer? mMainRenderer, mVolRenderer, mSecondaryRenderer;
  StreamSink<InfoWindowEntity?>? sink;
  StreamSink<InfoWindowEntity?>? outsink;
  AnimationController? controller;
  double opacity;

  ui.Image? logoImage;

  ChartPainter(
      {required datas,
      required scaleX,
      required scrollX,
      required isLongPass,
      required selectX,
      mainState,
      volState,
      secondaryState,
      this.sink,
      this.outsink,
      int? gridRows,
      int? gridColumns,
      bool? isLine,
      bool? isAutoScaled,
      this.controller,
      this.opacity = 0.0,
      this.logoImage
      })
      : super(
            datas: datas,
            scaleX: scaleX,
            scrollX: scrollX,
            isLongPress: isLongPass,
            selectX: selectX,
            mainState: mainState,
            volState: volState,
            secondaryState: secondaryState,
            gridRows: gridRows ?? ChartStyle.gridRows,
            gridColumns: gridColumns ?? ChartStyle.gridColumns,
            isLine: isLine,
            isAutoScaled: isAutoScaled);

  @override
  void initChartRenderer() {
    mMainRenderer ??= MainRenderer(
        mMainRect, mMainMaxValue, mMainMinValue, ChartStyle.topPadding, mainState, isLine, scaleX);
    if (mVolRect != null) {
      mVolRenderer ??= VolRenderer(mVolRect, mVolMaxValue, mVolMinValue, ChartStyle.childPadding, scaleX);
    }
    if (mSecondaryRect != null) {
      mSecondaryRenderer ??= SecondaryRenderer(mSecondaryRect, mSecondaryMaxValue, mSecondaryMinValue,
          ChartStyle.childPadding, secondaryState, scaleX);
    }
  }

  final Paint mBgPaint = Paint()..color = ChartColors.bgColor;

  @override
  void drawBg(Canvas canvas, Size size) {
    if (mMainRect != null) {
      Rect mainRect = Rect.fromLTRB(0, 0, mMainRect!.width, mMainRect!.height + ChartStyle.topPadding);
      canvas.drawRect(mainRect, mBgPaint);
    }

    if (mVolRect != null) {
      Rect volRect =
          Rect.fromLTRB(0, mVolRect!.top - ChartStyle.childPadding, mVolRect!.width, mVolRect!.bottom);
      canvas.drawRect(volRect, mBgPaint);
    }

    if (mSecondaryRect != null) {
      Rect secondaryRect = Rect.fromLTRB(
          0, mSecondaryRect!.top - ChartStyle.childPadding, mSecondaryRect!.width, mSecondaryRect!.bottom);
      canvas.drawRect(secondaryRect, mBgPaint);
    }
    Rect dateRect = Rect.fromLTRB(0, size.height - ChartStyle.bottomDateHigh, size.width, size.height);
    canvas.drawRect(dateRect, mBgPaint);
  }

  @override
  void drawGrid(canvas) {
    mMainRenderer?.drawGrid(canvas, gridRows!, gridColumns!,
        showRows: outsink != null || isAutoScaled == false,
        showColumns: isAutoScaled == false);
    mVolRenderer?.drawGrid(canvas, gridRows!, gridColumns!);
    mSecondaryRenderer?.drawGrid(canvas, gridRows!, gridColumns!);
  }

  @override
  void drawLogo(canvas) {

    if (logoImage != null) {
      canvas.drawImage(logoImage, Offset(15, mMainRect!.bottom - 50), Paint());
    }
  }

  @override
  void drawChart(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(mTranslateX * scaleX, 0.0);
    canvas.scale(scaleX, 1.0);
    for (int i = mStartIndex; datas != null && i <= mStopIndex; i++) {
      KLineEntity curPoint = datas[i];
      if (curPoint == null) continue;
      KLineEntity lastPoint = i == 0 ? curPoint : datas[i - 1];
      double curX = getX(i);
      double lastX = i == 0 ? curX : getX(i - 1);

      mMainRenderer?.drawChart(lastPoint, curPoint, lastX, curX, size, canvas);
      mVolRenderer?.drawChart(lastPoint, curPoint, lastX, curX, size, canvas);
      mSecondaryRenderer?.drawChart(lastPoint, curPoint, lastX, curX, size, canvas);
    }

    if (isLongPress == true) drawCrossLine(canvas, size);
    canvas.restore();
  }

  @override
  void drawRightText(canvas) {
    if (isAutoScaled!) {
      return;
    }

    var textStyle = getTextStyle(ChartColors.yAxisTextColor);
    mMainRenderer?.drawRightText(canvas, textStyle, gridRows!);
    mVolRenderer?.drawRightText(canvas, textStyle, gridRows!);
    mSecondaryRenderer?.drawRightText(canvas, textStyle, gridRows!);
  }

  @override
  void drawDate(Canvas canvas, Size size) {
    if (isAutoScaled!) {
      return;
    }

    double columnSpace = size.width / gridColumns!;
    double startX = getX(mStartIndex) - mPointWidth / 2;
    double stopX = getX(mStopIndex) + mPointWidth / 2;
    double y = 0.0;
    for (var i = 0; i <= gridColumns!; ++i) {
      double translateX = xToTranslateX(columnSpace * i);
      if (translateX >= startX && translateX <= stopX) {
        int index = indexOfTranslateX(translateX);
        if (datas[index] == null) {
            continue;
        }
        TextPainter tp = getTextPainter(getDate(datas[index].id!), color: ChartColors.xAxisTextColor);
        y = size.height - (ChartStyle.bottomDateHigh - tp.height) / 2 - tp.height;
        if (i == 0) {
          tp.paint(canvas, Offset(0, y));
        } else if(i == gridColumns) {
          tp.paint(canvas, Offset(columnSpace * i - tp.width, y));
        } else {
          tp.paint(canvas, Offset(columnSpace * i - tp.width / 2, y));
        }

      } else {
        if (isAutoScaled!) {
          int index = datas.length - 1;
          TextPainter tp = getTextPainter(getDate(datas[index].id!), color: ChartColors.xAxisTextColor);
          y = size.height - (ChartStyle.bottomDateHigh - tp.height) / 2 - tp.height;
          tp.paint(canvas, Offset(columnSpace * gridColumns! - tp.width, y));
          break;
        }
      }
    }
  }

  Paint selectPointPaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 0.5
    ..color = ChartColors.markerBgColor;
  Paint selectorBorderPaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke
    ..color = ChartColors.markerBorderColor;

  Paint selectPointPaintScaled = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 0.5
    ..color = ChartColors.markerBgScaledColor;
  Paint selectorBorderPaintScaled = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke
    ..color = ChartColors.markerBorderScaledColor;

  @override
  void drawCrossLineText(Canvas canvas, Size size) {
    var index = calculateSelectedX(selectX);
    KLineEntity point = getItem(index) as KLineEntity;

    if (!isAutoScaled!) {
      TextPainter tp = getTextPainter(format(point.close!), color: ChartColors.normalTextColor);
      double textHeight = tp.height;
      double textWidth = tp.width;

      double w1 = 5;
      double w2 = 3;
      double r = textHeight / 2 + w2;
      double y = getMainY(point.close!);
      double x;
      bool isLeft = false;
      if (translateXtoX(getX(index)) < mWidth! / 2) {
        isLeft = false;
        x = 1;
        Path path = new Path();
        path.moveTo(x, y - r);
        path.lineTo(x, y + r);
        path.lineTo(textWidth + 2 * w1, y + r);
        path.lineTo(textWidth + 2 * w1 + w2, y);
        path.lineTo(textWidth + 2 * w1, y - r);
        path.close();
        canvas.drawPath(path, selectPointPaint);
        canvas.drawPath(path, selectorBorderPaint);
        tp.paint(canvas, Offset(x + w1, y - textHeight / 2));
      } else {
        isLeft = true;
        x = mWidth! - textWidth - 1 - 2 * w1 - w2;
        Path path = new Path();
        path.moveTo(x, y);
        path.lineTo(x + w2, y + r);
        path.lineTo(mWidth! - 2, y + r);
        path.lineTo(mWidth! - 2, y - r);
        path.lineTo(x + w2, y - r);
        path.close();
        canvas.drawPath(path, selectPointPaint);
        canvas.drawPath(path, selectorBorderPaint);
        tp.paint(canvas, Offset(x + w1 + w2, y - textHeight / 2));
      }

      TextPainter dateTp = getTextPainter(getDate(point.id!), color: ChartColors.normalTextColor);
      textWidth = dateTp.width;
      r = textHeight / 2;
      x = translateXtoX(getX(index));
      y = size.height - ChartStyle.bottomDateHigh;

      if (x < textWidth / 2 + 2 * w1) {
        x = 1 + textWidth / 2 + w1;
      } else if (mWidth! - x < textWidth / 2 + 2 * w1) {
        x = mWidth! - 1 - textWidth / 2 - w1;
      }
      double baseLine = textHeight / 2;
      canvas.drawRect(
          Rect.fromLTRB(x - textWidth / 2 - w1, y, x + textWidth / 2 + w1, y + baseLine + r), selectPointPaint);
      canvas.drawRect(Rect.fromLTRB(x - textWidth / 2 - w1, y, x + textWidth / 2 + w1, y + baseLine + r),
          selectorBorderPaint);

      dateTp.paint(canvas, Offset(x - textWidth / 2, y));
      //长按显示这条数据详情
      sink?.add(InfoWindowEntity(point, isLeft));
      outsink?.add(InfoWindowEntity(point, isLeft));

    } else {

      bool isLeft = false;
      double w1 = 0;
      double w2 = 3;

      if (outsink == null) {
        TextPainter tp = getTextPainter(format(point.close!), color: ChartColors.realTextColor);
        double textHeight = tp.height;
        double textWidth = tp.width;

        double r = textHeight / 2 + 1;
        double y = getMainY(point.close!);
        double x;
        if (translateXtoX(getX(index)) < mWidth! / 2) {
          isLeft = false;
          x = mWidth! - textWidth - 1 - 2 * w2 - w1;
          Path path = new Path();
          path.moveTo(x, y + r);
          path.lineTo(mWidth! - 2, y + r);
          path.lineTo(mWidth! - 2, y - r);
          path.lineTo(x, y - r);
          path.close();
          canvas.drawPath(path, selectPointPaintScaled);
          canvas.drawPath(path, selectorBorderPaintScaled);
          tp.paint(canvas, Offset(x + w1 + w2, y - textHeight / 2));
        } else {
          isLeft = true;
          x = 1;
          Path path = new Path();
          path.moveTo(x, y - r);
          path.lineTo(x, y + r);
          path.lineTo(textWidth + 2 * w2, y + r);
          path.lineTo(textWidth + 2 * w2, y - r);
          path.close();
          canvas.drawPath(path, selectPointPaintScaled);
          canvas.drawPath(path, selectorBorderPaintScaled);
          tp.paint(canvas, Offset(x + w2, y - textHeight / 2));
        }

//        if (translateXtoX(getX(index)) < mWidth / 2) {
//          isLeft = false;
//          x = 1;
//          tp.paint(canvas, Offset(x + w1, y - textHeight));
//        } else {
//          isLeft = true;
//          x = mWidth - textWidth - 1 - 2 * w1 - w2;
//          tp.paint(canvas, Offset(x + w1 + w2, y - textHeight));
//        }
      }

      TextPainter dateTp = getTextPainter(getDate(point.id!), color: ChartColors.normalTextColor);
      double textHeight = dateTp.height;
      double textWidth = dateTp.width;
      double r = textHeight / 2;
      double x = translateXtoX(getX(index));
      double y = size.height - ChartStyle.bottomDateHigh;

      if (x < textWidth / 2 + 2 * w1) {
        x = 1 + textWidth / 2 + w1;
      } else if (mWidth! - x < textWidth / 2 + 2 * w1) {
        x = mWidth! - 1 - textWidth / 2 - w1;
      }

      dateTp.paint(canvas, Offset(x - textWidth / 2, ChartStyle.topPadding - textHeight));
      //长按显示这条数据详情
      sink?.add(InfoWindowEntity(point, isLeft));
      outsink?.add(InfoWindowEntity(point, isLeft));
    }

  }

  @override
  void drawText(Canvas canvas, KLineEntity data, double x) {
    //长按显示按中的数据
    if (isLongPress) {
      var index = calculateSelectedX(selectX);
      data = getItem(index) as KLineEntity;
    }
    //松开显示最后一条数据
    mMainRenderer?.drawText(canvas, data, x);
    mVolRenderer?.drawText(canvas, data, x);
    mSecondaryRenderer?.drawText(canvas, data, x);
  }

  @override
  void drawMaxAndMin(Canvas canvas) {
    //if (isLine == true) return;
    //绘制最大值和最小值
    double min = isLine! ? mMainMinValue : mMainLowMinValue;
    double x = translateXtoX(getX(mMainMinIndex));
    double y = getMainY(min);
    if (x < mWidth! / 2) {
      //画右边
      TextPainter tp = getTextPainter("── \$${format(min)}", color: ChartColors.maxMinTextColor);
      tp.paint(canvas, Offset(x, y - tp.height / 2));
    } else {
      TextPainter tp = getTextPainter("\$${format(min)} ──", color: ChartColors.maxMinTextColor);
      tp.paint(canvas, Offset(x - tp.width, y - tp.height / 2));
    }

    double max = isLine! ? mMainMaxValue : mMainHighMaxValue;
    x = translateXtoX(getX(mMainMaxIndex));
    y = getMainY(max);
    if (x < mWidth! / 2) {
      //画右边
      TextPainter tp = getTextPainter("── \$${format(max)}", color: ChartColors.maxMinTextColor);
      tp.paint(canvas, Offset(x, y - tp.height / 2));
    } else {
      TextPainter tp = getTextPainter("\$${format(max)} ──", color: ChartColors.maxMinTextColor);
      tp.paint(canvas, Offset(x - tp.width, y - tp.height / 2));
    }
  }

  ///画交叉线
  void drawCrossLine(Canvas canvas, Size size) {
    var index = calculateSelectedX(selectX);
    KLineEntity point = getItem(index) as KLineEntity;

    Paint paintY = Paint()
      ..color = ChartColors.crossLineTransColor
      ..strokeWidth = ChartStyle.vCrossWidth / scaleX
      ..isAntiAlias = true;
    double x = getX(index);
    double y = getMainY(point.close!);
    // k线图竖线
    canvas.drawLine(
        Offset(x, ChartStyle.topPadding), Offset(x, size.height - ChartStyle.bottomDateHigh), paintY);

    Paint paintX = Paint()
      ..color = ChartColors.crossLineColor
      ..strokeWidth = ChartStyle.hCrossWidth
      ..isAntiAlias = true;
    // k线图横线
    canvas.drawLine(Offset(-mTranslateX, y), Offset(-mTranslateX + mWidth! / scaleX, y), paintX);

    Paint paintB = Paint()
      ..color = ChartColors.crossLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ChartStyle.hCrossWidth
      ..isAntiAlias = true;
    Paint paintR = Paint()
      ..color = ChartColors.pointBlinkColor
      ..style = PaintingStyle.fill
      ..strokeWidth = ChartStyle.hCrossWidth
      ..isAntiAlias = true;
//  canvas.drawCircle(Offset(x, y), 2.0, paintX);
    canvas.drawOval(Rect.fromCenter(center: Offset(x, y), height: 6.0, width: 6.0 / scaleX), paintB);
    canvas.drawOval(Rect.fromCenter(center: Offset(x, y), height: 5.0, width: 5.0 / scaleX), paintR);
  }

  final Paint realTimePaint = Paint()
        ..strokeWidth = 1.0
        ..isAntiAlias = true,
      pointPaint = Paint();

  ///画实时价格线
  @override
  void drawRealTimePrice(Canvas canvas, Size size) {
    if (datas.isEmpty == true) return;

    if (isAutoScaled! && outsink != null) {
      KLineEntity point = datas.last;
      TextPainter tp = getTextPainter(format(point.close!), color: ChartColors.realTextColor);

      double y = getMainY(point.close!);
      var max = -mTranslateX + mWidth! / scaleX;
      var dashWidth = 5;
      var dashSpace = 3;
      double startX = -mTranslateX;
      final space = (dashSpace + dashWidth);
      while (startX < max) {
        canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y),
            realTimePaint..color = ChartColors.realTimeLineColor);
        startX += space;
      }

    } else {
      if (mMarginRight == 0) return;
      KLineEntity point = datas.last;
      TextPainter tp = getTextPainter(format(point.close!), color: ChartColors.realTimeTextColor);
      double y = getMainY(point.close!);
      //max越往右边滑值越小
      var max = (mTranslateX.abs() + mMarginRight - getMinTranslateX().abs() + mPointWidth) * scaleX;
      double x = mWidth! - max;
      if (!isLine!) x += mPointWidth / 2;
      var dashWidth = 10;
      var dashSpace = 5;
      double startX = 0;
      final space = (dashSpace + dashWidth);
      if (tp.width < max) {
        while (startX < max) {
          canvas.drawLine(Offset(x + startX, y), Offset(x + startX + dashWidth, y),
              realTimePaint..color = ChartColors.realTimeLineColor);
          startX += space;
        }
        //画一闪一闪
        if (isLine!) {
          startAnimation();
          Gradient pointGradient =
          RadialGradient(colors: [ChartColors.pointBlinkColor.withOpacity(opacity), Colors.transparent]);
          pointPaint.shader = pointGradient.createShader(Rect.fromCircle(center: Offset(x, y), radius: 14.0));
          canvas.drawCircle(Offset(x, y), 14.0, pointPaint);
          canvas.drawCircle(Offset(x, y), 2.0, realTimePaint..color = ChartColors.pointBlinkColor);
        } else {
          stopAnimation(); //停止一闪闪
        }
        double left = mWidth! - tp.width;
        double top = y - tp.height / 2;
        canvas.drawRect(Rect.fromLTRB(left, top, left + tp.width, top + tp.height),
            realTimePaint..color = ChartColors.realTimeBgColor);
        tp.paint(canvas, Offset(left, top));
      } else {
        stopAnimation(); //停止一闪闪
        startX = 0;
        if (point.close! > mMainMaxValue) {
          y = getMainY(mMainMaxValue);
        } else if (point.close! < mMainMinValue) {
          y = getMainY(mMainMinValue);
        }
        while (startX < mWidth!) {
          canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y),
              realTimePaint..color = ChartColors.realTimeLongLineColor);
          startX += space;
        }

        const padding = 3.0;
        const triangleHeight = 6.0; //三角高度
        const triangleWidth = 4.0; //三角宽度

        double left = mWidth! - mWidth! / gridColumns! - tp.width / 2 - padding * 2;
        double top = y - tp.height / 2 - padding;
        //加上三角形的宽以及padding
        double right = left + tp.width + padding * 2 + triangleWidth + padding;
        double bottom = top + tp.height + padding * 2;
        double radius = (bottom - top) / 2;
        //画椭圆背景
        RRect rectBg1 = RRect.fromLTRBR(left, top, right, bottom, Radius.circular(radius));
        RRect rectBg2 = RRect.fromLTRBR(left - 1, top - 1, right + 1, bottom + 1, Radius.circular(radius + 2));
        canvas.drawRRect(rectBg2, realTimePaint..color = ChartColors.realTimeTextBorderColor);
        canvas.drawRRect(rectBg1, realTimePaint..color = ChartColors.realTimeBgColor);
        tp = getTextPainter(format(point.close!), color: ChartColors.realTimeTextColor);
        Offset textOffset = Offset(left + padding, y - tp.height / 2);
        tp.paint(canvas, textOffset);
        //画三角
        Path path = Path();
        double dx = tp.width + textOffset.dx + padding;
        double dy = top + (bottom - top - triangleHeight) / 2;
        path.moveTo(dx, dy);
        path.lineTo(dx + triangleWidth, dy + triangleHeight / 2);
        path.lineTo(dx, dy + triangleHeight);
        path.close();
        canvas.drawPath(
            path,
            realTimePaint
              ..color = ChartColors.realTimeTextColor
              ..shader = null);
      }
    }
  }

  TextPainter getTextPainter(text, {color = Colors.white}) {
    TextSpan span = TextSpan(text: "$text", style: getTextStyle(color));
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    return tp;
  }

  String getDate(int date) => dateFormat(DateTime.fromMillisecondsSinceEpoch(date * 1000), mFormats);

  double getMainY(double y) => mMainRenderer?.getY(y) ?? 0.0;

  startAnimation() {
    if (controller?.isAnimating != true) controller?.repeat(reverse: true);
  }

  stopAnimation() {
    if (controller?.isAnimating == true) controller?.stop();
  }
}
