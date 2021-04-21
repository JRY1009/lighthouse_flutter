
import 'package:library_base/utils/object_util.dart';

class SpotExchangeQuote {

  String name;
  String pair;
  num quote;
  String ico ;
  String url;
  num cny;
  num change_percent;

  SpotExchangeQuote({
    this.name,
    this.pair,
    this.quote,
    this.ico,
    this.url,
    this.cny,
    this.change_percent,
  });

  SpotExchangeQuote.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'] ?? '';
    pair = jsonMap['pair'] ?? '';
    quote = jsonMap['quote'] ?? 0;
    ico = jsonMap['ico'] ?? '';
    url = jsonMap['url'] ?? '';
    cny = jsonMap['cny'] ?? 0;
    change_percent = jsonMap['change_percent'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['name'] = this.name;
    jsonMap['pair'] = this.pair;
    jsonMap['quote'] = this.quote;
    jsonMap['ico'] = this.ico;
    jsonMap['url'] = this.url;
    jsonMap['cny'] = this.cny;
    jsonMap['change_percent'] = this.change_percent;

    return jsonMap;
  }

  static List<SpotExchangeQuote> fromJsonList(List<dynamic> mapList, String pair) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<SpotExchangeQuote> items = new List<SpotExchangeQuote>();
    for(Map<String, dynamic> map in mapList) {
      items.add(SpotExchangeQuote.fromJson(map)..pair = pair);
    }
    return items;
  }
}
