

import 'dart:async';

import 'package:lighthouse/mvvm/view_state.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/quote.dart';

class SpotKLineModel extends ViewStateModel {

  List<String> rangeList;
  Map<String, List<Quote>> quoteMap = {};

  SpotKLineModel() :
        super(viewState: ViewState.first) {

    rangeList = ['24h', '1w', '1m', '6m', '1y', 'all'];
  }

  List<Quote> getQuoteList(int index) {
    return quoteMap[rangeList[index]];
  }

  Future getQuote(String chain, int index) {
    Map<String, dynamic> params = {
      'chain': chain,
      'time_range': rangeList[index],
    };

    setBusy();
    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_QUOTE, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          List<Quote> quoteList = Quote.fromJsonList(data) ?? [];
          quoteMap[rangeList[index]] = quoteList;

          setIdle();
        },
        onError: (errno, msg) {
          quoteMap[rangeList[index]] = [];
          setError(errno, message: msg);
        });
  }

}
