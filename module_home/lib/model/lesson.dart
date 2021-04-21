
import 'package:library_base/utils/object_util.dart';

class Lesson {

  num id;
  String title;
  String content;
  num yn;

  Lesson({
    this.id,
    this.title,
    this.content,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Lesson &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  Lesson.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'] ?? 0;
    title = jsonMap['title'] ?? '';
    content = jsonMap['content'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['id'] = this.id;
    jsonMap['title'] = this.title;
    jsonMap['content'] = this.content;

    return jsonMap;
  }

  static List<Lesson> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<Lesson> items = new List<Lesson>();
    for(Map<String, dynamic> map in mapList) {
      items.add(Lesson.fromJson(map));
    }
    return items;
  }
}
