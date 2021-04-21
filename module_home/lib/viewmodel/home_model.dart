

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:module_home/model/quote.dart';
import 'package:module_home/model/quote_pair.dart';

class HomeModel extends ViewStateModel {

  static const String COIN_BITCOIN = 'bitcoin';
  static const String COIN_ETHEREUM = 'ethereum';

  QuotePair btcUsdPair;
  QuotePair ethUsdPair;

  GlobalKey<BasePageMixin> communityPageKey = GlobalKey<BasePageMixin>();
  GlobalKey<BasePageMixin> articlePageKey = GlobalKey<BasePageMixin>();

  StreamSubscription quoteSubscription;

  HomeModel() : super(viewState: ViewState.first);

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

        if (btcUsdPair.quote_24h != null || btcUsdPair.quote_24h.length >1) {
          int nowTime = quoteWs.id ?? 0;
          int firstTime = btcUsdPair.quote_24h.first?.id ?? 0;
          int secondTime = btcUsdPair.quote_24h[1]?.id ?? 0;
          int time = firstTime - secondTime;
          int intervalTime = nowTime - firstTime;

          if (intervalTime >= time) {
            Quote quote = Quote(quote: quoteWs.quote);
            quote.setTs(firstTime + time);
            btcUsdPair.quote_24h.insert(0, quote);

          } else {
            btcUsdPair.quote_24h.first?.quote = quoteWs.quote;
          }
        }

      } else if (quoteWs.coin_code == 'eth' && ethUsdPair != null) {
        ethUsdPair.quote = quoteWs.quote;
        ethUsdPair.change_amount = quoteWs.change_amount;
        ethUsdPair.change_percent = quoteWs.change_percent;

        if (ethUsdPair.quote_24h != null || ethUsdPair.quote_24h.length >1) {
          int nowTime = quoteWs.id ?? 0;
          int firstTime = ethUsdPair.quote_24h.first?.id ?? 0;
          int secondTime = ethUsdPair.quote_24h[1]?.id ?? 0;
          int time = firstTime - secondTime;
          int intervalTime = nowTime - firstTime;

          if (intervalTime >= time) {
            Quote quote = Quote(quote: quoteWs.quote);
            quote.setTs(firstTime + time);
            ethUsdPair.quote_24h.insert(0, quote);

          } else {
            ethUsdPair.quote_24h.first?.quote = quoteWs.quote;
          }
        }
      }

      notifyListeners();
    });
  }

  Future getHomeAll() async {

    await Future.wait<dynamic>([
      getHome(COIN_BITCOIN),
      getHome(COIN_ETHEREUM),
    ]);

    setIdle();
  }

  Future getHomeAllWithChild() async {

    await Future.wait<dynamic>([
      getHome(COIN_BITCOIN),
      getHome(COIN_ETHEREUM),

      communityPageKey.currentState.refresh(slient: true),
      articlePageKey.currentState.refresh(slient: true),
    ]);

    setIdle();
  }

  Future getHome(chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_HOME, "get", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          if (chain == HomeModel.COIN_BITCOIN) {
            btcUsdPair = QuotePair.fromJson(data);
            btcUsdPair.coin_code = 'BTC';
            btcUsdPair.chain = HomeModel.COIN_BITCOIN;

          } else if (chain == HomeModel.COIN_ETHEREUM) {
            ethUsdPair = QuotePair.fromJson(data);
            ethUsdPair.coin_code = 'ETH';
            ethUsdPair.chain = HomeModel.COIN_ETHEREUM;
          }
        },
        onError: (errno, msg) {
        });

  }

  @override
  void dispose() {
    quoteSubscription?.cancel();
    super.dispose();
  }
}
