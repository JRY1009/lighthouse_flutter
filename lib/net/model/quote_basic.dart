import 'package:lighthouse/net/model/quote.dart';

class QuoteBasic {
  String pair;
  String coin_code;
  double market_val;
  double change_percent;
  double change_amount;
  double quote;
  double vol_24h;
  double amount_24h;
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
    coin_code = jsonMap['coin_code'];
    market_val = jsonMap['market_val'] ?? 0;
    change_percent = jsonMap['change_percent'] ?? 0;
    change_amount = jsonMap['change_amount'] ?? 0;
    quote = jsonMap['quote'] ?? 0;
    vol_24h = jsonMap['vol_24h'] ?? 0;
    amount_24h = jsonMap['amount_24h'] ?? 0;
    hashrate = jsonMap['hashrate'] ?? 0;
    quote_24h = Quote.fromJsonList(jsonMap['quote_24h']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['pair'] = this.pair;
    jsonMap['coin_code'] = this.coin_code;
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
