
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:lighthouse/net/constant.dart';

class JPushUtil {

  static final JPush jpush = new JPush();

  static Future<void> initPlatformState() async {
    String platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            print("flutter onReceiveNotification: $message");
          },
          onOpenNotification: (Map<String, dynamic> message) async {
            print("flutter onOpenNotification: $message");
          },
          onReceiveMessage: (Map<String, dynamic> message) async {
            print("flutter onReceiveMessage: $message");
          },
          onReceiveNotificationAuthorization: (Map<String, dynamic> message) async {
            print("flutter onReceiveNotificationAuthorization: $message");
          });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "045af7241e8847d98c3112e1", //你自己应用的 AppKey
      production: false,
      debug: !Constant.isReleaseMode,
    );

    jpush.applyPushAuthority(new NotificationSettingsIOS(sound: true, alert: true, badge: true));
  }
}
