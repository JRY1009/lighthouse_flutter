
/// 页面状态类型
enum ViewState {
  idle,
  first, //初始
  busy, //加载中
  empty, //无数据
  error, //加载失败
  success,//加载成功
}

class ViewStateError {
  String message;
  String errno;

  ViewStateError(this.errno, {this.message}) {}

  @override
  String toString() {
    return 'ViewStateError{errno: $errno, message: $message}';
  }
}

//enum ConnectivityStatus { WiFi, Cellular, Offline }
