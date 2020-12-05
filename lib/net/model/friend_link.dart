
import 'package:lighthouse/utils/object_util.dart';

class FriendLink {

  String name;
  String url;

  FriendLink({
    this.name,
    this.url,
  });

  FriendLink.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'];
    url = jsonMap['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['name'] = this.name;
    jsonMap['url'] = this.url;

    return jsonMap;
  }

  static List<FriendLink> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<FriendLink> items = new List<FriendLink>();
    for(Map<String, dynamic> map in mapList) {
      items.add(FriendLink.fromJson(map));
    }
    return items;
  }
}
