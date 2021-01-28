

import 'package:library_base/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';

class VerifyModel extends ViewStateModel {

  static const int SMS_LOGIN = 1;
  static const int SMS_FORGET_PWD  = 2;
  static const int SMS_CHANGE_PHONE_OLD  = 3;
  static const int SMS_CHANGE_PHONE_NEW  = 4;

  VerifyModel();

  Future<bool> getVCode(String phone, int smsType) async {

    Map<String, dynamic> params = {
      'phone': phone,
      'sms_type' : smsType
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
