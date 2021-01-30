

import 'package:module_home/model/spot_exchange_quote.dart';

class SpotExchangeQuoteBasic {
  String coin_code;
  String data_src;
  double change_percent;
  double change_amount;
  double quote;
  double cny;
  List<SpotExchangeQuote> exchange_quote_list;


  SpotExchangeQuoteBasic({
    this.coin_code,
    this.data_src,
    this.change_percent,
    this.change_amount,
    this.quote,
    this.cny,
    this.exchange_quote_list,
  });

  SpotExchangeQuoteBasic.fromJson(Map<String, dynamic> jsonMap) {
    coin_code = jsonMap['coin_code'];
    data_src = jsonMap['data_src'];
    change_percent = jsonMap['change_percent'];
    change_amount = jsonMap['change_amount'];
    quote = jsonMap['quote'];
    cny = jsonMap['cny'];
    exchange_quote_list = SpotExchangeQuote.fromJsonList(jsonMap['exchange_quote_list']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['coin_code'] = this.coin_code;
    jsonMap['data_src'] = this.data_src;
    jsonMap['change_percent'] = this.change_percent;
    jsonMap['change_amount'] = this.change_amount;
    jsonMap['quote'] = this.quote;
    jsonMap['cny'] = this.cny;
    jsonMap['exchange_quote_list'] = this.exchange_quote_list?.map((v) => v.toJson()).toList();

    return jsonMap;
  }

}
