
import 'package:module_quote/model/quote_index.dart';
import 'package:module_quote/model/quote_index_platform.dart';
import 'package:module_quote/model/quote_platform.dart';

List<QuoteIndexPlatform> mock_btc_plist = [
  QuoteIndexPlatform(name: 'OKEx', pair: 'BTC/USD', quote: 66223.33, cny: 400121.3, change_percent: -5.11),
  QuoteIndexPlatform(name: 'Huobi', pair: 'BTC/USD', quote: 66422.33, cny: 400121.3, change_percent: -5.21),
  QuoteIndexPlatform(name: 'Binance', pair: 'BTC/USD', quote: 66313.33, cny: 400121.3, change_percent: -5.25),
];

QuoteIndexPlatformBasic mock_btc_pbasic = QuoteIndexPlatformBasic(
    coin_code: 'BTC',
    pair: 'BTC/USD',
    change_percent: -5.21,
    change_amount: -489.33,
    quote: 66451.33,
    cny: 400321.22,
    exchange_quote_list: mock_btc_plist
);

List<QuoteIndex> mock_btc_ilist = [
  QuoteIndex(name: 'OKEx', pair: 'BTC/USD', quote: 66223.33, cny: 400121.3, change_percent: -5.11),
  QuoteIndex(name: 'Huobi', pair: 'BTC/USD', quote: 66422.33, cny: 400121.3, change_percent: -5.21),
  QuoteIndex(name: 'Binance', pair: 'BTC/USD', quote: 66313.33, cny: 400121.3, change_percent: -5.25),
];

QuoteIndexBasic mock_btc_ibasic = QuoteIndexBasic(
    coin_code: 'BTC',
    pair: 'BTC/USD',
    change_percent: -5.21,
    change_amount: -489.33,
    quote: 66451.33,
    cny: 400321.22,
    exchange_quote_list: mock_btc_ilist
);

List<QuotePlatformPair> mock_btc_qlist = [
  QuotePlatformPair(name: 'OKEx', pair: 'BTC/USD', quote: 66223.33, cny: 400121.3, change_percent: -5.11),
  QuotePlatformPair(name: 'Huobi', pair: 'BTC/USD', quote: 66422.33, cny: 400121.3, change_percent: -5.21),
  QuotePlatformPair(name: 'Binance', pair: 'BTC/USD', quote: 66313.33, cny: 400121.3, change_percent: -5.25),
];

QuotePlatformBasic mock_btc_qbasic = QuotePlatformBasic(
    coin_code: 'BTC',
    pair: 'BTC/USD',
    change_percent: -5.21,
    change_amount: -489.33,
    quote: 66451.33,
    cny: 400321.22,
    exchange_quote_list: mock_btc_qlist
);

List<QuoteIndexPlatform> mock_eth_plist = [
  QuoteIndexPlatform(name: 'OKEx', pair: 'ETH/USD', quote: 4653.33, cny: 30321.3, change_percent: 2.41),
  QuoteIndexPlatform(name: 'Huobi', pair: 'ETH/USD', quote: 4653.33, cny: 30421.3, change_percent: 2.21),
  QuoteIndexPlatform(name: 'Binance', pair: 'ETH/USD', quote: 4653.33, cny: 30351.3, change_percent: 2.25),
];

QuoteIndexPlatformBasic mock_eth_pbasic = QuoteIndexPlatformBasic(
    coin_code: 'ETH',
    pair: 'ETH/USD',
    change_percent: 2.32,
    change_amount: 89.33,
    quote: 4653.33,
    cny: 30321.22,
    exchange_quote_list: mock_eth_plist
);

List<QuoteIndex> mock_eth_ilist = [
  QuoteIndex(name: 'OKEx', pair: 'ETH/USD', quote: 4653.33, cny: 30321.3, change_percent: 2.41),
  QuoteIndex(name: 'Huobi', pair: 'ETH/USD', quote: 4653.33, cny: 30421.3, change_percent: 2.21),
  QuoteIndex(name: 'Binance', pair: 'ETH/USD', quote: 4653.33, cny: 30351.3, change_percent: 2.25),
];

QuoteIndexBasic mock_eth_ibasic = QuoteIndexBasic(
    coin_code: 'ETH',
    pair: 'ETH/USD',
    change_percent: 2.32,
    change_amount: 89.33,
    quote: 4653.33,
    cny: 30321.22,
    exchange_quote_list: mock_eth_ilist
);

List<QuotePlatformPair> mock_eth_qlist = [
  QuotePlatformPair(name: 'OKEx', pair: 'ETH/USD', quote: 4653.33, cny: 30321.3, change_percent: 2.41),
  QuotePlatformPair(name: 'Huobi', pair: 'ETH/USD', quote: 4653.33, cny: 30421.3, change_percent: 2.21),
  QuotePlatformPair(name: 'Binance', pair: 'ETH/USD', quote: 4653.33, cny: 30351.3, change_percent: 2.25),
];

QuotePlatformBasic mock_eth_qbasic = QuotePlatformBasic(
    coin_code: 'ETH',
    pair: 'ETH/USD',
    change_percent: 2.32,
    change_amount: 89.33,
    quote: 4653.33,
    cny: 30321.22,
    exchange_quote_list: mock_eth_qlist
);