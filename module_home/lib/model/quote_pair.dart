

import 'package:module_home/model/quote.dart';

class QuotePair {
  String pair;
  String chain;
  String coin_code;
  String coin_name;
  String icon;
  String icon_grey;
  num market_val;
  num change_percent;
  num change_amount;
  num quote;
  num vol_24h;
  num amount_24h;
  String hashrate;
  List<Quote> quote_24h;

  QuotePair({
    this.pair,
    this.coin_name,
    this.icon,
    this.icon_grey,
    this.market_val,
    this.change_percent,
    this.quote,
    this.vol_24h,
    this.hashrate,
    this.quote_24h,
  });

  QuotePair.fromJson(Map<String, dynamic> jsonMap) {
    pair = jsonMap['pair'] ?? '';
    chain = jsonMap['chain'] ?? '';
    coin_code = jsonMap['coin_code'] ?? '';
    coin_name = jsonMap['coin_name'] ?? '';
    icon = jsonMap['icon'] ?? '';
    icon_grey = jsonMap['icon_grey'] ?? '';
    market_val = jsonMap['market_val'] ?? 0;
    change_percent = jsonMap['change_percent'] ?? 0;
    change_amount = jsonMap['change_amount'] ?? 0;
    quote = jsonMap['quote'] ?? 0;
    vol_24h = jsonMap['vol_24h'] ?? 0;
    amount_24h = jsonMap['amount_24h'] ?? 0;
    hashrate = jsonMap['hashrate'] ?? '0';
    quote_24h = Quote.fromJsonList(jsonMap['quote_24h']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['pair'] = this.pair;
    jsonMap['chain'] = this.chain;
    jsonMap['coin_code'] = this.coin_code;
    jsonMap['coin_name'] = this.coin_name;
    jsonMap['icon'] = this.icon;
    jsonMap['icon_grey'] = this.icon_grey;
    jsonMap['market_val'] = this.market_val;
    jsonMap['change_percent'] = this.change_percent;
    jsonMap['change_amount'] = this.change_amount;
    jsonMap['quote'] = this.quote;
    jsonMap['vol_24h'] = this.vol_24h;
    jsonMap['amount_24h'] = this.amount_24h;
    jsonMap['hashrate'] = this.hashrate;
    jsonMap['quote_24h'] = this.quote_24h?.map((v) => v.toJson()).toList();

    return jsonMap;
  }
}
