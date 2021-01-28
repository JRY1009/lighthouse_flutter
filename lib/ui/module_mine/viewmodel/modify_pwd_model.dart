

import 'package:library_base/mvvm/view_state_model.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
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

    return DioUtil.getInstance().requestNetwork(Constant.URL_RESET_PASSWORD, "post", params: params,
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
