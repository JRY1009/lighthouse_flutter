

import 'package:flutter/material.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class AppAnalysis extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (previousRoute != null && previousRoute.settings.name != null) {
      UmengCommonSdk.onPageEnd(previousRoute.settings.name!);
    }

    if (route != null && route.settings.name != null) {
      UmengCommonSdk.onPageStart(route.settings.name!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (route != null && route.settings.name != null) {
      UmengCommonSdk.onPageEnd(route.settings.name!);
    }

    if (previousRoute != null && previousRoute.settings.name != null) {
      UmengCommonSdk.onPageStart(previousRoute.settings.name!);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (oldRoute != null && oldRoute.settings.name != null) {
      UmengCommonSdk.onPageEnd(oldRoute.settings.name!);
    }

    if (newRoute != null && newRoute.settings.name != null) {
      UmengCommonSdk.onPageStart(newRoute.settings.name!);
    }
  }
}