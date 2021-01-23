

import 'dart:async';

import 'package:lighthouse/mvvm/view_state.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/global_quote.dart';
import 'package:lighthouse/utils/object_util.dart';

class GlobalQuoteModel extends ViewStateModel {

  List<GlobalQuote> quoteList = [];

  GlobalQuoteModel() : super(viewState: ViewState.first);

  Future getGlobalQuote() {
    Map<String, dynamic> params = {
    };

    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_GLOBAL_QUOTE, 'get', params: params,
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
