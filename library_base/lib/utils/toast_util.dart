import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/utils/screen_util.dart';
import 'package:oktoast/oktoast.dart';

const DEFAULT_TOAST_DURATION = Duration(milliseconds: 2500);

class ToastUtil {
  ToastUtil._internal();

  ///全局初始化Toast配置, child为MaterialApp
  static init(Widget child) {
    return OKToast(
      ///字体大小
      textStyle: TextStyle(fontSize: 16, color: Colors.white),
      backgroundColor: Colours.toast_bg,
      radius: 3,
      dismissOtherOnShow: true,
      textPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: child,
      duration: DEFAULT_TOAST_DURATION,
    );
  }

  static void waring(String msg, {Duration duration = DEFAULT_TOAST_DURATION, ToastPosition position = ToastPosition.bottom}) {
    Widget widget = Container(
        margin: const EdgeInsets.all(50.0),
        decoration: BoxDecoration(
          color: Colours.toast_warn,
          borderRadius: BorderRadius.circular(3.0),
        ),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.warning, color: Colours.white, size: 25),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ScreenUtil.instance().screenWidth - 160),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5, top: 3),
                      child: Text(msg,
                          strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                          style: TextStyle(fontSize: 15, color: Colours.white))
                  ))
            ]
        )
    );

    showToastWidget(
        widget,
        duration: duration,
        position: position
    );
  }

  static void error(String msg, {Duration duration = DEFAULT_TOAST_DURATION, ToastPosition position = ToastPosition.bottom}) {
    Widget widget = Container(
        margin: const EdgeInsets.all(50.0),
        decoration: BoxDecoration(
          color: Colours.toast_error,
          borderRadius: BorderRadius.circular(3.0),
        ),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.error, color: Colours.white, size: 25),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ScreenUtil.instance().screenWidth - 160),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5, top: 3),
                      child: Text(msg,
                          strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                          style: TextStyle(fontSize: 15, color: Colours.white))
                  ))
            ]
        )
    );

    showToastWidget(
        widget,
        duration: duration,
        position: position
    );
  }

  static void success(String msg, {Duration duration = DEFAULT_TOAST_DURATION, ToastPosition position = ToastPosition.bottom}) {

    Widget widget = Container(
        margin: const EdgeInsets.all(50.0),
        decoration: BoxDecoration(
          color: Colours.toast_success,
          borderRadius: BorderRadius.circular(3.0),
        ),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.check, color: Colours.white, size: 25),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ScreenUtil.instance().screenWidth - 160),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5, top: 3),
                      child: Text(msg,
                          strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                          style: TextStyle(fontSize: 15, color: Colours.white))
                  ))
            ]
        )
    );

    showToastWidget(
        widget,
        duration: duration,
        position: position
    );
  }

  static void normal(String msg, {Duration duration = DEFAULT_TOAST_DURATION, ToastPosition position = ToastPosition.bottom}) {

    Widget widget = Container(
      margin: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        color: Colours.toast_bg,
        borderRadius: BorderRadius.circular(3.0),
        boxShadow: [
          BoxShadow(
            color: Colours.toast_shadow_dark,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colours.toast_shadow_light,
            offset: Offset(0.0, 2.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: ClipRect(
        child: Text(
          msg,
          strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
          style: TextStyle(fontSize: 15, color: Colours.text_black),
        ),
      ),
    );


    showToastWidget(
        widget,
        duration: duration,
        position: position
    );
  }

  static void cancelToast() {
    dismissAllToast();
  }
}
