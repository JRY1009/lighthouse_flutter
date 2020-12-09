
import 'package:lighthouse/utils/object_util.dart';

class Quote {

  int hour;
  double quote;
  String date ;

  Quote({
    this.hour,
    this.quote,
    this.date,
  });

  Quote.fromJson(Map<String, dynamic> jsonMap) {
    hour = jsonMap['hour'];
    quote = jsonMap['quote'];
    date = jsonMap['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['hour'] = this.hour;
    jsonMap['quote'] = this.quote;
    jsonMap['created_at'] = this.date;

    return jsonMap;
  }

  static List<Quote> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<Quote> items = new List<Quote>();
    for(Map<String, dynamic> map in mapList) {
      items.add(Quote.fromJson(map));
    }
    return items;
  }
}
