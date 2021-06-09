import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';

/// 列表项
class AreaItem extends StatefulWidget {
  // 点击事件
  final Function()? onPressed;
  // 标题
  final String? title;
  // 右侧控件
  final bool check;

  // 构造函数
  AreaItem({
    Key? key,
    this.onPressed,
    this.title,
    this.check = false,
  }) : super(key: key);

  @override
  _AreaItemState createState() => _AreaItemState();
}

class _AreaItemState extends State<AreaItem> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
          height: 48.0,
          width: double.infinity,
          padding: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  widget.title ?? '',
                  style: TextStyles.textBlack14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              widget.check ? Icon(Icons.check, color: Colours.app_main, size: 25) : Container(),
            ],
          )),
    );
  }
}
