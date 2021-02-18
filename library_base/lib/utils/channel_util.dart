
import 'package:flutter/services.dart';

class ChannelUtil {
  static const MethodChannel _kChannel = MethodChannel('fblock.lighthouse/methodchannel');

  static Future<String> getChannel() async {
    var result = await _kChannel.invokeMethod('getChannel');
    return result;
  }
}