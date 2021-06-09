import 'dart:convert';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:library_base/constant/app_config.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/global/rt_account.dart';
import 'package:library_base/net/base/base_entity.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/http_error.dart';
import 'package:library_base/net/intercept.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/toast_util.dart';

class DioUtil {

  static const String _TAG = "DioUtil";
  //写一个单例
  //在 Dart 里，带下划线开头的变量是私有变量
  static DioUtil? _instance;

  static DioUtil? getInstance() {
    if (_instance == null) {
      _instance = DioUtil();
    }
    return _instance;
  }

  Dio dio = new Dio();

  DioUtil() {
    dio.options.baseUrl = AppConfig.env.apiUrl;
    dio.options.contentType = ContentType.parse("application/json;charset=UTF-8").toString();
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 5000;
    dio.interceptors.add(AuthInterceptor());
    //dio.interceptors.add(LogInterceptor(request:false, requestHeader:false, responseHeader: false, responseBody: false)); //是否开启请求日志
  }

  Map<String, dynamic> parseData(String data) {
    return json.decode(data) as Map<String, dynamic>;
  }

  Future<BaseEntity<T>> _request<T>(String url, String method, {
    Map<String, dynamic>? params,
    dynamic data,
    CancelToken? cancelToken}) async {

    Response? response;
    try {
      if (method == 'get') {
        if (params != null) {
          response = await dio.get(url, queryParameters: params, cancelToken: cancelToken);
        } else {
          response = await dio.get(url, cancelToken: cancelToken);
        }
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, queryParameters: params, data: data, cancelToken: cancelToken);
        } else {
          response = await dio.post(url, data: data, cancelToken: cancelToken);
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
        Apis.ERRNO: httpError.code,
        Apis.MESSAGE: httpError.message,
      });

    } catch (e, s) {
      LogUtil.e("未知异常：$e\n$s", tag: _TAG);
      return BaseEntity<T>.fromJson({
        Apis.ERRNO: Apis.ERRNO_UNKNOWN,
        Apis.MESSAGE: Apis.ERRNO_UNKNOWN_MESSAGE,
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
        Apis.ERRNO: Apis.ERRNO_UNKNOWN,
        Apis.MESSAGE: Apis.ERRNO_UNKNOWN_MESSAGE,
      });
    }
  }

  Future requestNetwork<T>(String url, String method, {
    Map<String, dynamic>? params,
    dynamic data,
    Function(T? data)? onSuccess,
    Function(String? errno, String? msg)? onError,
    CancelToken? cancelToken
  }) {
    dio.options.baseUrl = AppConfig.env.apiUrl;

    return _request<T>(url, method,
      params: params,
      data: data,
      cancelToken: cancelToken,

    ).then<void>((BaseEntity<T> result) {

      if (result.errno == Apis.ERRNO_OK) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        if (result.errno == Apis.ERRNO_FORBIDDEN) {
          ToastUtil.error(result.msg ?? '');
          RTAccount.instance()!.logout();
        }

        if (onError != null) {
          onError(result.errno, result.msg);
        }
      }
    });
  }


  Future requestArticle<T>(String url, String method, {
    Map<String, dynamic>? params,
    dynamic data,
    Function(T? data)? onSuccess,
    Function(String? errno, String? msg)? onError,
    CancelToken? cancelToken
  }) {
    dio.options.baseUrl = AppConfig.env.articleApiUrl;

    return _request<T>(url, method,
      params: params,
      data: data,
      cancelToken: cancelToken,

    ).then<void>((BaseEntity<T> result) {
      if (result.errno == Apis.ERRNO_OK) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        if (result.errno == Apis.ERRNO_FORBIDDEN) {
          ToastUtil.error(result.msg ?? '');
          RTAccount.instance()!.logout();
        }

        if (onError != null) {
          onError(result.errno, result.msg);
        }
      }
    });
  }

}