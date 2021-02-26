
import 'package:library_base/utils/object_util.dart';
import 'package:library_base/utils/date_util.dart';

class Quote {

  int hour;
  int minute;
  int second;
  double quote;
  String date;

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
    int ts = (DateUtil.getDateMsByTimeStr(dateStr) / 1000).floor();
    return ts;
  }

  void setTs(int ts) {
    _id = ts;
  }

  Quote({
    this.hour,
    this.minute,
    this.second,
    this.quote,
    this.date,
  });

  Quote.fromJson(Map<String, dynamic> jsonMap) {
    hour = jsonMap['hour'] ?? 0;
    minute = jsonMap['minute'] ?? 0;
    second = jsonMap['second'] ?? 0;
    quote = jsonMap['quote'];
    date = jsonMap['date'];
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

    List<Quote> items = new List<Quote>();
    for(Map<String, dynamic> map in mapList) {
      items.add(Quote.fromJson(map));
    }
    return items;
  }
}