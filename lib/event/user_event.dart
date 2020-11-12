

import 'package:lighthouse/net/model/account.dart';

class UserEvent {
  Account account;
  UserEventState state;

  UserEvent(this.account, this.state);
}

enum UserEventState {
  login,
  logout,
  userme,
}
