

import 'package:flutter/material.dart';
import 'package:library_base/utils/object_util.dart';

class IndexData {

  num? turnover;
  num? turnover_market_vol;
  num? total_supply;
  num? total_supply_market_vol;
  num? address_count;
  String? update_time;
  String? pair;
  List<AssetsDistribution>? address_balance_list;


  IndexData({
    this.turnover,
    this.turnover_market_vol,
    this.total_supply,
    this.total_supply_market_vol,
    this.address_count,
    this.update_time,
    this.pair,
    this.address_balance_list,
  });

  IndexData.fromJson(Map<String, dynamic> jsonMap) {
    turnover = jsonMap['turnover'] ?? 0;
    turnover_market_vol = jsonMap['turnover_market_vol'] ?? 0;
    total_supply = jsonMap['total_supply'] ?? 0;
    total_supply_market_vol = jsonMap['total_supply_market_vol'] ?? 0;
    address_count = jsonMap['address_count'] ?? 0;
    update_time = jsonMap['update_time'] ?? '';
    pair = jsonMap['pair'] ?? '';
    address_balance_list = AssetsDistribution.fromJsonList(jsonMap['address_balance_list']) ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['turnover'] = this.turnover;
    jsonMap['turnover_market_vol'] = this.turnover_market_vol;
    jsonMap['total_supply'] = this.total_supply;
    jsonMap['total_supply_market_vol'] = this.total_supply_market_vol;
    jsonMap['address_count'] = this.address_count;
    jsonMap['update_time'] = this.update_time;
    jsonMap['pair'] = this.pair;
    jsonMap['address_balance_list'] = this.address_balance_list?.map((v) => v.toJson()).toList();

    return jsonMap;
  }

}

class AssetsDistribution {

  String? range;
  num? address_count;
  String? compare_yesterday_ratio ;

  Color getColor(int index) {
    switch (index % 7) {
      case 0:
        return Color(0xffa8f250);
      case 1:
        return Color(0xff683250);
      case 2:
        return Color(0xff845bef);
      case 3:
        return Color(0xffFFB660);
      case 4:
        return Color(0xff845bef);
      case 5:
        return Color(0xff46A9E1);
      case 6:
        return Color(0xff4EDDB6);
      default:
        return Color(0xff4EDDB6);
    }
  }

  AssetsDistribution({
    this.range,
    this.address_count,
    this.compare_yesterday_ratio,
  });

  AssetsDistribution.fromJson(Map<String, dynamic> jsonMap) {
    range = jsonMap['range'] ?? '';
    address_count = jsonMap['address_count'] ?? 0;
    compare_yesterday_ratio = jsonMap['compare_yesterday_ratio'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['range'] = this.range;
    jsonMap['address_count'] = this.address_count;
    jsonMap['compare_yesterday_ratio'] = this.compare_yesterday_ratio;

    return jsonMap;
  }

  static List<AssetsDistribution>? fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<AssetsDistribution> items = [];
    for(Map<String, dynamic> map in mapList) {
      items.add(AssetsDistribution.fromJson(map));
    }
    return items;
  }
}
