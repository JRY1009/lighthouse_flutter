
import 'package:lighthouse/net/model/spot_address_assets_distribution.dart';

class SpotDataBasic {

  double turnover;
  double turnover_market_vol;
  double total_supply;
  double total_supply_market_vol;
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
    turnover = jsonMap['turnover'];
    turnover_market_vol = jsonMap['turnover_market_vol'];
    total_supply = jsonMap['total_supply'];
    total_supply_market_vol = jsonMap['total_supply_market_vol'];
    address_count = jsonMap['address_count'];
    address_balance_list = SpotAddressAssetsDistribution.fromJsonList(jsonMap['address_balance_list']);
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
