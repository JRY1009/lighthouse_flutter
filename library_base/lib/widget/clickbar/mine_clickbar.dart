import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';

/// 列表项
class MineClickBar extends StatefulWidget {
  // 标题
  final String title;

  final String? subTitle;
  // 右侧控件
  final Widget? icon;
  // 点击事件
  final Function()? onPressed;

  final ShapeBorder? shape;
  // 构造函数
  MineClickBar({
    Key? key,
    required this.title,
    this.subTitle,
    this.icon,
    this.onPressed,
    this.shape,
  }) : super(key: key);

  @override
  _MineClickBarState createState() => _MineClickBarState();
}

class _MineClickBarState extends State<MineClickBar> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: widget.shape,
      padding: EdgeInsets.all(0.0),
      onPressed: widget.onPressed,
      child: Container(
          height: 54.0,
          width: double.infinity,
          padding: EdgeInsets.only(left: 6),
          child: Row(
            children: <Widget>[
              widget.icon != null ? IconButton(
                onPressed: null,
                constraints: BoxConstraints(minWidth: 0),
                padding: EdgeInsets.all(10),
                icon: widget.icon!,
              ) : Gaps.empty,
              Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(widget.title,
                            style: TextStyles.textGray800_w400_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(widget.subTitle ?? '',
                                style: TextStyles.textGray800_w400_14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                        ),
                        widget.onPressed != null ? Icon(Icons.keyboard_arrow_right, color: Colours.gray_200, size: 24) : Container(),
                      ],
                    ),
                  )
              ),
            ],
          )),
    );
  }
}
