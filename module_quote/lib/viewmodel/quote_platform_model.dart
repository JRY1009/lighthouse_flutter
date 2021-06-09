

import 'dart:async';

import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_quote/model/quote_platform.dart';

enum PlatformSortState {
  NORMAL,
  PRICE_ASCEND, //升序
  PRICE_DESCEND,  //降序
  RATE_ASCEND, //升序
  RATE_DESCEND,  //降序
}

class QuotePlatformModel extends ViewStateModel {

  QuotePlatformBasic? platformBasic;
  List<QuotePlatformPair> platformPairList = [];

  StreamSubscription? indexSubscription;

  PlatformSortState sortState = PlatformSortState.NORMAL;

  QuotePlatformModel() : super(viewState: ViewState.first);

  //state 0 priceClicked，1 rateClicked
  void changeSortState(int state) {
    if (state == 0) {
      if (sortState == PlatformSortState.NORMAL || sortState == PlatformSortState.RATE_ASCEND || sortState == PlatformSortState.RATE_DESCEND) {
        sortState = PlatformSortState.PRICE_ASCEND;
      } else if (sortState == PlatformSortState.PRICE_ASCEND) {
        sortState = PlatformSortState.PRICE_DESCEND;
      } else if (sortState == PlatformSortState.PRICE_DESCEND) {
        sortState = PlatformSortState.NORMAL;
      }
    } else if (state == 1) {
      if (sortState == PlatformSortState.NORMAL || sortState == PlatformSortState.PRICE_ASCEND || sortState == PlatformSortState.PRICE_DESCEND) {
        sortState = PlatformSortState.RATE_ASCEND;
      } else if (sortState == PlatformSortState.RATE_ASCEND) {
        sortState = PlatformSortState.RATE_DESCEND;
      } else if (sortState == PlatformSortState.RATE_DESCEND) {
        sortState = PlatformSortState.NORMAL;
      }
    }

    notifyListeners();
  }

  List<QuotePlatformPair> getSortedList() {

    List<QuotePlatformPair> sortedList = [];
    sortedList.addAll(platformPairList);

    sortedList.sort((a, b) {
      if (sortState == PlatformSortState.NORMAL) {
        return 0;
      } else if (sortState == PlatformSortState.PRICE_ASCEND) {
        if (a.quote! > b.quote!) {
          return 1;
        } else if (a.quote! < b.quote!) {
          return -1;
        }

      } else if (sortState == PlatformSortState.PRICE_DESCEND) {
        if (a.quote! > b.quote!) {
          return -1;
        } else if (a.quote! < b.quote!) {
          return 1;
        }

      } else if (sortState == PlatformSortState.RATE_ASCEND) {
        if (a.change_percent! > b.change_percent!) {
          return -1;
        } else if (a.change_percent! < b.change_percent!) {
          return 1;
        }

      } else if (sortState == PlatformSortState.RATE_DESCEND) {
        if (a.change_percent! > b.change_percent!) {
          return 1;
        } else if (a.change_percent! < b.change_percent!) {
          return -1;
        }
      }

      return 0;
    });

    return sortedList;
  }

  void listenEvent() {
    indexSubscription?.cancel();

//    indexSubscription = Event.eventBus.on<WsEvent>().listen((event) {
//      QuoteWs quoteWs = event.quoteWs;
//      if (quoteWs == null) {
//        return;
//      }
//
//      if (platformBasic != null && quoteWs.coin_code.toLowerCase() == platformBasic.coin_code.toLowerCase()) {
//        platformBasic.quote = quoteWs.quote;
//        platformBasic.change_percent = quoteWs.change_percent_24hr;
//
//        notifyListeners();
//      }
//    });
  }

  Future getPlatformQuote(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_GET_CHAIN_QUOTE, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          platformBasic = QuotePlatformBasic.fromJson(data);
          platformPairList = platformBasic?.exchange_quote_list ?? [];

          if (ObjectUtil.isEmptyList(platformPairList)) {
            setEmpty();
          } else {
            setSuccess();
          }
        },
        onError: (errno, msg) {
          setError(errno!, message: msg);
        });
  }

  @override
  void dispose() {
    indexSubscription?.cancel();
    super.dispose();
  }
}
