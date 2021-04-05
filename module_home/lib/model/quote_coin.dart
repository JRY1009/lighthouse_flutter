
class QuoteCoin {
  String coin_code;
  String pair;
  num change_percent;
  num change_amount;
  num quote;
  num vol_24h;
  num amount_24h;
  num cny;

  QuoteCoin({
    this.coin_code,
    this.pair,
    this.change_percent,
    this.change_amount,
    this.quote,
    this.vol_24h,
    this.amount_24h,
    this.cny,
  });

  QuoteCoin.fromJson(Map<String, dynamic> jsonMap) {
    coin_code = jsonMap['coin_code'] ?? '';
    pair = jsonMap['pair'] ?? '';
    change_percent = jsonMap['change_percent'] ?? 0;
    change_amount = jsonMap['change_amount'] ?? 0;
    quote = jsonMap['quote'] ?? 0;
    vol_24h = jsonMap['vol_24h'] ?? 0;
    amount_24h = jsonMap['amount_24h'] ?? 0;
    cny = jsonMap['cny'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['coin_code'] = this.coin_code;
    jsonMap['pair'] = this.pair;
    jsonMap['change_percent'] = this.change_percent;
    jsonMap['change_amount'] = this.change_amount;
    jsonMap['quote'] = this.quote;
    jsonMap['vol_24h'] = this.vol_24h;
    jsonMap['amount_24h'] = this.amount_24h;
    jsonMap['cny'] = this.cny;

    return jsonMap;
  }
}
