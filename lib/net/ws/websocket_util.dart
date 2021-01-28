import 'package:flutter/foundation.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:web_socket_channel/io.dart';

var sockets = new WebSocketUtil();

class WebSocketUtil {
  static const String _TAG = "WebSocketUtil";

  static final WebSocketUtil _webSocketUtil = new WebSocketUtil._internal();
  bool _isConnect = false;
  IOWebSocketChannel _channel;
  ObserverList<Function> _webSocketListeners = new ObserverList<Function>();
  WebSocketUtil._internal();

//  工厂构造函数，确保返回单例
  factory WebSocketUtil() {
    return _webSocketUtil;
  }

//  初始化webSocket
  void initWebSocket(String wsUrl) {
    closed();
    _channel = IOWebSocketChannel.connect(wsUrl, pingInterval: Duration(milliseconds: 5000));
    _channel.stream.listen(receptionMessage, onError: _onError, onDone: _onDone);
  }

//  关闭webSocket
  closed() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isConnect = false;
      }
    }
  }

//  加入订阅者
  addListener(Function callback) {
    _webSocketListeners.add(callback);
  }

//  删除订阅者
  removeListener(Function callback) {
    _webSocketListeners.remove(callback);
  }

//  删除所有订阅者
  removeAllListener() {
    try {
      for (int i = 0; i < _webSocketListeners.length; i++) {
        removeListener(_webSocketListeners.elementAt(i));
      }
    } catch (e) {
      LogUtil.e('websocket remove all: $e', tag: _TAG);
    }
  }

//  发送消息
  sendMessage(msg) {
    if (_channel != null) {
      if (_channel.sink != null && _isConnect) {
        _channel.sink.add(msg);
      }
    }
  }

//  处理消息，将消息循环发送给订阅者
  receptionMessage(msg) {
    _isConnect = true;
    _webSocketListeners.forEach((Function callback) {
      callback(msg);
    });
  }

//  接收消息发生错误
  _onError(error, StackTrace stackTrace) {
    LogUtil.v('websocket ------- connect error -------', tag: _TAG);
    _webSocketListeners.forEach((Function callback) {
      try {
        callback(error, stackTrace);
      } catch (e) {
        LogUtil.e('websocket onerror: $e', tag: _TAG);
      }
    });
  }

//  webSocket done
  _onDone() {
    LogUtil.v('websocket ------- done -------', tag: _TAG);
  }
}
