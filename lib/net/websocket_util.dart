import 'dart:async';
import 'dart:convert';

import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:web_socket_channel/io.dart';
import 'package:lighthouse/net/constant.dart';


class WebSocketUtil {
  static const String _TAG = "WebSocketUtil";

  static WebSocketUtil _socket;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  WebSocketUtil._();

  static WebSocketUtil instance() {
    if (_socket == null) {
      _socket = new WebSocketUtil._();
    }
    return _socket;
  }

  static void initWS() {

    WebSocketUtil.instance().initWebSocket(
        openCallback: () {

          Map<String, dynamic> params = {
            'op': 'subscribe',
            'group': 'test',
            'message': 'quote.eth,quote.btc',
          };
          WebSocketUtil.instance().sendMessage(json.encode(params));
        },

        messageCallback: (data) {

          Map<String, dynamic> dataMap = json.decode(data);
          if (dataMap != null) {
            QuoteWs quoteWs = QuoteWs.fromJson(dataMap);
            Event.eventBus.fire(WsEvent(quoteWs, WsEventState.quote));
          }
        });
  }

  IOWebSocketChannel _channel; // WebSocket
  bool _isConnect = false;

  num _heartTimes = 10000; // 心跳间隔(毫秒)
  num _rcMaxCount = 60; // 重连次数，默认60次
  num _rcTimes = 0; // 重连计数器
  Timer _rcTimer; // 重连定时器

  Function openCallback; // 连接开启回调
  Function errorCallback; // 连接错误回调
  Function messageCallback; // 接收消息回调

  void initWebSocket({
    Function openCallback,
    Function errorCallback,
    Function messageCallback,
  }) {
    this.openCallback = openCallback;
    this.errorCallback = errorCallback;
    this.messageCallback = messageCallback;
    openSocket();
  }

  /// 开启WebSocket连接
  void openSocket() {

    closed();
    _channel = IOWebSocketChannel.connect(Constant.WEB_SOCKET_URL, pingInterval: Duration(milliseconds: _heartTimes));

    LogUtil.v('websocket connect:  ${Constant.WEB_SOCKET_URL}', tag: _TAG);

    _channel.stream.listen((data) => _onMessage(data),
        onError: _onError,
        onDone: _onDone
    );
  }

  _onMessage(data) {
    if (!_isConnect) {
      _isConnect = true;

      _rcTimes = 0;
      _rcTimer?.cancel();
      _rcTimer = null;

      if (openCallback != null) {
        openCallback();
      }
    }

    LogUtil.v('websocket onmessage:  $data', tag: _TAG);

    if (messageCallback != null) {
      messageCallback(data);
    }
  }

  _onDone() {
    LogUtil.v('websocket done isconnect: $_isConnect', tag: _TAG);
    reconnect();
  }

  /// WebSocket连接错误回调
  _onError(e) {
    LogUtil.v('websocket error: $e', tag: _TAG);

    if (errorCallback != null) {
      errorCallback(e);
    }
    closed();
  }

  /// 关闭WebSocket
  void closed() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isConnect = false;

        LogUtil.v('websocket closed', tag: _TAG);
      }
    }
  }

  void sendMessage(message) {

    if (_channel != null) {
      LogUtil.v('websocket send: $message, isconnect: $_isConnect', tag: _TAG);
      if (_channel.sink != null && _isConnect) {
        _channel.sink.add(message);
      }
    }
  }

  /// 重连机制
  void reconnect() {
    if (_rcTimes < _rcMaxCount) {
      _rcTimes++;

      if (_rcTimer == null) {
        _rcTimer = new Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {

          LogUtil.v('websocket reconnect:  ${Constant.WEB_SOCKET_URL}', tag: _TAG);
          _channel = IOWebSocketChannel.connect(Constant.WEB_SOCKET_URL, pingInterval: Duration(milliseconds: _heartTimes));
          _channel.stream.listen((data) => _onMessage(data),
              onError: _onError,
              onDone: _onDone
          );
        });
      }

    } else {
      LogUtil.v('websocket exceed reconncet limits', tag: _TAG);
      _rcTimer?.cancel();
      _rcTimer = null;
      return;
    }
  }
}
