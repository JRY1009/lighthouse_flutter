

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
import 'package:library_base/utils/object_util.dart';
import 'package:library_kchart/entity/k_line_entity.dart';
import 'package:module_home/model/quote_coin.dart';

class SpotDetailModel extends ViewStateModel {

  SpotHeaderModel spotHeaderModel;
  QuoteCoin quoteCoin;
  QuoteCoin lastQuoteCoin;

  List<GlobalKey<BasePageMixin>> keyList = [];

  StreamSubscription quoteSubscription;

  SpotDetailModel(List<String> titles)
      : super(viewState: ViewState.first) {

    spotHeaderModel = SpotHeaderModel();
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
        quoteCoin.change_percent = quoteWs.change_percent_24hr;

        if (lastQuoteCoin != null) {
          lastQuoteCoin.quote = quoteWs.quote;
          lastQuoteCoin.change_percent = quoteWs.change_percent_24hr;
        }
      }

      notifyListeners();
    });
  }

  void handleKLineLongPress(KLineEntity entity) {
    if (quoteCoin == null) {
      return;
    }

    if (entity == null) {
      if (lastQuoteCoin != null) {
        quoteCoin.quote = lastQuoteCoin.quote;
        quoteCoin.change_percent = lastQuoteCoin.change_percent;
      }
    } else {
      quoteCoin.quote = entity.close;
    }

    spotHeaderModel.notifyListeners();
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

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_COIN_QUOTE, "get", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          quoteCoin = QuoteCoin.fromJson(data);
          lastQuoteCoin = QuoteCoin.fromJson(data);
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

class SpotHeaderModel extends ViewStateModel {

  SpotHeaderModel()
      : super(viewState: ViewState.first) {

  }

}