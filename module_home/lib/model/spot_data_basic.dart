

import 'package:module_home/model/spot_address_assets_distribution.dart';

class SpotDataBasic {

  num turnover;
  num turnover_market_vol;
  num total_supply;
  num total_supply_market_vol;
  num address_count;
  String update_time;
  String pair;
  List<SpotAddressAssetsDistribution> address_balance_list;


  SpotDataBasic({
    this.turnover,
    this.turnover_market_vol,
    this.total_supply,
    this.total_supply_market_vol,
    this.address_count,
    this.update_time,
    this.pair,
    this.address_balance_list,
  });

  SpotDataBasic.fromJson(Map<String, dynamic> jsonMap) {
    turnover = jsonMap['turnover'] ?? 0;
    turnover_market_vol = jsonMap['turnover_market_vol'] ?? 0;
    total_supply = jsonMap['total_supply'] ?? 0;
    total_supply_market_vol = jsonMap['total_supply_market_vol'] ?? 0;
    address_count = jsonMap['address_count'] ?? 0;
    update_time = jsonMap['update_time'] ?? '';
    pair = jsonMap['pair'] ?? '';
    address_balance_list = SpotAddressAssetsDistribution.fromJsonList(jsonMap['address_balance_list']) ?? [];
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
