
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/entry_factory.dart';

class BaseListEntity<T> {
  String errno;
  String msg;
  List<T> data;

  BaseListEntity({this.errno, this.msg, this.data});

  BaseListEntity.fromJson(Map<String, dynamic> jsonMap) {

    errno = jsonMap[Constant.ERRNO] as String;
    msg = jsonMap[Constant.MESSAGE] as String;

    List<T> datalist = new List<T>();
    if (jsonMap['data'] != null) {
      //遍历data并转换为我们传进来的类型
      (jsonMap['data'] as List).forEach((v) {
        datalist.add(EntityFactory.generateOBJ<T>(v));
      });
    }
    data = datalist;
  }
}