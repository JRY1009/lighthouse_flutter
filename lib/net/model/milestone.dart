
import 'package:lighthouse/utils/object_util.dart';

class MileStone {

  String daily_desc;
  String created_at ;

  MileStone({
    this.daily_desc,
    this.created_at,
  });

  MileStone.fromJson(Map<String, dynamic> jsonMap) {
    daily_desc = jsonMap['daily_desc'];
    created_at = jsonMap['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['daily_desc'] = this.daily_desc;
    jsonMap['created_at'] = this.created_at;

    return jsonMap;
  }

  static List<MileStone> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<MileStone> items = new List<MileStone>();
    for(Map<String, dynamic> map in mapList) {
      items.add(MileStone.fromJson(map));
    }
    return items;
  }
}
