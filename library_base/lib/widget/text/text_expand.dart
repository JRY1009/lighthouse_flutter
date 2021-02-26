import 'dart:math' show max;
import 'dart:ui' show LineMetrics;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 在文本超出指定行数之后，会显示 展开/收起 按钮的文本展示组件
///
/// 用例1: 常规使用
/// TextExpand(
///   text: '一大段文字...',
///   minLines: 2,
///   textStyle: TextStyle(color: Colors.blue),
/// )
///
/// 用例2：特性化使用-比如 一段文字结尾显示的是 编辑，而点击编辑按钮之后要做一些事, 且显示样式不变
/// TextExpand(
///   text: '一大段文字...',
///   minLines: 2, // 这两个长度也要设置一致
///   maxLines: 2,
///   isAlwaysDisplay: true, // 按钮始终显示
///   textStyle: TextStyle(color: Colors.blue),
///   shrinkText: '编辑', // 这两个文本文字要设置成一样的
///   expandText: '编辑',
///   onShrink: onEdit, // 两个点击事件也要传递同样的事件
///   onExpand: onEdit,
/// )
class TextExpand extends StatefulWidget {
  final String text;

  /// 最少展示几行-在收起的状态下展示几行
  final int minLines;

  /// 最多展示几行-在展开的状态下展示几行，
  /// 默认最多支持显示99行，要显示更多的行数需要手动传入
  final int maxLines;

  /// 文字整体样式
  final TextStyle textStyle;

  /// 收起、展开文字颜色
  final Color keyColor;

  /// 收起状态下按钮文字
  final String shrinkText;

  ///  展开状态下的按钮文字
  final String expandText;

  /// 当点击收起的时候
  final Function onShrink;

  /// 当点击展开的时候
  final Function onExpand;

  /// 结尾按钮是否始终处于显示状态
  final bool isAlwaysDisplay;

  /// 展开按钮的widget，会替换文字
  final Icon expandIcon;

  /// 收起按钮的widget, 会替换文字
  final Icon shrinkIcon;

  final StrutStyle strutStyle;

  const TextExpand({
    Key key,
    this.text = '',
    this.minLines,
    this.textStyle,
    this.maxLines,
    this.keyColor = const Color(0xFF5396FD),
    this.shrinkText = '展开',
    this.expandText = '收起',
    this.onShrink,
    this.onExpand,
    this.isAlwaysDisplay = false,
    this.expandIcon,
    this.shrinkIcon,
    this.strutStyle
  }) : super(key: key);

  @override
  _TextExpandState createState() => _TextExpandState();
}

class _TextExpandState extends State<TextExpand> {
  final GlobalKey _key = GlobalKey();

  bool _isExpand = false;

  bool _isOver = false;

  String _shrinkText;

