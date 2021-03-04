
import 'package:flutter/services.dart';
import 'package:library_base/utils/device_util.dart';

class ChannelUtil {
  static const MethodChannel _kChannel = MethodChannel('fblock.lighthouse/methodchannel');

  static Future<String> getChannel() async {
    if (DeviceUtil.isAndroid) {
      var result = await _kChannel.invokeMethod('getChannel');
      return result;
    } else if (DeviceUtil.isIOS) {
      return 'iOS';
    }
    return 'unknown';
  }
}