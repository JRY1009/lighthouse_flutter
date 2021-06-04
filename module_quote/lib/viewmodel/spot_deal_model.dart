

import 'dart:async';

import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_quote/model/latest_deal.dart';

class SpotDealModel extends ViewStateModel {

  StreamSubscription quoteSubscription;

  List<LatestDeal> dealList = [];

  SpotDealModel() : super(viewState: ViewState.first);

  void listenEvent() {
    quoteSubscription?.cancel();

    quoteSubscription = Event.eventBus.on<WsEvent>().listen((event) {
      QuoteWs quoteWs = event.quoteWs;
      if (quoteWs == null) {
        return;
      }
    });
  }

  Future getLatestDeal() {
    Map<String, dynamic> params = {
    };

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_GLOBAL_QUOTE, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          dealList = LatestDeal.fromJsonList(data) ?? [];

          if (ObjectUtil.isEmptyList(dealList)) {
            setEmpty();
          } else {
            setSuccess();
          }
        },
        onError: (errno, msg) {
          setError(errno, message: msg);
        });
  }

}
