
class QuoteCoin {
  String coin_code;
  String coin_name;
  String icon;
  String pair;
  num change_percent;
  num change_amount;
  num quote;
  num vol_24h;
  num amount_24h;
  num cny;
  String publish_date;
  num market_val;
  String hashrate;

  QuoteCoin({
    this.coin_code,
    this.coin_name,
    this.icon,
    this.pair,
    this.change_percent,
    this.change_amount,
    this.quote,
    this.vol_24h,
    this.amount_24h,
    this.cny,
    this.publish_date,
    this.market_val,
  });

  QuoteCoin.fromJson(Map<String, dynamic> jsonMap) {
    coin_code = jsonMap['coin_code'] ?? '';
    coin_name = jsonMap['coin_name'] ?? '';
    icon = jsonMap['icon'] ?? '';
    pair = jsonMap['pair'] ?? '';
    change_percent = jsonMap['change_percent'] ?? 0;
    change_amount = jsonMap['change_amount'] ?? 0;
    quote = jsonMap['quote'] ?? 0;
    vol_24h = jsonMap['vol_24h'] ?? 0;
    amount_24h = jsonMap['amount_24h'] ?? 0;
    cny = jsonMap['cny'] ?? 0;
    publish_date = jsonMap['publish_date'] ?? '';
    market_val = jsonMap['market_val'] ?? 0;
    hashrate = jsonMap['hashrate'] ?? '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['coin_code'] = this.coin_code;
    jsonMap['coin_name'] = this.coin_name;
    jsonMap['icon'] = this.icon;
    jsonMap['pair'] = this.pair;
    jsonMap['change_percent'] = this.change_percent;
    jsonMap['change_amount'] = this.change_amount;
    jsonMap['quote'] = this.quote;
    jsonMap['vol_24h'] = this.vol_24h;
    jsonMap['amount_24h'] = this.amount_24h;
    jsonMap['cny'] = this.cny;
    jsonMap['publish_date'] = this.publish_date;
    jsonMap['market_val'] = this.market_val;
    jsonMap['hashrate'] = this.hashrate;


    return jsonMap;
  }
}
