
import 'package:library_base/utils/object_util.dart';

class News {

  num article_id;
  String publish_time;
  String author;
  String publisher;
  String title;
  String summary;
  String snapshot_url;
  String url;
  String url_app;

  News({
    this.article_id,
    this.publish_time,
    this.author,
    this.publisher,
    this.title,
    this.summary,
    this.snapshot_url,
    this.url,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is News &&
          runtimeType == other.runtimeType &&
          article_id == other.article_id;

  @override
  int get hashCode => article_id.hashCode;

  News.fromJson(Map<String, dynamic> jsonMap) {
    article_id = jsonMap['article_id'] ?? 0;
    publish_time = jsonMap['publish_time'] ?? '';
    author = jsonMap['author'] ?? '';
    publisher = jsonMap['publisher'] ?? '';
    title = jsonMap['title'] ?? '';
    summary = jsonMap['summary'] ?? '';
    snapshot_url = jsonMap['snapshot_url'] ?? '';
    url = jsonMap['url'] ?? '';
    url_app = url + '?app=1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['article_id'] = this.article_id;
    jsonMap['publish_time'] = this.publish_time;
    jsonMap['author'] = this.author;
    jsonMap['publisher'] = this.publisher;
    jsonMap['title'] = this.title;
    jsonMap['summary'] = this.summary;
    jsonMap['snapshot_url'] = this.snapshot_url;
    jsonMap['url'] = this.url;

    return jsonMap;
  }

  static List<News> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<News> items = new List<News>();
    for(Map<String, dynamic> map in mapList) {
      items.add(News.fromJson(map));
    }
    return items;
  }
}
