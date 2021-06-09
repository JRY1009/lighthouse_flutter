
import 'dart:math';

import 'package:library_base/utils/num_util.dart';
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/date_util.dart';

class Quote {

  int? hour;
  int? minute;
  int? second;
  late num quote;
  String? date;

  num? open;
  num? close;
  num? high;
  num? low;
  num? vol;

  int _id = 0;
  int get id => _getIdTs();

  int _getIdTs() {
    if (_id > 0) {
      return _id;
    }

    String hourStr = hour.toString();
    if (hourStr.length < 2) {
      hourStr = '0$hourStr';
    }
    String minuteStr = minute.toString();
    if (minuteStr.length < 2) {
      minuteStr = '0$minuteStr';
    }
    String secondStr = second.toString();
    if (secondStr.length < 2) {
      secondStr = '0$secondStr';
    }

    String dateStr = '$date $hourStr:$minuteStr:$secondStr';
    int ts = ((DateUtil.getDateMsByTimeStr(dateStr) ?? 0) / 1000).floor();
    return ts;
  }

  void setTs(int ts) {
    _id = ts;
  }

  Quote({
    required this.quote,
    this.hour,
    this.minute,
    this.second,
    this.date,
  }) {

    initKlineData();
  }

  Quote.fromJson(Map<String, dynamic> jsonMap) {
    quote = jsonMap['quote'] ?? 0;
    hour = jsonMap['hour'] ?? 0;
    minute = jsonMap['minute'] ?? 0;
    second = jsonMap['second'] ?? 0;
    date = jsonMap['date'] ?? '';

    initKlineData();
  }

  initKlineData() {
    Random rng = Random();
    close = quote;

    if (rng.nextBool()) {
      open = quote + rng.nextInt(20);
    } else {
      open = quote - rng.nextInt(20);
    }
    if (open! > close!) {
      high = open! + rng.nextInt(10);
      low = close! - rng.nextInt(10);
    } else {
      high = close! + rng.nextInt(10);
      low = open! - rng.nextInt(10);
    }
    vol = NumUtil.multiply(quote, rng.nextInt(100));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['hour'] = this.hour;
    jsonMap['minute'] = this.minute;
    jsonMap['second'] = this.second;
    jsonMap['quote'] = this.quote;
    jsonMap['created_at'] = this.date;

    return jsonMap;
  }

  static List<Quote> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return [
        Quote(
            hour: 0,
            minute: 0,
            second: 0,
            quote: 0,
            date: DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.YEAR_MONTH_DAY)
        )
      ];
    }

    Quote? lastQuote;
    List<Quote> items = [];
    for(Map<String, dynamic> map in mapList) {
      Quote quote = Quote.fromJson(map);
      lastQuote?.open = quote.close;
      lastQuote = quote;
      items.add(quote);
    }
    return items;
  }
}