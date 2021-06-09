import 'dart:convert';

import 'package:library_base/constant/app_config.dart';
import 'package:library_base/net/ws/websocket_util.dart';
import 'package:library_base/utils/timer_util.dart';

class WsCommunicationUtil {
  static const String _TAG = "WsCommunicationUtil";

  static WsCommunicationUtil? _wsCommunication;
  int _count = 0;
  late TimerUtil timerUtil;

  ///  初始化时启动webSocket连接
  WsCommunicationUtil._internal() {
    sockets.initWebSocket(AppConfig.env.wsUrl);
    sockets.addListener(_onGameDataReceived);
  }

  /// 工厂构造函数返回实例
  factory WsCommunicationUtil() {
    if (_wsCommunication == null) {
      _wsCommunication = WsCommunicationUtil._internal();
    }
    return _wsCommunication!;
  }

  initTimer() {
    // 5秒发送一次ping
    timerUtil = new TimerUtil(mInterval: 5000);
    timerUtil.setOnTimerTickCallback((int? value) {
      print("-----:>ping");
      sendHandle('ping', '123');
      _count++;
      if (_count > 3) {
        // 三次没有接收到pong，需要重连并订阅
        sockets.removeAllListener();
        sockets.initWebSocket(AppConfig.env.wsUrl);
        sockets.addListener(_onGameDataReceived);
      }
    });
  }

  /// timer controller
  startTimer() {
    timerUtil.startTimer();
  }

  cancelTimer() {
    timerUtil.cancel();
  }

  sendHandle(String action, String data) {
    sockets.sendMessage(json.encode({"op": action, "message": data}));
  }

  /// 处理推送信息
  _onGameDataReceived(message) {
    print('_onGameDataReceived -----$message');

    if (message.toString() == "done") {
      return;
    }
    if (message.contains('pong')) {
      print('-----:>pong');
      _count = 0;
      return;
    }
    // 若是连接成功，取消定时器；若是连接失败，启动定时器
    try {
      var result = json.decode(message);
      if (result['result'] != null) {
        if (result['result'] == 'connected') {
          // 业务开发一般会发送用户的token进行身份验证，请确保在connected后才发送
          // sendHandle("login", token));
          _count = 0;
          return;
        }
      }

      switch (result['code']) {
        // 根据业务协议判断code，进行对应操作
        case 1010:
          {
            break;
          }
        case 1012:
          {
            break;
          }
        default:
          {}
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
