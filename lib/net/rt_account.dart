
import 'dart:convert';

import 'package:lighthouse/net/model/account.dart';
import 'package:lighthouse/utils/object_util.dart';
import 'package:lighthouse/utils/sp_util.dart';

class RTAccount {

  static RTAccount _instance;

  static RTAccount instance() {
    if (_instance == null) {
      _instance = new RTAccount();
    }
    return _instance;
  }

  Account _activeAccount;

  Account getActiveAccount() => _activeAccount;

  setActiveAccount(Account account) {
    _activeAccount = account;
  }

  bool isLogin() {
    return _activeAccount != null;
  }

  saveAccount() async {
    await SPUtil.putString(
        SPUtil.key_latest_account,
        json.encode(_activeAccount.toLocalJson()));
  }

  Account loadAccount() {
    String jsonString = SPUtil.getString(SPUtil.key_latest_account, defValue: '');

    if (ObjectUtil.isEmptyString(jsonString)) {
      return null;
    }

    Map<String, dynamic> jsonMap = json.decode(jsonString);
    if (jsonMap == null) {
      return null;
    } else {
      return Account.fromLocalJson(jsonMap);
    }
  }
}
