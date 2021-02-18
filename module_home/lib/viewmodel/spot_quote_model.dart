

import 'dart:async';

import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_home/model/spot_exchange_quote.dart';
import 'package:module_home/model/spot_exchange_quote_basic.dart';

class SpotQuoteModel extends ViewStateModel {

  SpotExchangeQuoteBasic quoteBasic;
  List<SpotExchangeQuote> quoteList = [];

  StreamSubscription quoteSubscription;

  SpotQuoteModel() : super(viewState: ViewState.first);

  void listenEvent() {
    quoteSubscription?.cancel();

    quoteSubscription = Event.eventBus.on<WsEvent>().listen((event) {
      QuoteWs quoteWs = event.quoteWs;
      if (quoteWs == null) {
        return;
      }

      if (quoteBasic != null && quoteWs.coin_code.toLowerCase() == quoteBasic.coin_code.toLowerCase()) {
        quoteBasic.quote = quoteWs.quote;
        quoteBasic.change_percent = quoteWs.change_percent_24hr;
      }

      notifyListeners();
    });
  }

  Future getQuote(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_CHAIN_QUOTE, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          quoteBasic = SpotExchangeQuoteBasic.fromJson(data);
          quoteList = quoteBasic?.exchange_quote_list ?? [];

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

  @override
  void dispose() {
    quoteSubscription?.cancel();
    super.dispose();
  }
}
