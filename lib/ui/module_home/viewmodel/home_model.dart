

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lighthouse/event/event.dart';
import 'package:lighthouse/event/ws_event.dart';
import 'package:lighthouse/mvvm/base_page.dart';
import 'package:lighthouse/mvvm/view_state.dart';
import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/quote_basic.dart';
import 'package:lighthouse/net/model/quote_ws.dart';

class HomeModel extends ViewStateModel {

  static const String COIN_BITCOIN = 'bitcoin';
  static const String COIN_ETHEREUM = 'ethereum';

  QuoteBasic btcQuoteBasic;
  QuoteBasic ethQuoteBasic;

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

      if (quoteWs.coin_code == 'btc' && btcQuoteBasic != null) {
        btcQuoteBasic.quote = quoteWs.quote;

      } else if (quoteWs.coin_code == 'eth' && ethQuoteBasic != null) {
        ethQuoteBasic.quote = quoteWs.quote;
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

    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_HOME, "get", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          if (chain == HomeModel.COIN_BITCOIN) {
            btcQuoteBasic = QuoteBasic.fromJson(data);

          } else if (chain == HomeModel.COIN_ETHEREUM) {
            ethQuoteBasic = QuoteBasic.fromJson(data);
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
