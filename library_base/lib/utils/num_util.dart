import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';

/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Num Util.
 * @Date: 2018/9/18
 */

/// Num Util.
class NumUtil {
  /// 数字千位符，小数点，金额格式化
  /// @param num：传入数据
  /// @param point：小数位 默认为两位
  /// @param point：forcePoint 强制保留小数位
  static String formatNum(num, {point = 2, bool forcePoint = true}) {
    if (num != null && num != "null") {
      String str = double.parse(num.toString()).toString();

      // 分开截取
      List<String> sub = str.split('.');

      // 处理值
      List<String> val = [];
      if (sub.isNotEmpty) {
        val = List.from(sub[0].split(''));
      }
//      LogUtil.v("val=$val");
      // 处理点
      List<String> points = [];
      if (sub.length > 1) {
        points = List.from(sub[1].split(''));
      }
      //处理分割符
      for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
//        LogUtil.v("val index=$index i=$i ${val[i]} ");
        // 除以三没有余数、不等于零并且不等于1 就加个逗号
        if (index % 3 == 0 && index != 0 && val[i] != '-') {
          val[i] = val[i] + ',';
        }
      }

//      // 处理小数点
      for (int i = 0; i <= point - points.length; i++) {
        points.add('0');
      }
      //如果大于长度就截取
      if (points.length > point) {
        // 截取数组
        points = points.sublist(0, point);
      }

      //去掉小数点后面的000
      // 判断是否有长度
      if (points.isNotEmpty &&
          (forcePoint || (!forcePoint && int.parse(points.join("")) > 0))) {
        return '${val.join('')}.${points.join('')}';
      } else {
        return val.join('');
      }
    } else {
      return "0.00";
    }
  }
  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueStr(String valueStr, {int? fractionDigits}) {
    double? value = double.tryParse(valueStr);
    return fractionDigits == null
        ? value
        : getNumByValueDouble(value, fractionDigits);
  }

  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueDouble(double? value, int? fractionDigits) {
    if (value == null) return null;
    String valueStr = value.toStringAsFixed(fractionDigits!);
    return fractionDigits == 0
        ? int.tryParse(valueStr)
        : double.tryParse(valueStr);
  }

  /// get int by value str.
  static int getIntByValueStr(String valueStr, {int defValue = 0}) {
    return int.tryParse(valueStr) ?? defValue;
  }

  /// get double by value str.
  static double getDoubleByValueStr(String valueStr, {double defValue = 0}) {
    return double.tryParse(valueStr) ?? defValue;
  }

  ///isZero
  static bool isZero(num value) {
    return value == null || value == 0;
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static double add(num a, num b) {
    return addDec(a, b).toDouble();
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static double subtract(num a, num b) {
    return subtractDec(a, b).toDouble();
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static double multiply(num a, num b) {
    return multiplyDec(a, b).toDouble();
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static double divide(num a, num b) {
    return divideDec(a, b).toDouble();
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static Decimal addDec(num a, num b) {
    return addDecStr(a.toString(), b.toString());
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static Decimal subtractDec(num a, num b) {
    return subtractDecStr(a.toString(), b.toString());
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static Decimal multiplyDec(num a, num b) {
    return multiplyDecStr(a.toString(), b.toString());
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static Decimal divideDec(num a, num b) {
    return divideDecStr(a.toString(), b.toString());
  }

  /// 余数
  static Decimal remainder(num a, num b) {
    return remainderDecStr(a.toString(), b.toString());
  }

  /// Relational less than operator.
  static bool lessThan(num a, num b) {
    return lessThanDecStr(a.toString(), b.toString());
  }

  /// Relational less than or equal operator.
  static bool thanOrEqual(num a, num b) {
    return thanOrEqualDecStr(a.toString(), b.toString());
  }

  /// Relational greater than operator.
  static bool greaterThan(num a, num b) {
    return greaterThanDecStr(a.toString(), b.toString());
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqual(num a, num b) {
    return greaterOrEqualDecStr(a.toString(), b.toString());
  }

  /// 加
  static Decimal addDecStr(String a, String b) {
    return Decimal.parse(a) + Decimal.parse(b);
  }

  /// 减
  static Decimal subtractDecStr(String a, String b) {
    return Decimal.parse(a) - Decimal.parse(b);
  }

  /// 乘
  static Decimal multiplyDecStr(String a, String b) {
    return Decimal.parse(a) * Decimal.parse(b);
  }

  /// 除
  static Decimal divideDecStr(String a, String b) {
    return Decimal.parse(a) / Decimal.parse(b);
  }

  /// 余数
  static Decimal remainderDecStr(String a, String b) {
    return Decimal.parse(a) % Decimal.parse(b);
  }

  /// Relational less than operator.
  static bool lessThanDecStr(String a, String b) {
    return Decimal.parse(a) < Decimal.parse(b);
  }

  /// Relational less than or equal operator.
  static bool thanOrEqualDecStr(String a, String b) {
    return Decimal.parse(a) <= Decimal.parse(b);
  }

  /// Relational greater than operator.
  static bool greaterThanDecStr(String a, String b) {
    return Decimal.parse(a) > Decimal.parse(b);
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqualDecStr(String a, String b) {
    return Decimal.parse(a) >= Decimal.parse(b);
  }

  static String getBigVolumFormat(double volum, {int? fractionDigits}) {
    if (volum == null) {
      return '0';
    }

    String result;
    String language = WidgetsBinding.instance!.window.locale.toString();

    if (language.toLowerCase().contains('zh')) {
      if (volum >= 100000000) {
        volum = divide(volum, 100000000);
        result = getNumByValueDouble(volum, fractionDigits).toString() + "亿";
      } else if (volum > 10000) {
        volum = divide(volum, 10000);
        result = getNumByValueDouble(volum, fractionDigits).toString() + "万";
      } else {
        result = getNumByValueDouble(volum, fractionDigits).toString() ;
      }
    } else {
      if (volum >= 1000000) {
        volum = divide(volum, 1000000);
        result = getNumByValueDouble(volum, fractionDigits).toString() + "M";
      } else if (volum > 1000) {
        volum = divide(volum, 1000);
        result = getNumByValueDouble(volum, fractionDigits).toString() + "K";
      } else {
        result = getNumByValueDouble(volum, fractionDigits).toString() ;
      }
    }

    return result;
  }

}
