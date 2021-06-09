import 'package:flutter/material.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:library_base/widget/image/circle_image.dart';

/// 列表项
class SettingAvatarClickBar extends StatefulWidget {
  // 标题
  final String title;

  final String? iconUrl;

  // 点击事件
  final Function()? onPressed;

  final ShapeBorder? shape;
  // 构造函数
  SettingAvatarClickBar({
    Key? key,
    required this.title,
    this.iconUrl,
    this.onPressed,
    this.shape,
  }) : super(key: key);

  @override
  _SettingAvatarClickBarState createState() => _SettingAvatarClickBarState();
}

class _SettingAvatarClickBarState extends State<SettingAvatarClickBar> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colours.white,
      shape: widget.shape,
      padding: EdgeInsets.all(0.0),
      onPressed: widget.onPressed,
      child: Container(
          height: 70.0,
          width: double.infinity,
          padding: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(widget.title,
                  style: TextStyles.textGray800_w400_16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Container(
                padding: EdgeInsets.only(right: 5),
                alignment: Alignment.centerRight,
                child: CircleImage(
                  widget.iconUrl ?? '',
                  radius: 23,
                  borderWidth: 0,
                  borderColor: Colours.white,
                  placeholderImage: DecorationImage(
                    image: AssetImage(ImageUtil.getImgPath('icon_default_head'), package: Constant.baseLib),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              widget.onPressed != null ? Icon(Icons.keyboard_arrow_right, color: Colours.gray_200, size: 24) : Container(),
            ],
          )),
    );
  }
}
