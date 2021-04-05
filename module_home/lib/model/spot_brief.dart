
import 'package:library_base/utils/object_util.dart';

class SpotBrief {

  String key;
  String title;
  String value;
  String detail;
  int type;

  SpotBrief({
    this.key,
    this.title,
    this.value,
    this.detail,
    this.type,
  });

  SpotBrief.fromJson(Map<String, dynamic> jsonMap) {
    key = jsonMap['key'] ?? '';
    title = jsonMap['title'] ?? '';
    value = jsonMap['value'] ?? '';
    detail = jsonMap['detail'] ?? '';
    type = jsonMap['type'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['key'] = this.key;
    jsonMap['title'] = this.title;
    jsonMap['value'] = this.value;
    jsonMap['detail'] = this.detail;
    jsonMap['type'] = this.type;

    return jsonMap;
  }

  static List<SpotBrief> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<SpotBrief> items = new List<SpotBrief>();
    for(Map<String, dynamic> map in mapList) {
      items.add(SpotBrief.fromJson(map));
    }
    return items;
  }
}
