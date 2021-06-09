
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/utils/toast_util.dart';

/// 双击返回退出
class DoubleTapBackExitApp extends StatefulWidget {

  const DoubleTapBackExitApp({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 2500),
  }): super(key: key);

  final Widget child;
  /// 两次点击返回按钮的时间间隔
  final Duration duration;

  @override
  _DoubleTapBackExitAppState createState() => _DoubleTapBackExitAppState();
}

class _DoubleTapBackExitAppState extends State<DoubleTapBackExitApp> {

  DateTime?  _lastTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExit,
      child: widget.child,
    );
  }

  Future<bool> _isExit() async {
    if (_lastTime == null || DateTime.now().difference(_lastTime!) > widget.duration) {
      _lastTime = DateTime.now();
      ToastUtil.normal(S.current.doubleTapExit);
      return Future.value(false);
    }
    ToastUtil.cancelToast();
    /// 不推荐使用 `dart:io` 的 exit(0)
    await SystemNavigator.pop();
    return Future.value(true);
  }
}

