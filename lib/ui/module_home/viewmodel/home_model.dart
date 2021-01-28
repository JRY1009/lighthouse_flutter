

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
import 'package:library_base/net/model/quote_pair.dart';

class HomeModel extends ViewStateModel {

  static const String COIN_BITCOIN = 'bitcoin';
  static const String COIN_ETHEREUM = 'ethereum';

  QuotePair btcUsdPair;
  QuotePair ethUsdPair;

  GlobalKey<BasePageMixin> milestonePageKey = GlobalKey<BasePageMixin>();
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

      } else if (quoteWs.coin_code == 'eth' && ethUsdPair != null) {
        ethUsdPair.quote = quoteWs.quote;
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

      milestonePageKey.currentState.refresh(slient: true),
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
            btcUsdPair.coin_code = HomeModel.COIN_BITCOIN;

          } else if (chain == HomeModel.COIN_ETHEREUM) {
            ethUsdPair = QuotePair.fromJson(data);
            ethUsdPair.coin_code = HomeModel.COIN_ETHEREUM;
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
