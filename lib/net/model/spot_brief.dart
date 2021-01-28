
import 'package:library_base/utils/object_util.dart';

class SpotBrief {

  String key;
  String title;
  String value ;
  int type;

  SpotBrief({
    this.key,
    this.title,
    this.value,
    this.type,
  });

  SpotBrief.fromJson(Map<String, dynamic> jsonMap) {
    key = jsonMap['key'];
    title = jsonMap['title'];
    value = jsonMap['value'];
    type = jsonMap['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['key'] = this.key;
    jsonMap['title'] = this.title;
    jsonMap['value'] = this.value;
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
