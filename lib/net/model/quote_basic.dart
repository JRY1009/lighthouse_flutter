import 'package:lighthouse/net/model/quote.dart';

class QuoteBasic {
  String pair;
  double market_val;
  double change_percent;
  double quote;
  double vol_24h;
  double hashrate;
  List<Quote> quote_24h;

  QuoteBasic({
    this.pair,
    this.market_val,
    this.change_percent,
    this.quote,
    this.vol_24h,
    this.hashrate,
    this.quote_24h,
  });

  QuoteBasic.fromJson(Map<String, dynamic> jsonMap) {
    pair = jsonMap['pair'];
    market_val = jsonMap['market_val'];
    change_percent = jsonMap['change_percent'];
    quote = jsonMap['quote'];
    vol_24h = jsonMap['vol_24h'];
    hashrate = jsonMap['hashrate'];
    quote_24h = Quote.fromJsonList(jsonMap['quote_24h']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['pair'] = this.pair;
    jsonMap['market_val'] = this.market_val;
    jsonMap['change_percent'] = this.change_percent;
    jsonMap['quote'] = this.quote;
    jsonMap['vol_24h'] = this.vol_24h;
    jsonMap['hashrate'] = this.hashrate;
    jsonMap['quote_24h'] = this.quote_24h?.map((v) => v.toJson()).toList();

    return jsonMap;
  }
}
