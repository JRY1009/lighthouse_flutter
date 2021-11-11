
import 'package:library_base/model/quote.dart';
import 'package:library_base/model/quote_coin.dart';
import 'package:library_base/model/quote_pair.dart';

List<Quote> mock_quote_24h = [
  Quote(quote: 4613.21, date: '2021-11-11', hour: 12, minute: 0, second: 0),
  Quote(quote: 4646.35, date: '2021-11-11', hour: 11, minute: 30, second: 0),
  Quote(quote: 4636.40, date: '2021-11-11', hour: 11, minute: 0, second: 0),
  Quote(quote: 4623.76, date: '2021-11-11', hour: 10, minute: 30, second: 0),
  Quote(quote: 4621.99, date: '2021-11-11', hour: 10, minute: 0, second: 0),
  Quote(quote: 4616.53, date: '2021-11-11', hour: 9, minute: 30, second: 0),
  Quote(quote: 4596.35, date: '2021-11-11', hour: 9, minute: 0, second: 0),
  Quote(quote: 4597.22, date: '2021-11-11', hour: 8, minute: 30, second: 0),
  Quote(quote: 4565.57, date: '2021-11-11', hour: 8, minute: 0, second: 0),
  Quote(quote: 4552.12, date: '2021-11-11', hour: 7, minute: 30, second: 0),
  Quote(quote: 4546.35, date: '2021-11-11', hour: 7, minute: 0, second: 0),
  Quote(quote: 4543.21, date: '2021-11-11', hour: 6, minute: 30, second: 0),
  Quote(quote: 4546.35, date: '2021-11-11', hour: 6, minute: 0, second: 0),
  Quote(quote: 4536.40, date: '2021-11-11', hour: 5, minute: 30, second: 0),
  Quote(quote: 4523.76, date: '2021-11-11', hour: 5, minute: 0, second: 0),
  Quote(quote: 4521.99, date: '2021-11-11', hour: 4, minute: 30, second: 0),
  Quote(quote: 4516.53, date: '2021-11-11', hour: 4, minute: 0, second: 0),
  Quote(quote: 4496.35, date: '2021-11-11', hour: 3, minute: 30, second: 0),
  Quote(quote: 4497.22, date: '2021-11-11', hour: 3, minute: 0, second: 0),
  Quote(quote: 4485.57, date: '2021-11-11', hour: 2, minute: 30, second: 0),
  Quote(quote: 4462.12, date: '2021-11-11', hour: 2, minute: 0, second: 0),
  Quote(quote: 4446.35, date: '2021-11-11', hour: 1, minute: 30, second: 0),
  Quote(quote: 4443.21, date: '2021-11-11', hour: 1, minute: 0, second: 0),
  Quote(quote: 4416.35, date: '2021-11-11', hour: 0, minute: 30, second: 0),
  Quote(quote: 4396.40, date: '2021-11-11', hour: 0, minute: 0, second: 0),
  Quote(quote: 4383.76, date: '2021-11-10', hour: 23, minute: 30, second: 0),
  Quote(quote: 4371.99, date: '2021-11-10', hour: 23, minute: 0, second: 0),
  Quote(quote: 4366.53, date: '2021-11-10', hour: 22, minute: 30, second: 0),
  Quote(quote: 4396.35, date: '2021-11-10', hour: 22, minute: 0, second: 0),
  Quote(quote: 4397.22, date: '2021-11-10', hour: 21, minute: 30, second: 0),
  Quote(quote: 4375.57, date: '2021-11-10', hour: 21, minute: 0, second: 0),
  Quote(quote: 4342.12, date: '2021-11-10', hour: 20, minute: 30, second: 0),
  Quote(quote: 4346.35, date: '2021-11-10', hour: 20, minute: 0, second: 0),
  Quote(quote: 4322.12, date: '2021-11-10', hour: 19, minute: 30, second: 0),
  Quote(quote: 4346.35, date: '2021-11-10', hour: 19, minute: 0, second: 0),
  Quote(quote: 4312.12, date: '2021-11-10', hour: 18, minute: 30, second: 0),
  Quote(quote: 4346.35, date: '2021-11-10', hour: 18, minute: 0, second: 0),
  Quote(quote: 4372.12, date: '2021-11-10', hour: 17, minute: 30, second: 0),
  Quote(quote: 4399.35, date: '2021-11-10', hour: 17, minute: 0, second: 0),
  Quote(quote: 4422.12, date: '2021-11-10', hour: 16, minute: 30, second: 0),
  Quote(quote: 4446.35, date: '2021-11-10', hour: 16, minute: 0, second: 0),
  Quote(quote: 4423.12, date: '2021-11-10', hour: 15, minute: 30, second: 0),
  Quote(quote: 4476.35, date: '2021-11-10', hour: 15, minute: 0, second: 0),
  Quote(quote: 4412.12, date: '2021-11-10', hour: 14, minute: 30, second: 0),
  Quote(quote: 4446.35, date: '2021-11-10', hour: 14, minute: 0, second: 0),
  Quote(quote: 4429.12, date: '2021-11-10', hour: 13, minute: 30, second: 0),
  Quote(quote: 4442.35, date: '2021-11-10', hour: 13, minute: 0, second: 0),
  Quote(quote: 4432.12, date: '2021-11-10', hour: 12, minute: 30, second: 0),
  Quote(quote: 4476.35, date: '2021-11-10', hour: 12, minute: 0, second: 0),
];

QuotePair mock_btcUsdPair = QuotePair(
    pair: 'BTC/USD',
    coin_name: 'BTC',
    market_val: 52224234234.43,
    change_percent: -5.21,
    quote: 66451.33,
    vol_24h: 43534566.33,
    hashrate: 'hashrate',
    quote_24h: mock_quote_24h
)..chain = 'bitcoin'
  ..coin_code = 'BTC';

QuoteCoin mock_btccoin = QuoteCoin(
  coin_code: 'BTC',
  coin_name: '比特币',
  pair: 'BTC/USD',
  change_percent: -5.21,
  change_amount: -489.33,
  quote: 66451.33,
  vol_24h: 43534566.21,
  amount_24h: 1243534566.21,
  cny: 400321.22,
  publish_date: '2021-11-11',
  market_val: 3243534566.21,
);

QuotePair mock_ethUsdPair = QuotePair(
    pair: 'ETH/USD',
    coin_name: 'ETH',
    market_val: 3242342343.4,
    change_percent: 2.32,
    quote: 4653.33,
    vol_24h: 43534566.21,
    hashrate: 'hashrate',
    quote_24h: mock_quote_24h
)..chain = 'ethereum'
  ..coin_code = 'ETH';

QuoteCoin mock_ethcoin = QuoteCoin(
  coin_code: 'ETH',
  coin_name: '以太坊',
  pair: 'ETH/USD',
  change_percent: 2.32,
  change_amount: 89.33,
  quote: 4653.33,
  vol_24h: 43534566.21,
  amount_24h: 1243534566.21,
  cny: 30321.22,
  publish_date: '2021-11-11',
  market_val: 3243534566.21,
);