

import 'package:lighthouse/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';

class VerifyModel extends ViewStateModel {

  VerifyModel();

  Future<bool> getVCode(phone) async {

    Map<String, dynamic> params = {
      'phone': phone,
      'sms_type' : 1
    };

    setBusy();
    await DioUtil.getInstance().requestNetwork(Constant.URL_VERIFY_CODE, "post", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          setSuccess();
        },
        onError: (error, msg) {
          setError(error, message: msg);
        });

    return Future.value(isSuccess);
  }
}
