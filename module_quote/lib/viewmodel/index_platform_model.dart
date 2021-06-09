

import 'dart:async';

import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_quote/model/quote_index_platform.dart';

enum IndexPlatformSortState {
  NORMAL,
  PRICE_ASCEND, //升序
  PRICE_DESCEND,  //降序
  RATE_ASCEND, //升序
  RATE_DESCEND,  //降序
}

class IndexPlatformModel extends ViewStateModel {

  QuoteIndexPlatformBasic? quoteBasic;
  List<QuoteIndexPlatform> quoteList = [];

  StreamSubscription? quoteSubscription;

  IndexPlatformSortState sortState = IndexPlatformSortState.NORMAL;

  IndexPlatformModel() : super(viewState: ViewState.first);

  //state 0 priceClicked，1 rateClicked
  void changeSortState(int state) {
    if (state == 0) {
      if (sortState == IndexPlatformSortState.NORMAL || sortState == IndexPlatformSortState.RATE_ASCEND || sortState == IndexPlatformSortState.RATE_DESCEND) {
        sortState = IndexPlatformSortState.PRICE_ASCEND;
      } else if (sortState == IndexPlatformSortState.PRICE_ASCEND) {
        sortState = IndexPlatformSortState.PRICE_DESCEND;
      } else if (sortState == IndexPlatformSortState.PRICE_DESCEND) {
        sortState = IndexPlatformSortState.NORMAL;
      }
    } else if (state == 1) {
      if (sortState == IndexPlatformSortState.NORMAL || sortState == IndexPlatformSortState.PRICE_ASCEND || sortState == IndexPlatformSortState.PRICE_DESCEND) {
        sortState = IndexPlatformSortState.RATE_ASCEND;
      } else if (sortState == IndexPlatformSortState.RATE_ASCEND) {
        sortState = IndexPlatformSortState.RATE_DESCEND;
      } else if (sortState == IndexPlatformSortState.RATE_DESCEND) {
        sortState = IndexPlatformSortState.NORMAL;
      }
    }

    notifyListeners();
  }

  List<QuoteIndexPlatform> getSortedList() {

    List<QuoteIndexPlatform> sortedList = [];
    sortedList.addAll(quoteList);

    sortedList.sort((a, b) {
      if (sortState == IndexPlatformSortState.NORMAL) {
        return 0;
      } else if (sortState == IndexPlatformSortState.PRICE_ASCEND) {
        if (a.quote! > b.quote!) {
          return 1;
        } else if (a.quote! < b.quote!) {
          return -1;
        }

      } else if (sortState == IndexPlatformSortState.PRICE_DESCEND) {
        if (a.quote! > b.quote!) {
          return -1;
        } else if (a.quote! < b.quote!) {
          return 1;
        }

      } else if (sortState == IndexPlatformSortState.RATE_ASCEND) {
        if (a.change_percent! > b.change_percent!) {
          return -1;
        } else if (a.change_percent! < b.change_percent!) {
          return 1;
        }

      } else if (sortState == IndexPlatformSortState.RATE_DESCEND) {
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
    quoteSubscription?.cancel();

//    quoteSubscription = Event.eventBus.on<WsEvent>().listen((event) {
//      QuoteWs quoteWs = event.quoteWs;
//      if (quoteWs == null) {
//        return;
//      }
//
//      if (quoteBasic != null && quoteWs.coin_code.toLowerCase() == quoteBasic.coin_code.toLowerCase()) {
//        quoteBasic.quote = quoteWs.quote;
//        quoteBasic.change_percent = quoteWs.change_percent_24hr;
//
//        notifyListeners();
//      }
//    });
  }

  Future getQuote(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_GET_CHAIN_QUOTE, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          quoteBasic = QuoteIndexPlatformBasic.fromJson(data);
          quoteList = quoteBasic?.exchange_quote_list ?? [];

          if (ObjectUtil.isEmptyList(quoteList)) {
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
    quoteSubscription?.cancel();
    super.dispose();
  }
}
