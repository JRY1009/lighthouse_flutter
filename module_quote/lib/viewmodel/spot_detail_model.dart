

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:library_base/constant/mock_data.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_coin.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/widget/text/number_slide_animation.dart';
import 'package:library_kchart/entity/k_line_entity.dart';

class SpotDetailModel extends ViewStateModel {

  late SpotKLineHandleModel spotKLineHandleModel;
  late SpotHeaderModel spotHeaderModel;
  late SpotHeaderModel spotAppbarModel;

  QuoteCoin? quoteCoin;
  QuoteCoin? lastQuoteCoin;

  List<GlobalKey<BasePageMixin>> keyList = [];

  NumberSlideController quoteSlideController = NumberSlideController();
  StreamSubscription? quoteSubscription;

  bool _handleKLine = false;

  SpotDetailModel(List<String> titles)
      : super(viewState: ViewState.first) {

    spotKLineHandleModel = SpotKLineHandleModel();
    spotHeaderModel = SpotHeaderModel();
    spotAppbarModel = SpotHeaderModel();

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

      if (quoteCoin != null && quoteWs.coin_code!.toLowerCase() == quoteCoin!.coin_code!.toLowerCase()) {

        if (!_handleKLine) {
          quoteCoin!.quote = quoteWs.quote;
          quoteCoin!.change_amount = quoteWs.change_amount;
          quoteCoin!.change_percent = quoteWs.change_percent;
        }

        if (lastQuoteCoin != null) {
          lastQuoteCoin!.quote = quoteWs.quote;
          lastQuoteCoin!.change_amount = quoteWs.change_amount;
          lastQuoteCoin!.change_percent = quoteWs.change_percent;
        }

        if (!_handleKLine) {
          quoteSlideController.number = NumUtil.formatNum(quoteWs.quote, point: 2);
          spotHeaderModel.notifyListeners();
          spotAppbarModel.notifyListeners();
        }
      }
    });
  }

  void handleKLineLongPress(KLineEntity? entity) {
    if (quoteCoin == null) {
      return;
    }

    if (entity == null) {
      _handleKLine = false;
      if (lastQuoteCoin != null) {
        quoteCoin!.quote = lastQuoteCoin!.quote;
        quoteCoin!.change_amount = lastQuoteCoin!.change_amount;
        quoteCoin!.change_percent = lastQuoteCoin!.change_percent;
      }
    } else {
      _handleKLine = true;
      quoteCoin!.quote = entity.close;
    }
    spotKLineHandleModel.notifyListeners();
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

      keyList[index].currentState!.refresh(slient: true)
    ]);

    setIdle();
  }


  Future getCoinQuote(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_GET_COIN_QUOTE, "get", params: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {
          quoteCoin = QuoteCoin.fromJson(data);
          lastQuoteCoin = QuoteCoin.fromJson(data);
        },
        onError: (errno, msg) {
          if (chain == Apis.COIN_BITCOIN) {
            quoteCoin = mock_btccoin;
            lastQuoteCoin = mock_btccoin;
          } else if (chain == Apis.COIN_ETHEREUM) {
            quoteCoin = mock_ethcoin;
            lastQuoteCoin = mock_ethcoin;
          }
        });

  }

  @override
  void dispose() {
    quoteSubscription?.cancel();
    quoteSlideController.dispose();
    super.dispose();
  }
}

class SpotKLineHandleModel extends ViewStateModel {

  SpotKLineHandleModel()
      : super(viewState: ViewState.first) {

  }
}

class SpotHeaderModel extends ViewStateModel {

  SpotHeaderModel()
      : super(viewState: ViewState.first) {

  }
}
