
import 'package:flutter/services.dart';
import 'package:library_base/event/event.dart';
import 'package:orientation/orientation.dart';
import 'package:rxdart/rxdart.dart';

class OrientationHelper {
  static Future<void> setEnabledSystemUIOverlays(
      List<SystemUiOverlay> overlays) {
    return OrientationPlugin.setEnabledSystemUIOverlays(overlays);
  }

  static Future<void> setPreferredOrientations(
      List<DeviceOrientation> orientations) {
    return OrientationPlugin.setPreferredOrientations(orientations);
  }

  static Future<void> forceOrientation(DeviceOrientation orientation) {
    return OrientationPlugin.forceOrientation(orientation);
  }

  /// [DeviceOrientation.portraitUp] is default.
  static final DeviceOrientation initOrientation = DeviceOrientation.portraitUp;

  static Stream<DeviceOrientation>? _onOrientationChange;

  static Stream<DeviceOrientation>? get onOrientationChange {
    if (_onOrientationChange == null) {
      _onOrientationChange = OrientationPlugin.onOrientationChange
          .shareValueSeeded(initOrientation)
          .distinct((previous, next) => previous == next);
    }
    return _onOrientationChange;
  }
}