  String _expandText;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    _key.currentState?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextExpand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text.compareTo(oldWidget.text) != 0) {
      init();
    }
  }

  void init() {
    _shrinkText = widget.text;
    _expandText = widget.text;
    if (widget.minLines != null && widget.minLines > 0) {
      initValue();
    }
  }

  String get _activeText => _isExpand ? _expandBtnText : _shrinkBtnText;

  String get _showText => _isExpand ? _expandText : _shrinkText;

  int get _minLines => _isExpand ? _maxLines : widget.minLines;

  int get _maxLines => widget.maxLines ?? 99;

  bool _isOverflow(List metrics, int len) => metrics.length > len;

  String get _shrinkBtnText => ' ${widget.shrinkText}';

  String get _expandBtnText => ' ${widget.expandText}';

  TextStyle get _textStyle =>
      DefaultTextStyle.of(context).style.merge(widget.textStyle);

  Icon _icon(bool isExpand) => isExpand ? widget.shrinkIcon : widget.expandIcon;

  void initValue() {
    // TODO: 暂时还剩一个问题是这种延时处理的方式无法保证文本组件一定渲染完成了
    Future.delayed(Duration(), () {
      // 如果没有渲染完成那么这里就会报错，无法获取到size
      List<LineMetrics> lineMetrics;
      try {
        lineMetrics = _paintText(widget.text);
      } catch (_) {
        lineMetrics = List.generate(
          max(99, widget.maxLines ?? 99),
              (index) => null,
        );
      }
      setState(() {
        _isOver = _isOverflow(lineMetrics, widget.minLines);
        if (_isOver) {
          _shrinkText =
              _calcShrinkText(lineMetrics, widget.minLines, _shrinkBtnText);
          _expandText = _calcShrinkText(
            lineMetrics,
            _maxLines,
            _expandBtnText,
            isExpand: true,
          );
        }
      });
    });
  }

  List<LineMetrics> _paintText(String text, {double maxWidth}) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: _textStyle),
    );
    if (maxWidth != null) {
      textPainter.layout(minWidth: maxWidth, maxWidth: maxWidth);
    } else {
      final textWidth = _key.currentContext.size.width;
      textPainter.layout(minWidth: textWidth, maxWidth: textWidth);
    }

    return textPainter.computeLineMetrics();
  }

  bool _lenEquals(String text, int len) => _paintText(text).length == len;

  void _tapRecognizer() {
    setState(() => _isExpand = !_isExpand);
    if (_isExpand) {
      (widget.onShrink ?? () => {})();
    } else {
      (widget.onExpand ?? () => {})();
    }
  }

  String _getOverflowedText(
      String shrinkText, {
        String trailingText = '',
        int limitLen = 0,
      }) {
    int textLen = widget.text.length;
    int step = 1;
    int count = 0;
    while (!_lenEquals('$shrinkText$trailingText', limitLen + 1)) {
      if (shrinkText.length + step > textLen) {
        count++;
        if (count > 10) {
          // 死循环检测处理
          break;
        }
        if (step < 1) {
          break;
        } else {
          step = step ~/ 2;
        }
      } else {
        shrinkText = widget.text.substring(0, shrinkText.length + step);
        step += 4;
      }
    }
    return shrinkText;
  }

  /// 获取大于指定宽度的_文本
  String _getSpeWidthText(double width) {
    String result = '_';
    while (!_isOverflow(_paintText(result, maxWidth: width), 1)) {
      result += '_';
    }
    return result;
  }

  String _calcShrinkText(
      List<LineMetrics> lineMetrics,
      int len,
      String trailingBtnText, {
        bool isExpand = false,
      }) {
    // 如果限制的最大行数超过了实际渲染出来的最大行数，说明根据不会出现溢出的情况
    if (len > lineMetrics.length) return widget.text;

    final String spacerText = _isOverflow(lineMetrics, len) ? '...' : '';

    String trailingText;

    if (_icon(isExpand) != null) {
      trailingText =
      '$spacerText${_getSpeWidthText(_icon(isExpand).size ?? IconTheme.of(context).size)}';
    } else {
      trailingText = '$spacerText$trailingBtnText';
    }
    // 计算出n行文本大致的字数，根据字数从原文本截取相应的字符串
    // double nTextLength = min(len, lineMetrics.length) *
    //     _key.currentContext.size.width /
    //     _textStyle.fontSize;
    // String shrinkText = widget.text.substring(0, nTextLength.toInt());
    // 暂时不能从这里计算长度，当文字带有换行的时候会出问题
    String shrinkText = '';
    // 下面加上结尾字符不一定会换行，因为字体不是等宽字体
    // 所以需要先确定溢出才开始倒算
    shrinkText = _getOverflowedText(
      shrinkText,
      trailingText: trailingText,
      limitLen: len,
    );
    // 这个时候这些文字加上结尾附加文字一定是会换行的
    // 所以一直判断如果文字换行的行数大于传入的指定行数，那么就从文字末尾减去一个字符
    // 再继续判断，直到文本行数等于传入的指定行数为止
    // 使用runes计算，避免表情在某些位置报错
    final shrinkTextRunnes = shrinkText.runes.toList();
    int offset = 0;
    while (!_lenEquals('$shrinkText$trailingText', len)) {
      if (shrinkTextRunnes.length - offset > 0) {
        // shrinkText = shrinkText.substring(0, shrinkText.length - 1);
        offset++;
        shrinkText = String.fromCharCodes(
            shrinkTextRunnes.sublist(0, shrinkTextRunnes.length - offset));
      } else {
        break;
      }
    }
    return '$shrinkText$spacerText';
  }

  InlineSpan _trailingBtn() {
    if (_icon(_isExpand) != null) {
      return WidgetSpan(
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: _tapRecognizer,
          child: _icon(_isExpand),
        ),
        style: _textStyle.copyWith(color: widget.keyColor),
      );
    }
    return TextSpan(
      text: _activeText,
      style: _textStyle.copyWith(color: widget.keyColor),
      recognizer: TapGestureRecognizer()..onTap = _tapRecognizer,
    );
  }

  Widget _handleText() {
    return Stack(
      children: [
        Text.rich(
          TextSpan(
            text: _showText,
            children: [
              if (_isOver || widget.isAlwaysDisplay) _trailingBtn(),
            ],
          ),
          key: _key,
          maxLines: _minLines,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: _textStyle,
          strutStyle: widget.strutStyle,
        ),
      ],
    );
  }

  Widget _dispatch() {
    if (widget.minLines != null && widget.minLines > 0) {
      return _handleText();
    }
    return Text(
      widget.text,
      maxLines: widget.minLines,
      style: _textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _dispatch();
  }
}
