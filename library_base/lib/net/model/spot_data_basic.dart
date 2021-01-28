
import 'package:library_base/net/model/spot_address_assets_distribution.dart';

class SpotDataBasic {

  int turnover;
  int turnover_market_vol;
  int total_supply;
  int total_supply_market_vol;
  int address_count;
  List<SpotAddressAssetsDistribution> address_balance_list;


  SpotDataBasic({
    this.turnover,
    this.turnover_market_vol,
    this.total_supply,
    this.total_supply_market_vol,
    this.address_count,
    this.address_balance_list,
  });

  SpotDataBasic.fromJson(Map<String, dynamic> jsonMap) {
    turnover = jsonMap['turnover'] ?? 0;
    turnover_market_vol = jsonMap['turnover_market_vol'] ?? 0;
    total_supply = jsonMap['total_supply'] ?? 0;
    total_supply_market_vol = jsonMap['total_supply_market_vol'] ?? 0;
    address_count = jsonMap['address_count'] ?? 0;
    address_balance_list = SpotAddressAssetsDistribution.fromJsonList(jsonMap['address_balance_list']) ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['turnover'] = this.turnover;
    jsonMap['turnover_market_vol'] = this.turnover_market_vol;
    jsonMap['total_supply'] = this.total_supply;
    jsonMap['total_supply_market_vol'] = this.total_supply_market_vol;
    jsonMap['address_count'] = this.address_count;
    jsonMap['address_balance_list'] = this.address_balance_list?.map((v) => v.toJson()).toList();

    return jsonMap;
  }

}
