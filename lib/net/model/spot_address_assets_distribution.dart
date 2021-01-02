
import 'package:lighthouse/utils/object_util.dart';

class SpotAddressAssetsDistribution {

  String range;
  int address_count;
  String compare_yesterday_ratio ;

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
