

import 'package:library_base/utils/date_util.dart';

class TimeCountUtil {


  static int ONE_MINUTE = 60000;
  static int ONE_HOUR = 3600000;
  static int ONE_DAY = 86400000;
  static int ONE_WEEK = 604800000;

  static String ONE_SECOND_AGO = "秒前";
  static String ONE_MINUTE_AGO = "分钟前";
  static String ONE_HOUR_AGO = "小时前";
  static String ONE_DAY_AGO = "天前";
  static String ONE_MONTH_AGO = "月前";
  static String ONE_YEAR_AGO = "年前";

  static String? formatDateStr(String dateStr, {DateFormat format = DateFormat.NORMAL}) {
    return DateUtil.getDateStrByDateTime(DateUtil.getDateTime(dateStr, isUtc: false), format: format);
  }

  static String? formatStr(String dateStr) {
    return format(DateUtil.getDateTime(dateStr, isUtc: false));
  }

  //时间转换
  static String? format(DateTime? date) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int p = date?.millisecondsSinceEpoch ?? 0;
    int delta = now - p;
    if (delta < 1 * ONE_MINUTE) {
      int seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toString() + ONE_SECOND_AGO;
    }
    if (delta < 60 * ONE_MINUTE) {
      int minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toString() + ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      int hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toString() + ONE_HOUR_AGO;
    } else {
      return DateUtil.getDateStrByDateTime(date, format: DateFormat.MONTH_DAY_HOUR_MINUTE);
    }
//        if (delta < 30L * ONE_DAY) {
//            long days = toDays(delta);
//            return (days <= 0 ? 1 : days) + ONE_DAY_AGO;
//        }
//        if (delta < 12L * 4L * ONE_WEEK) {
//            long months = toMonths(delta);
//            return (months <= 0 ? 1 : months) + ONE_MONTH_AGO;
//        } else {
//            long years = toYears(delta);
//            return (years <= 0 ? 1 : years) + ONE_YEAR_AGO;
//        }
  }

  static int toSeconds(int date) {
    return (date / 1000).toInt();
  }

  static int toMinutes(int date) {
    return (toSeconds(date) / 60).toInt();
  }

  static int toHours(int date) {
    return (toMinutes(date) / 60).toInt();
  }

  static int toDays(int date) {
    return (toHours(date) / 24).toInt();
  }

  static int toMonths(int date) {
    return (toDays(date) / 30).toInt();
  }

  static int toYears(int date) {
    return (toMonths(date) / 365).toInt();
  }
}