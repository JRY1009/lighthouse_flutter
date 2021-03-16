
import 'dart:io';
import 'package:flutter/foundation.dart';

class DeviceUtil {
  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);
  static bool get isMobile => isAndroid || isIOS;
  static bool get isWeb => kIsWeb;

  static bool get isWindows => (defaultTargetPlatform == TargetPlatform.windows);
  static bool get isLinux => (defaultTargetPlatform == TargetPlatform.linux);
  static bool get isMacOS => (defaultTargetPlatform == TargetPlatform.macOS);
  static bool get isAndroid => (defaultTargetPlatform == TargetPlatform.android);
  static bool get isFuchsia => (defaultTargetPlatform == TargetPlatform.fuchsia);
  static bool get isIOS => (defaultTargetPlatform == TargetPlatform.iOS);

//  static bool get isWindows => Platform.isWindows;
//  static bool get isLinux => Platform.isLinux;
//  static bool get isMacOS => Platform.isMacOS;
//  static bool get isAndroid => Platform.isAndroid;
//  static bool get isFuchsia => Platform.isFuchsia;
//  static bool get isIOS => Platform.isIOS;

}