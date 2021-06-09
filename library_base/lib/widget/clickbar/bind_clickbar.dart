import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

/// 列表项
class BindClickBar extends StatefulWidget {
  // 标题
  final String title;

  // 点击事件
  final Function()? onPressed;

  final ShapeBorder? shape;

  final TextStyle? titleStyle;

  final EdgeInsetsGeometry? padding;

  final Widget? icon;

  final bool binded;

  // 构造函数
  BindClickBar({
    Key? key,
    required this.title,
    this.titleStyle,
    this.onPressed,
    this.shape,
    this.padding,
    this.icon,
    this.binded = false,
  }) : super(key: key);

  @override
  _SettingClickBarState createState() => _SettingClickBarState();
}

class _SettingClickBarState extends State<BindClickBar> {

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
          padding: widget.padding ?? EdgeInsets.only(left: 16, right: 20),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
          ),
          child: Row(
            children: <Widget>[
              widget.icon ?? Gaps.empty,
              Gaps.hGap10,
              Container(
                child: Text(widget.title,
                  style: widget.titleStyle ?? TextStyles.textGray800_w400_16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),

              widget.binded ? Container(
                child: Text(S.of(context).binded,
                  style: TextStyles.textGray400_w400_14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ) : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colours.app_main_500,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Text(S.of(context).gobind,
                  style: TextStyles.textWhite14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
    );
  }
}
