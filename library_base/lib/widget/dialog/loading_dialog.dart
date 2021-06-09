import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/colors.dart';

//loading加载框
class LoadingDialog extends Dialog {
  //loading动画
  final Widget? loadingView;
  //提示内容
  final String? content;
  //是否显示提示文字
  final bool showContent;
  //圆角大小
  final double radius;
  //文字颜色
  final Color textColor;
  //背景颜色
  final Color backgroundColor;

  LoadingDialog(
      {Key? key,
        this.loadingView,
        this.content,
        this.showContent = true,
        this.radius = 5,
        this.textColor = Colours.white,
        this.backgroundColor = Colours.app_main})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(

          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(
              minWidth: 280,
              maxHeight: 50,
            ),
            margin: EdgeInsets.only(left: 24, right: 24, top: 24),
            padding: EdgeInsets.only(left: 16, right: 16),
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                loadingView ?? SpinKitCircle(color: textColor, size: 25.0),
                showContent ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(content ?? S.current.loading, style: TextStyle(
                    fontSize: 14.0,
                    color: textColor)),
                ) : SizedBox.shrink(),
              ],
            ),
          )),
    );
  }
}
