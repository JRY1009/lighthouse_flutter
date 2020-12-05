
import 'package:lighthouse/utils/object_util.dart';

class SpotBriefInfo {

  String key;
  String title;
  String value ;

  SpotBriefInfo({
    this.key,
    this.title,
    this.value,
  });

  SpotBriefInfo.fromJson(Map<String, dynamic> jsonMap) {
    key = jsonMap['key'];
    title = jsonMap['title'];
    value = jsonMap['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['key'] = this.key;
    jsonMap['title'] = this.title;
    jsonMap['value'] = this.value;

    return jsonMap;
  }

  static List<SpotBriefInfo> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<SpotBriefInfo> items = new List<SpotBriefInfo>();
    for(Map<String, dynamic> map in mapList) {
      items.add(SpotBriefInfo.fromJson(map));
    }
    return items;
  }
}
