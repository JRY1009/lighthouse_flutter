

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/widget/shot_view.dart';

/// 本项目通用的布局（SingleChildScrollView）
/// 1.底部存在按钮
/// 2.底部没有按钮
class CommonScrollView extends StatelessWidget {

  /// 注意：同时存在底部按钮与keyboardConfig配置时，为保证软键盘弹出高度正常。需要在`Scaffold`使用 `resizeToAvoidBottomInset: defaultTargetPlatform != TargetPlatform.iOS,`
  /// 除非Android与iOS平台均使用keyboard_actions
  const CommonScrollView({
    Key? key,
    required this.children,
    this.padding,
    this.physics = const BouncingScrollPhysics(),
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.contentAlignment = Alignment.topLeft,
    this.bottomButton,
    this.bottomSafe = true,
    this.keyboardConfig,
    this.tapOutsideToDismiss = false,
    this.overScroll = 16.0,
    this.borderRadius,
    this.shotController
  }): super(key: key);

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final AlignmentGeometry contentAlignment;
  final Widget? bottomButton;
  final bool bottomSafe;
  final KeyboardActionsConfig? keyboardConfig;
  /// 键盘外部按下将其关闭
  final bool tapOutsideToDismiss;
  /// 默认弹起位置在TextField的文字下面，可以添加此属性继续向上滑动一段距离。用来露出完整的TextField。
  final double overScroll;

  final BorderRadius? borderRadius;
  final ShotController? shotController;

  @override
  Widget build(BuildContext context) {

    Widget contents = shotController != null ?
    ShotView(
        controller: shotController!,
        child: Column(
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
    ) : Column(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );

    if (borderRadius != null) {
      contents = ClipRRect(
          borderRadius: borderRadius,
          child: contents
      );
    }

    if (DeviceUtil.isIOS && keyboardConfig != null) {
      /// iOS 键盘处理

      if (padding != null) {
        contents = Padding(
          padding: padding!,
          child: contents
        );
      }

      contents = KeyboardActions(
        isDialog: bottomButton != null,
        overscroll: overScroll,
        config: keyboardConfig!,
        tapOutsideToDismiss: tapOutsideToDismiss,
        child: contents
      );

    } else {
      if (DeviceUtil.isWeb || DeviceUtil.isDesktop) {
        contents = SingleChildScrollView(
          padding: padding,
          physics: physics,
          child: contents,
        );

      } else {
        contents = ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: SingleChildScrollView(
            padding: padding,
            physics: physics,
            child: contents,
          ),
        );
      }
    }

    if (bottomButton != null) {
      contents = Column(
        children: <Widget>[
          Expanded(
              child: Align(
                alignment: contentAlignment,
                child: contents,
              )
          ),

          bottomSafe ?
          SafeArea(
              child: bottomButton!
          ) : bottomButton!
        ],
      );
    }

    return contents;
  }
}

class OverScrollBehavior extends ScrollBehavior{

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          child: child,
          //不显示头部水波纹
          showLeading: false,
          //显示尾部水波纹
          showTrailing: true,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
        );
    }
    return child;
  }

}