

import 'dart:async';

import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/model/quote_pair.dart';
import 'package:module_quote/model/global_quote.dart';

class GlobalQuoteModel extends ViewStateModel {

  QuotePair btcUsdPair;
  QuotePair ethUsdPair;

  StreamSubscription quoteSubscription;

  List<GlobalQuote> quoteList = [];

  GlobalQuoteModel() : super(viewState: ViewState.first);

  void listenEvent() {
    quoteSubscription?.cancel();

    quoteSubscription = Event.eventBus.on<WsEvent>().listen((event) {
      QuoteWs quoteWs = event.quoteWs;
      if (quoteWs == null) {
        return;
      }

      if (quoteWs.coin_code == 'btc' && btcUsdPair != null) {
        btcUsdPair.quote = quoteWs.quote;
        btcUsdPair.change_amount = quoteWs.change_amount;
        btcUsdPair.change_percent = quoteWs.change_percent;

      } else if (quoteWs.coin_code == 'eth' && ethUsdPair != null) {
        ethUsdPair.quote = quoteWs.quote;
        ethUsdPair.change_amount = quoteWs.change_amount;
        ethUsdPair.change_percent = quoteWs.change_percent;
      }

      notifyListeners();
    });
  }

  Future getGlobalAll() async {

    await Future.wait<dynamic>([
      getHome(Apis.COIN_BITCOIN),
      getHome(Apis.COIN_ETHEREUM),
      getGlobalQuote()
    ]);

    setIdle();
  }

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

  Future getHome(chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_HOME, "get", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          if (chain == Apis.COIN_BITCOIN) {
            btcUsdPair = QuotePair.fromJson(data);
            btcUsdPair.coin_code = 'BTC';
            btcUsdPair.chain = Apis.COIN_BITCOIN;

          } else if (chain == Apis.COIN_ETHEREUM) {
            ethUsdPair = QuotePair.fromJson(data);
            ethUsdPair.coin_code = 'ETH';
            ethUsdPair.chain = Apis.COIN_ETHEREUM;
          }
        },
        onError: (errno, msg) {
        });

  }
}
