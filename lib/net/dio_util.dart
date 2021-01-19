import 'dart:convert';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lighthouse/net/constant.dart';
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
    } on DioError catch (error) {
      // 请求错误处理
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 201);
      }

      LogUtil.e('请求异常: ' + error.toString(), tag: _TAG);

      Map<String, dynamic> dataMap = {
        Constant.ERRNO: Constant.ERRNO_DIO_ERROR,
        Constant.MESSAGE: error.message,
      };

      if (errorCallBack != null) {
        errorCallBack(dataMap);
      }

      return dataMap;
    }

    // debug模式打印相关数据
    LogUtil.v('请求url: ' + url, tag: _TAG);
    if (params != null) {
      LogUtil.v('请求参数: ' + params.toString(), tag: _TAG);
    }
    if (response != null) {
      LogUtil.v('返回值: ' + response.toString(), tag: _TAG);
    }

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
}