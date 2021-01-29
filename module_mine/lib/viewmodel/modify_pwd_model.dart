

import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/model/account.dart';

class ModifyPwdModel extends ViewStateModel {

  AccountEntity loginResult;

  ModifyPwdModel();

  Future resetPwd(newPassword, confirmpassword, verifyCode) {

    Map<String, dynamic> params = {
      'new_password': newPassword,
      'confirm_password': confirmpassword,
      'verification_code': verifyCode,
    };

    setBusy();

    return DioUtil.getInstance().requestNetwork(Apis.URL_RESET_PASSWORD, "post", params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {
          setSuccess();
        },
        onError: (errno, msg) {
          loginResult = null;
          setError(errno, message: msg);
        });
  }
}
