import 'dart:async';

import 'package:lighthouse/utils/log_util.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket地址
const String _SOCKET_URL = 'ws://81.70.145.64:8083/gateway/ws';

/// WebSocket状态
enum SocketStatus {
  SocketStatusConnected, // 已连接
  SocketStatusFailed, // 失败
  SocketStatusClosed, // 连接关闭
}

class WebSocketUtil {
  static const String _TAG = "WebSocketUtil";

  /// 单例对象
  static WebSocketUtil _socket;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  WebSocketUtil._();

  static WebSocketUtil instance() {
    if (_socket == null) {
      _socket = new WebSocketUtil._();
    }
    return _socket;
  }
  
  IOWebSocketChannel _webSocket; // WebSocket
  SocketStatus _socketStatus; // socket状态
  num _heartTimes = 3000; // 心跳间隔(毫秒)
  num _reconnectCount = 60; // 重连次数，默认60次
  num _reconnectTimes = 0; // 重连计数器
  Timer _reconnectTimer; // 重连定时器
  Function onError; // 连接错误回调
  Function onOpen; // 连接开启回调
  Function onMessage; // 接收消息回调

  /// 初始化WebSocket
  void initWebSocket({Function onOpen, Function onMessage, Function onError}) {
    this.onOpen = onOpen;
    this.onMessage = onMessage;
    this.onError = onError;
    openSocket();
  }

  /// 开启WebSocket连接
  void openSocket() {
    closeSocket();
    _webSocket = IOWebSocketChannel.connect(_SOCKET_URL);

    LogUtil.v('WebSocket 连接成功:  $_SOCKET_URL', tag: _TAG);
    // 连接成功，返回WebSocket实例
    _socketStatus = SocketStatus.SocketStatusConnected;
    // 连接成功，重置重连计数器
    _reconnectTimes = 0;
    if (_reconnectTimer != null) {
      _reconnectTimer.cancel();
      _reconnectTimer = null;
    }
    onOpen();
    // 接收消息
    _webSocket.stream.listen((data) => webSocketOnMessage(data),
        onError: webSocketOnError,
        onDone: webSocketOnDone
    );
  }

  /// WebSocket接收消息回调
  webSocketOnMessage(data) {
    onMessage(data);
  }

  /// WebSocket关闭连接回调
  webSocketOnDone() {
    LogUtil.v('WebSocket OnDone', tag: _TAG);
    reconnect();
  }

  /// WebSocket连接错误回调
  webSocketOnError(e) {
    WebSocketChannelException ex = e;
    _socketStatus = SocketStatus.SocketStatusFailed;

    LogUtil.v('WebSocket OnError: '+ ex.message, tag: _TAG);

    onError(ex.message);
    closeSocket();
  }

  /// 关闭WebSocket
  void closeSocket() {
    if (_webSocket != null) {
      LogUtil.v('WebSocket 连接关闭', tag: _TAG);
      _webSocket.sink.close();
      _socketStatus = SocketStatus.SocketStatusClosed;
    }
  }

  /// 发送WebSocket消息
  void sendMessage(message) {
    if (_webSocket != null) {
      switch (_socketStatus) {
        case SocketStatus.SocketStatusConnected:
          LogUtil.v('WebSocket 发送中:' + message, tag: _TAG);
          _webSocket.sink.add(message);
          break;
        case SocketStatus.SocketStatusClosed:
          LogUtil.v('WebSocket 连接已关闭', tag: _TAG);
          print('');
          break;
        case SocketStatus.SocketStatusFailed:
          LogUtil.v('WebSocket 发送失败', tag: _TAG);
          break;
        default:
          break;
      }
    }
  }

  /// 重连机制
  void reconnect() {
    if (_reconnectTimes < _reconnectCount) {
      _reconnectTimes++;
      _reconnectTimer = new Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
        openSocket();
      });
    } else {
      if (_reconnectTimer != null) {
        LogUtil.v('WebSocket 重连次数超过最大次数', tag: _TAG);
        _reconnectTimer.cancel();
        _reconnectTimer = null;
      }
      return;
    }
  }
}
