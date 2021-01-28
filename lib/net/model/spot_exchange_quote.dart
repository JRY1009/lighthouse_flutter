
import 'package:library_base/utils/object_util.dart';

class SpotExchangeQuote {

  String name;
  double quote;
  String ico ;
  String url;
  double cny;
  double change_percent;

  SpotExchangeQuote({
    this.name,
    this.quote,
    this.ico,
    this.url,
    this.cny,
    this.change_percent,
  });

  SpotExchangeQuote.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'];
    quote = jsonMap['quote'];
    ico = jsonMap['ico'];
    url = jsonMap['url'];
    cny = jsonMap['cny'];
    change_percent = jsonMap['change_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['name'] = this.name;
    jsonMap['quote'] = this.quote;
    jsonMap['ico'] = this.ico;
    jsonMap['url'] = this.url;
    jsonMap['cny'] = this.cny;
    jsonMap['change_percent'] = this.change_percent;

    return jsonMap;
  }

  static List<SpotExchangeQuote> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<SpotExchangeQuote> items = new List<SpotExchangeQuote>();
    for(Map<String, dynamic> map in mapList) {
      items.add(SpotExchangeQuote.fromJson(map));
    }
    return items;
  }
}
