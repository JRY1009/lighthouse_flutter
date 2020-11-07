

import 'package:lighthouse/net/model/media.dart';

class Account {
  int account_id;
  String phone;
  String area_code;
  String account_name;
  String password;
  int account_type;    //3官方账号
  int status;
  String latest_login_at;
  String created_at;
  String updated_at;
  String avatar_168;
  String avatar_300;
  String invite_code;
  String remark;
  int sex;        //性别 1-男 ， 2-女
  String birthday;
  List<Media> photos;

  String token;

  Account({
    this.account_id,
    this.phone,
    this.area_code,
    this.account_name,
    this.password,
    this.account_type,
    this.status,
    this.latest_login_at,
    this.created_at,
    this.updated_at,
    this.avatar_168,
    this.avatar_300,
    this.invite_code,
    this.remark,
    this.sex,
    this.birthday,
    this.token,
    this.photos
  });

  Account.fromJson(Map<String, dynamic> jsonMap) {
    account_id = jsonMap['account_id'];
    phone = jsonMap['phone'];
    area_code = jsonMap['area_code'];
    account_name = jsonMap['account_name'];
    password = jsonMap['password'];
    account_type = jsonMap['account_type'];
    status = jsonMap['status'];
    latest_login_at = jsonMap['latest_login_at'];
    created_at = jsonMap['created_at'];
    updated_at = jsonMap['updated_at'];
    avatar_168 = jsonMap['avatar_168'];
    avatar_300 = jsonMap['avatar_300'];
    invite_code = jsonMap['invite_code'];
    remark = jsonMap['remark'];
    sex = jsonMap['sex'];
    birthday = jsonMap['birthday'];
    token = jsonMap['token'];
    photos = Media.fromJsonList(jsonMap['pic']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['account_id'] = this.account_id;
    jsonMap['phone'] = this.phone;
    jsonMap['area_code'] = this.area_code;
    jsonMap['account_name'] = this.account_name;
    jsonMap['password'] = this.password;
    jsonMap['account_type'] = this.account_type;
    jsonMap['status'] = this.status;
    jsonMap['latest_login_at'] = this.latest_login_at;
    jsonMap['created_at'] = this.created_at;
    jsonMap['updated_at'] = this.updated_at;
    jsonMap['avatar_168'] = this.avatar_168;
    jsonMap['avatar_300'] = this.avatar_300;
    jsonMap['invite_code'] = this.invite_code;
    jsonMap['sex'] = this.sex;
    jsonMap['birthday'] = this.birthday;
    jsonMap['token'] = this.token;
    jsonMap['pic'] = this.photos?.map((v) => v.toJson()).toList();

    return jsonMap;
  }


  Account.fromLocalJson(Map<String, dynamic> jsonMap) {
    account_id = jsonMap['account_id'];
    phone = jsonMap['phone'];
    area_code = jsonMap['area_code'];
    account_name = jsonMap['account_name'];
    avatar_168 = jsonMap['avatar_168'];
  }

  Map<String, dynamic> toLocalJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['account_id'] = this.account_id;
    jsonMap['phone'] = this.phone;
    jsonMap['area_code'] = this.area_code;
    jsonMap['account_name'] = this.account_name;
    jsonMap['avatar_168'] = this.avatar_168;

    return jsonMap;
  }
}
