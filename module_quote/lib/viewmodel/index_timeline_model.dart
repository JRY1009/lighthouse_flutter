

import 'dart:async';

import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';

class IndexTimelineModel extends ViewStateModel {

  String coinCode;
  List<String> rangeList;
  Map<String, List<Quote>> quoteMap = {};

  StreamSubscription quoteSubscription;

  IndexTimelineModel() :
        super(viewState: ViewState.first) {

    rangeList = ['1h', '24h', '1w', '1m', '1y', 'all'];
  }

  void listenEvent() {
    quoteSubscription?.cancel();

    quoteSubscription = Event.eventBus.on<WsEvent>().listen((event) {
      QuoteWs quoteWs = event.quoteWs;
      if (quoteWs == null) {
        return;
      }

      if ((quoteWs.coin_code == 'btc' && coinCode == Apis.COIN_BITCOIN) ||
          (quoteWs.coin_code == 'eth' && coinCode == Apis.COIN_ETHEREUM)) {

        quoteMap.forEach((key, value) {
          List<Quote> quoteList = value;
          if (quoteList != null && quoteList.length > 1) {
            int nowTime = quoteWs.id ?? 0;
            int firstTime = quoteList.first?.id ?? 0;
            int secondTime = quoteList[1]?.id ?? 0;
            int time = firstTime - secondTime;
            int intervalTime = nowTime - firstTime;

            if (intervalTime >= time) {
              Quote quote = Quote(quote: quoteWs.quote);
              quote.setTs(firstTime + time);
              quoteList.insert(0, quote);

            } else {
              quoteList.first?.quote = quoteWs.quote;
            }

            quoteMap[key] = quoteList;
          }
        });

        notifyListeners();
      }
    });
  }

  List<Quote> getQuoteList(int index) {
    return quoteMap[rangeList[index]];
  }

  Future getQuote(String chain, int index) {
    coinCode = chain;
    Map<String, dynamic> params = {
      'chain': chain,
      'time_range': rangeList[index],
    };

    setBusy();
    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_QUOTE, 'get', params: params,
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

  @override
  void dispose() {
    quoteSubscription?.cancel();
    super.dispose();
  }
}
