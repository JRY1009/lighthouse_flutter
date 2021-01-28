

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/quote_coin.dart';
import 'package:library_base/utils/object_util.dart';

class SpotDetailModel extends ViewStateModel {

  QuoteCoin quoteCoin;

  List<GlobalKey<BasePageMixin>> keyList = [];

  StreamSubscription quoteSubscription;

  SpotDetailModel(List<String> titles)
      : super(viewState: ViewState.first) {

    if (ObjectUtil.isNotEmpty(titles)) {
      titles.forEach((element) {
        keyList.add(GlobalKey<BasePageMixin>(debugLabel: element));
      });
    }
  }

  void listenEvent() {
    quoteSubscription?.cancel();

    quoteSubscription = Event.eventBus.on<WsEvent>().listen((event) {
      QuoteWs quoteWs = event.quoteWs;
      if (quoteWs == null) {
        return;
      }

      if (quoteCoin != null && quoteWs.coin_code.toLowerCase() == quoteCoin.coin_code.toLowerCase()) {
        quoteCoin.quote = quoteWs.quote;
      }

      notifyListeners();
    });
  }

  Future getSpotDetail(String chain) async {

    await Future.wait<dynamic>([
      getCoinQuote(chain),
    ]);

    setIdle();
  }

  Future getSpotDetailWithChild(String chain, int index) async {

    await Future.wait<dynamic>([
      getCoinQuote(chain),

      keyList[index] != null ?
      keyList[index]?.currentState.refresh(slient: true) :
      Future.value(),
    ]);

    setIdle();
  }


  Future getCoinQuote(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance().requestNetwork(Constant.URL_GET_COIN_QUOTE, "get", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          quoteCoin = QuoteCoin.fromJson(data);
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
