
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:module_mine/mine_router.dart';

class Area {

  String us_name;
  String cn_name;
  String code;
  String get name => WidgetsBinding.instance.window.locale.toString() == 'zh_CN' ? cn_name : us_name;
  String get sort_name => WidgetsBinding.instance.window.locale.toString() == 'zh_CN' ? first_pinyin : us_name;
  String get first_pinyin => PinyinHelper.getFirstWordPinyin(cn_name);
  String get short_pinyin => PinyinHelper.getShortPinyin(cn_name);

  Area({
    this.us_name,
    this.cn_name,
    this.code,
  });

  Area.fromJson(Map<String, dynamic> jsonMap) {
    us_name = jsonMap['us_name'];
    cn_name = jsonMap['cn_name'];
    code = jsonMap['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['us_name'] = this.us_name;
    jsonMap['cn_name'] = this.cn_name;
    jsonMap['code'] = this.code;

    return jsonMap;
  }

  static List<Area> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<Area> items = new List<Area>();
    for(Map<String, dynamic> map in mapList) {
      items.add(Area.fromJson(map));
    }
    return items;
  }

  static Future<List<Area>> loadAreaFromFile() async{
    String jsonString = await rootBundle.loadString(
        MineRouter.isRunModule ?
        'assets/files/country.json' :
        'packages/module_mine/assets/files/country.json');

    Map<String, dynamic> dataMap = json.decode(jsonString);

    return Area.fromJsonList(dataMap['codes']);
  }
}
