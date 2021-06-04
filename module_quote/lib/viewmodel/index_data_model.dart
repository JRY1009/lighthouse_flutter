

import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_quote/model/index_data.dart';

class IndexDataModel extends ViewStateModel {

  IndexData dataBasic;
  List<AssetsDistribution> dataList = [];

  IndexDataModel() : super(viewState: ViewState.first);

  Future getData(String chain) {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_CHAIN_DATA, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          dataBasic = IndexData.fromJson(data);
          dataList = dataBasic?.address_balance_list ?? [];

          if (ObjectUtil.isEmptyList(dataList)) {
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
