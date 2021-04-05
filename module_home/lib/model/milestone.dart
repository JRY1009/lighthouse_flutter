
import 'package:library_base/utils/object_util.dart';

class MileStone {

  String content;
  String date ;

  MileStone({
    this.content,
    this.date,
  });

  MileStone.fromJson(Map<String, dynamic> jsonMap) {
    content = jsonMap['content'] ?? '';
    date = jsonMap['date'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['content'] = this.content;
    jsonMap['created_at'] = this.date;

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
