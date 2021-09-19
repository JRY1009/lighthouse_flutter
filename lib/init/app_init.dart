import 'dart:async';
import 'dart:io';

//import 'package:dokit/dokit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/device_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/path_util.dart';
import 'default_app.dart';

//应用初始化
class AppInit {

  static Future<void> run() async {

    if (DeviceUtil.isAndroid) {
      // DoKit.runApp(
      //     appCreator: () async => DoKitApp(await DefaultApp.getApp()),
      //     useInRelease: true,
      //     exceptionCallback: (obj, trace) {
      //       var details = makeDetails(obj, trace);
      //       reportErrorAndLog(details);
      //     });

      catchException(() => DefaultApp.run());
    } else {
      //捕获异常
      catchException(() => DefaultApp.run());
    }
  }

  ///异常捕获处理
  static void catchException<T>(T callback()) {
    //捕获异常的回调
    FlutterError.onError = (FlutterErrorDetails details) {
      reportErrorAndLog(details);
    };
    runZoned<Future<Null>>(
      () async {
        callback();
      },
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          collectLog(parent, zone, line); // 收集日志
        },
      ),
      //未捕获的异常的回调
      onError: (Object obj, StackTrace stack) {
        var details = makeDetails(obj, stack);
        reportErrorAndLog(details);
      },
    );
  }

  //日志拦截, 收集日志
  static void collectLog(ZoneDelegate parent, Zone zone, String line) {
    parent.print(zone, "$line");
  }

  //上报错误和日志逻辑
  static void reportErrorAndLog(FlutterErrorDetails details) {
    print(details);
    saveErrorToFile(details.toString());

    if (DeviceUtil.isMobile && Constant.isReleaseMode) {
      FlutterBugly.uploadException(
          message: details.exception.toString(),
          detail: details.stack.toString());
    }
  }

  static Future<void> saveErrorToFile(String error) async {
    if (!DeviceUtil.isMobile) {
      return null;
    }

    String? dirPath = '';
    if (DeviceUtil.isIOS) {
      dirPath = await PathUtils.getCacheDirPath();
      if (ObjectUtil.isEmpty(dirPath)) {
        return null;
      }
    } else {
      dirPath = await PathUtils.getExternalCacheDirPath();
      if (ObjectUtil.isEmpty(dirPath)) {
        return null;
      }
    }

    Directory? crashDir = PathUtils.createDirSync('$dirPath/crash');
    String? crashDirPath = crashDir?.path;
    if (ObjectUtil.isEmpty(dirPath)) {
      return null;
    }

    String fileName = 'crash_' + DateUtil.getNowDateStr()!.replaceAll(' ', '_') + '.txt';

    File file = new File('$crashDirPath/$fileName');
    if (!file.existsSync()) {
      file.createSync();
    }

    file.writeAsString(error);
  }

  // 构建错误信息
  static FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
    return FlutterErrorDetails(exception: obj, stack: stack);
  }
}
