

import 'package:flutter/material.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:fl_umeng/fl_umeng.dart';

class AppAnalysis extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (previousRoute != null && previousRoute.settings.name != null) {
      onPageEndWithUM(previousRoute.settings.name!);
    }

    if (route != null && route.settings.name != null) {
      onPageStartWithUM(route.settings.name!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (route != null && route.settings.name != null) {
      onPageEndWithUM(route.settings.name!);
    }

    if (previousRoute != null && previousRoute.settings.name != null) {
      onPageStartWithUM(previousRoute.settings.name!);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (oldRoute != null && oldRoute.settings.name != null) {
      onPageEndWithUM(oldRoute.settings.name!);
    }

    if (newRoute != null && newRoute.settings.name != null) {
      onPageStartWithUM(newRoute.settings.name!);
    }
  }
}