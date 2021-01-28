
import 'package:library_base/net/base/entry_factory.dart';
import 'package:library_base/net/apis.dart';

class BaseListEntity<T> {
  String errno;
  String msg;
  List<T> data;

  BaseListEntity({this.errno, this.msg, this.data});

  BaseListEntity.fromJson(Map<String, dynamic> jsonMap) {

    errno = jsonMap[Apis.ERRNO] as String;
    msg = jsonMap[Apis.MESSAGE] as String;

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