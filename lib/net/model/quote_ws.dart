import 'package:lighthouse/utils/object_util.dart';

class QuoteWs {

  String coin_code;
  double quote;
  String time;

  QuoteWs({
    this.coin_code,
    this.quote,
    this.time,
  });

  QuoteWs.fromJson(Map<String, dynamic> jsonMap) {
    coin_code = jsonMap['coin_code'];
    quote = jsonMap['quote'];
    time = jsonMap['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['coin_code'] = this.coin_code;
    jsonMap['quote'] = this.quote;
    jsonMap['time'] = this.time;

    return jsonMap;
  }

  static List<QuoteWs> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<QuoteWs> items = new List<QuoteWs>();
    for(Map<String, dynamic> map in mapList) {
      items.add(QuoteWs.fromJson(map));
    }
    return items;
  }
}
