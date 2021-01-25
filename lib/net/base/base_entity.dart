import 'package:lighthouse/net/base/entry_factory.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/utils/object_util.dart';

class BaseEntity<T> {

  String errno;
  String msg;
  T data;

  BaseEntity({this.errno, this.msg, this.data});

  BaseEntity.fromJson(Map<String, dynamic> jsonMap) {
    errno = jsonMap[Constant.ERRNO] as String;
    msg = jsonMap[Constant.MESSAGE] as String;

    if (jsonMap.containsKey('data') && !ObjectUtil.isEmpty(jsonMap['data'])) {
      data = EntityFactory.generateOBJ<T>(jsonMap['data']);
    }
  }

}