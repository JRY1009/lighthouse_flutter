
import 'package:library_base/utils/object_util.dart';

class FriendLink {

  String? name;
  String? url;
  String? ico;

  FriendLink({
    this.name,
    this.url,
    this.ico,
  });

  FriendLink.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'] ?? '';
    url = jsonMap['url'] ?? '';
    ico = jsonMap['ico'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['name'] = this.name;
    jsonMap['url'] = this.url;
    jsonMap['ico'] = this.ico;

    return jsonMap;
  }

  static List<FriendLink>? fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<FriendLink> items = [];
    for(Map<String, dynamic> map in mapList) {
      items.add(FriendLink.fromJson(map));
    }
    return items;
  }
}
