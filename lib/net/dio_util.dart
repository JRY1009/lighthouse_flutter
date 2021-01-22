import 'dart:convert';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lighthouse/net/base_entity.dart';
import 'package:lighthouse/net/base_list_entity.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/http_error.dart';
import 'package:lighthouse/net/intercept.dart';
import 'package:lighthouse/net/rt_account.dart';
import 'package:lighthouse/utils/log_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class DioUtil {

  static const String _TAG = "DioUtil";
  //写一个单例
  //在 Dart 里，带下划线开头的变量是私有变量
  static DioUtil _instance;

  static DioUtil getInstance() {
    if (_instance == null) {
      _instance = DioUtil();
    }
    return _instance;
  }

  Dio dio = new Dio();

  DioUtil() {
    dio.options.baseUrl = Constant.BASE_URL_YAPI;
    dio.options.contentType = ContentType.parse("application/json;charset=UTF-8").toString();
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 5000;
    dio.interceptors.add(AuthInterceptor());
    //dio.interceptors.add(LogInterceptor(request:false, requestHeader:false, responseHeader: false, responseBody: false)); //是否开启请求日志
  }

//get请求
  Future get(String url, {Map<String, dynamic> params, Function successCallBack,
      Function errorCallBack, CancelToken cancelToken}) async {
    return _requstHttp(url, successCallBack, 'get', params, errorCallBack, cancelToken);
  }

  //post请求
  Future post(String url, {Map<String, dynamic> params, Function successCallBack,
      Function errorCallBack, CancelToken cancelToken}) async {
    return _requstHttp(url, successCallBack, "post", params, errorCallBack, cancelToken);
  }

  //post请求
  Future postNoParams(
      String url, {Function successCallBack, Function errorCallBack, CancelToken cancelToken}) async {
    return _requstHttp(url, successCallBack, "post", null, errorCallBack, cancelToken);
  }

  Future _requstHttp(String url, Function successCallBack,
      [String method, Map<String, dynamic> params, Function errorCallBack, CancelToken cancelToken]) async {

    Response response;
    try {
      if (method == 'get') {
        if (params != null) {
          response = await dio.get(url, queryParameters: params, cancelToken: cancelToken);
        } else {
          response = await dio.get(url, cancelToken: cancelToken);
        }
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, queryParameters: params, cancelToken: cancelToken);
        } else {
          response = await dio.post(url, cancelToken: cancelToken);
        }
      }

    } on DioError catch (e, s) {

      LogUtil.v("请求出错：$e\n$s");
      LogUtil.e('请求异常: $e\n$s', tag: _TAG);

      HttpError httpError = HttpError.dioError(e);

      Map<String, dynamic> dataMap = {
        Constant.ERRNO: httpError.code,
        Constant.MESSAGE: httpError.message,
      };

      if (errorCallBack != null) {
        errorCallBack(dataMap);
      }

      return dataMap;

    } catch (e, s) {

      LogUtil.e("未知异常：$e\n$s", tag: _TAG);

      Map<String, dynamic> dataMap = {
        Constant.ERRNO: Constant.ERRNO_UNKNOWN,
        Constant.MESSAGE: Constant.ERRNO_UNKNOWN_MESSAGE,
      };

      if (errorCallBack != null) {
        errorCallBack(dataMap);
      }

      return dataMap;
    }

    // debug模式打印相关数据
    LogUtil.v('请求url: ' + url, tag: _TAG);
    if (params != null) { LogUtil.v('请求参数: ' + params.toString(), tag: _TAG); }
    if (response != null) { LogUtil.v('返回值: ' + response.toString(), tag: _TAG); }

    String jsonString = json.encode(response?.data);
    Map<String, dynamic> dataMap = json.decode(jsonString);

    if (dataMap == null) {
      dataMap = {
        Constant.ERRNO: Constant.ERRNO_UNKNOWN,
        Constant.MESSAGE: Constant.ERRNO_UNKNOWN_MESSAGE,
      };

      if (errorCallBack != null) {
        errorCallBack(dataMap);
      }
    } else if (dataMap[Constant.ERRNO] != Constant.ERRNO_OK) {

      if (dataMap[Constant.ERRNO] == Constant.ERRNO_FORBIDDEN) {
        ToastUtil.error(dataMap[Constant.MESSAGE]);
        RTAccount.instance().logout();
      }

      if (errorCallBack != null) {
        errorCallBack(dataMap);
      }
    } else {
      if (successCallBack != null) {
        successCallBack(dataMap, response.headers);
      }
    }
    return dataMap;
  }

  Map<String, dynamic> parseData(String data) {
    return json.decode(data) as Map<String, dynamic>;
  }

  Future<BaseEntity<T>> _request<T>(String url, String method, {Map<String, dynamic> params, CancelToken cancelToken, Function successCallBack, Function errorCallBack}) async {
    Response response;
    try {
      if (method == 'get') {
        if (params != null) {
          response = await dio.get(url, queryParameters: params, cancelToken: cancelToken);
        } else {
          response = await dio.get(url, cancelToken: cancelToken);
        }
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, queryParameters: params, cancelToken: cancelToken);
        } else {
          response = await dio.post(url, cancelToken: cancelToken);
        }
      }

      // debug模式打印相关数据
      LogUtil.v('请求url: ' + url, tag: _TAG);
      if (params != null) { LogUtil.v('请求参数: ' + params.toString(), tag: _TAG); }
      if (response != null) { LogUtil.v('返回值: ' + response.toString(), tag: _TAG); }

    } on DioError catch (e, s) {
      LogUtil.e('请求异常: $e\n$s', tag: _TAG);
      HttpError httpError = HttpError.dioError(e);
      return BaseEntity<T>.fromJson({
        Constant.ERRNO: httpError.code,
        Constant.MESSAGE: httpError.message,
      });

    } catch (e, s) {
      LogUtil.e("未知异常：$e\n$s", tag: _TAG);
      return BaseEntity<T>.fromJson({
        Constant.ERRNO: Constant.ERRNO_UNKNOWN,
        Constant.MESSAGE: Constant.ERRNO_UNKNOWN_MESSAGE,
      });
    }

    try {
      String jsonString = json.encode(response?.data);
      /// 集成测试无法使用 isolate https://github.com/flutter/flutter/issues/24703
      /// 使用compute条件：数据大于10KB（粗略使用10 * 1024）且当前不是集成测试（后面可能会根据Web环境进行调整）
      /// 主要目的减少不必要的性能开销
      final bool isCompute = !Constant.isDriverTest && jsonString.length > 10 * 1024;
      final Map<String, dynamic> dataMap = isCompute ? await compute(parseData, jsonString) : parseData(jsonString);
      return BaseEntity<T>.fromJson(dataMap);

    } catch(e) {
      LogUtil.e("数据解析错误：$e\n", tag: _TAG);
      return BaseEntity<T>.fromJson({
        Constant.ERRNO: Constant.ERRNO_UNKNOWN,
        Constant.MESSAGE: Constant.ERRNO_UNKNOWN_MESSAGE,
      });
    }
  }

  Future requestNetwork<T>(String url, String method, {
    Map<String, dynamic> params,
    Function(T data) onSuccess,
    Function(String errno, String msg) onError,
    CancelToken cancelToken
  }) {
    return _request<T>(url, method,
      params: params,
      cancelToken: cancelToken,

    ).then<void>((BaseEntity<T> result) {

      if (result.errno == Constant.ERRNO_OK) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        if (result.errno == Constant.ERRNO_FORBIDDEN) {
          ToastUtil.error(result.msg);
          RTAccount.instance().logout();
        }

        if (onError != null) {
          onError(result.errno, result.msg);
        }
      }
    });
  }

  Future<BaseListEntity<T>> _requestList<T>(String url, String method, {Map<String, dynamic> params, CancelToken cancelToken}) async {
    Response response;
    try {
      if (method == 'get') {
        if (params != null) {
          response = await dio.get(url, queryParameters: params, cancelToken: cancelToken);
        } else {
          response = await dio.get(url, cancelToken: cancelToken);
        }
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, queryParameters: params, cancelToken: cancelToken);
        } else {
          response = await dio.post(url, cancelToken: cancelToken);
        }
      }

    } on DioError catch (e, s) {
      LogUtil.e('请求异常: $e\n$s', tag: _TAG);
      HttpError httpError = HttpError.dioError(e);
      return BaseListEntity<T>.fromJson({
        Constant.ERRNO: httpError.code,
        Constant.MESSAGE: httpError.message,
      });

    } catch (e, s) {
      LogUtil.e("未知异常：$e\n$s", tag: _TAG);
      return BaseListEntity<T>.fromJson({
        Constant.ERRNO: Constant.ERRNO_UNKNOWN,
        Constant.MESSAGE: Constant.ERRNO_UNKNOWN_MESSAGE,
      });
    }

    try {
      String jsonString = json.encode(response?.data);
      /// 集成测试无法使用 isolate https://github.com/flutter/flutter/issues/24703
      /// 使用compute条件：数据大于10KB（粗略使用10 * 1024）且当前不是集成测试（后面可能会根据Web环境进行调整）
      /// 主要目的减少不必要的性能开销
      final bool isCompute = !Constant.isDriverTest && jsonString.length > 10 * 1024;
      final Map<String, dynamic> dataMap = isCompute ? await compute(parseData, jsonString) : parseData(jsonString);
      return BaseListEntity<T>.fromJson(dataMap);

    } catch(e) {
      LogUtil.e("数据解析错误：$e\n", tag: _TAG);
      return BaseListEntity<T>.fromJson({
        Constant.ERRNO: Constant.ERRNO_UNKNOWN,
        Constant.MESSAGE: Constant.ERRNO_UNKNOWN_MESSAGE,
      });
    }
  }

  Future requestListNetwork<T>(String url, String method, {
    Map<String, dynamic> params,
    Function(List<T> data) onSuccess,
    Function(String errno, String msg) onError,
    CancelToken cancelToken
  }) {
    return _requestList<T>(url, method,
      params: params,
      cancelToken: cancelToken,

    ).then<void>((BaseListEntity<T> result) {

      if (result.errno == Constant.ERRNO_OK) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        if (result.errno == Constant.ERRNO_FORBIDDEN) {
          ToastUtil.error(result.msg);
          RTAccount.instance().logout();
        }

        if (onError != null) {
          onError(result.errno, result.msg);
        }
      }
    });
  }

}