import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/res/styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshUtil {
  RefreshUtil._internal();

  ///全局初始化Toast配置, child为MaterialApp
  static init(Widget child) {
    return RefreshConfiguration(
      footerBuilder: () => ClassicFooter(
        height: 50,
        textStyle: TextStyles.textGray400_w400_14,
        loadingText: S.current.loading,
        canLoadingText: '',
        noDataText: '',
        idleText: '',
        failedText: '',
        loadingIcon: CupertinoActivityIndicator(),
      ),
      child: child,
    );
  }

}
