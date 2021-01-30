

import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_home/model/global_quote.dart';

class GlobalQuoteModel extends ViewStateModel {

  List<GlobalQuote> quoteList = [];

  GlobalQuoteModel() : super(viewState: ViewState.first);

  Future getGlobalQuote() {
    Map<String, dynamic> params = {
    };

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_GLOBAL_QUOTE, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          quoteList = GlobalQuote.fromJsonList(data) ?? [];

          if (ObjectUtil.isEmptyList(quoteList)) {
            setEmpty();
          } else {
            setSuccess();
          }
        },
        onError: (errno, msg) {
          setError(errno, message: msg);
        });
  }

}
