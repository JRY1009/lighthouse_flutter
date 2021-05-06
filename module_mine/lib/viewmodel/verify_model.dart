

import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';

class VerifyModel extends ViewStateModel {

  static const int SMS_LOGIN = 1;
  static const int SMS_FORGET_PWD  = 2;
  static const int SMS_CHANGE_PHONE_OLD  = 3;
  static const int SMS_CHANGE_PHONE_NEW  = 4;
  static const int SMS_BIND_PHONE  = 5;

  VerifyModel();

  Future<bool> getVCode(String phone, int smsType) async {

    Map<String, dynamic> params = {
      'phone': phone,
      'sms_type' : smsType
    };

    setBusy();
    await DioUtil.getInstance().requestNetwork(Apis.URL_VERIFY_CODE, "post", data: params,
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
