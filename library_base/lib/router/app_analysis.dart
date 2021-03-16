

import 'package:flutter/material.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class AppAnalysis extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (previousRoute != null && previousRoute.settings.name != null) {
      UmengAnalyticsPlugin.pageEnd(previousRoute.settings.name);
    }

    if (route != null && route.settings.name != null) {
      UmengAnalyticsPlugin.pageStart(route.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (route != null && route.settings.name != null) {
      UmengAnalyticsPlugin.pageEnd(route.settings.name);
    }

    if (previousRoute != null && previousRoute.settings.name != null) {
      UmengAnalyticsPlugin.pageStart(previousRoute.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    if (!DeviceUtil.isMobile) {
      return;
    }

    if (newRoute != null && oldRoute.settings.name != null) {
      UmengAnalyticsPlugin.pageEnd(oldRoute.settings.name);
    }

    if (newRoute != null && newRoute.settings.name != null) {
      UmengAnalyticsPlugin.pageStart(newRoute.settings.name);
    }
  }
}