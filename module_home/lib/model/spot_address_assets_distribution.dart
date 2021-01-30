
import 'package:flutter/material.dart';
import 'package:library_base/utils/object_util.dart';

class SpotAddressAssetsDistribution {

  String range;
  int address_count;
  String compare_yesterday_ratio ;

  Color getColor(int index) {
    switch (index % 7) {
      case 0:
        return Color(0xffa8f250);
      case 1:
        return Color(0xff683250);
      case 2:
        return Color(0xff845bef);
      case 3:
        return Color(0xff13d38e);
      case 4:
        return Color(0xff845bef);
      case 5:
        return Color(0xfff8b2a0);
      case 6:
        return Color(0xff0293ee);
    }
  }

  SpotAddressAssetsDistribution({
    this.range,
    this.address_count,
    this.compare_yesterday_ratio,
  });

  SpotAddressAssetsDistribution.fromJson(Map<String, dynamic> jsonMap) {
    range = jsonMap['range'];
    address_count = jsonMap['address_count'];
    compare_yesterday_ratio = jsonMap['compare_yesterday_ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['range'] = this.range;
    jsonMap['address_count'] = this.address_count;
    jsonMap['compare_yesterday_ratio'] = this.compare_yesterday_ratio;

    return jsonMap;
  }

  static List<SpotAddressAssetsDistribution> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<SpotAddressAssetsDistribution> items = new List<SpotAddressAssetsDistribution>();
    for(Map<String, dynamic> map in mapList) {
      items.add(SpotAddressAssetsDistribution.fromJson(map));
    }
    return items;
  }
}
