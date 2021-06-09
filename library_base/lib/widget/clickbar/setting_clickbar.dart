import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

/// 列表项
class SettingClickBar extends StatefulWidget {
  // 标题
  final String title;

  final String? subTitle;

  // 点击事件
  final Function()? onPressed;

  final ShapeBorder? shape;

  final TextStyle? titleStyle;

  final EdgeInsetsGeometry? padding;

  final bool iconSpace;

  // 构造函数
  SettingClickBar({
    Key? key,
    required this.title,
    this.titleStyle,
    this.subTitle,
    this.onPressed,
    this.shape,
    this.padding,
    this.iconSpace = true
  }) : super(key: key);

  @override
  _SettingClickBarState createState() => _SettingClickBarState();
}

class _SettingClickBarState extends State<SettingClickBar> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colours.white,
      shape: widget.shape,
      padding: EdgeInsets.all(0.0),
      onPressed: widget.onPressed ?? (){},
      child: Container(
          height: 52.0,
          width: double.infinity,
          padding: widget.padding ?? EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(widget.title,
                  style: widget.titleStyle ?? TextStyles.textGray800_w400_16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(widget.subTitle ?? '',
                      style: TextStyles.textGray400_w400_14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
              ),
              widget.onPressed != null ? Icon(Icons.keyboard_arrow_right, color: Colours.gray_200, size: 24) : Container(width: widget.iconSpace ? 24 : 0),
            ],
          )),
    );
  }
}
