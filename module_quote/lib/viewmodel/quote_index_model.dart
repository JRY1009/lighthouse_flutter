

import 'dart:async';

import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_quote/model/quote_index.dart';

enum IndexSortState {
  NORMAL,
  PRICE_ASCEND, //升序
  PRICE_DESCEND,  //降序
  RATE_ASCEND, //升序
  RATE_DESCEND,  //降序
}

class QuoteIndexModel extends ViewStateModel {

  QuoteIndexBasic? indexBasic;
  List<QuoteIndex> indexList = [];

  StreamSubscription? indexSubscription;

  IndexSortState sortState = IndexSortState.NORMAL;

  QuoteIndexModel() : super(viewState: ViewState.first);

  //state 0 priceClicked，1 rateClicked
  void changeSortState(int state) {
    if (state == 0) {
      if (sortState == IndexSortState.NORMAL || sortState == IndexSortState.RATE_ASCEND || sortState == IndexSortState.RATE_DESCEND) {
        sortState = IndexSortState.PRICE_ASCEND;
      } else if (sortState == IndexSortState.PRICE_ASCEND) {
        sortState = IndexSortState.PRICE_DESCEND;
      } else if (sortState == IndexSortState.PRICE_DESCEND) {
        sortState = IndexSortState.NORMAL;
      }
    } else if (state == 1) {
      if (sortState == IndexSortState.NORMAL || sortState == IndexSortState.PRICE_ASCEND || sortState == IndexSortState.PRICE_DESCEND) {
        sortState = IndexSortState.RATE_ASCEND;
      } else if (sortState == IndexSortState.RATE_ASCEND) {
        sortState = IndexSortState.RATE_DESCEND;
      } else if (sortState == IndexSortState.RATE_DESCEND) {
        sortState = IndexSortState.NORMAL;
      }
    }

    notifyListeners();
  }

  List<QuoteIndex> getSortedList() {

    List<QuoteIndex> sortedList = [];
    sortedList.addAll(indexList);

    sortedList.sort((a, b) {
      if (sortState == IndexSortState.NORMAL) {
        return 0;
      } else if (sortState == IndexSortState.PRICE_ASCEND) {
        if (a.quote! > b.quote!) {
          return 1;
        } else if (a.quote! < b.quote!) {
          return -1;
        }

      } else if (sortState == IndexSortState.PRICE_DESCEND) {
        if (a.quote! > b.quote!) {
          return -1;
        } else if (a.quote! < b.quote!) {
          return 1;
        }

      } else if (sortState == IndexSortState.RATE_ASCEND) {
        if (a.change_percent! > b.change_percent!) {
          return -1;
        } else if (a.change_percent! < b.change_percent!) {
          return 1;
        }

      } else if (sortState == IndexSortState.RATE_DESCEND) {
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
//      if (indexBasic != null && quoteWs.coin_code.toLowerCase() == indexBasic.coin_code.toLowerCase()) {
//        indexBasic.quote = quoteWs.quote;
//        indexBasic.change_percent = quoteWs.change_percent_24hr;
//
//        notifyListeners();
//      }
//    });
  }

  Future getIndex(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance()!.requestNetwork(Apis.URL_GET_CHAIN_QUOTE, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (dynamic data) {

          indexBasic = QuoteIndexBasic.fromJson(data);
          indexList = indexBasic?.exchange_quote_list ?? [];

          if (ObjectUtil.isEmptyList(indexList)) {
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
