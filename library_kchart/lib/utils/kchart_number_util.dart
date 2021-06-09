
class KChartNumberUtil {
  static String volFormat(double n) {
    if (n > 10000 && n < 999999) {
      double d = n / 1000;
      return "${d.toStringAsFixed(2)}K";
    } else if (n > 1000000) {
      double d = n / 1000000;
      return "${d.toStringAsFixed(2)}M";
    }
    return n.toStringAsFixed(2);
  }

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

  //保留多少位小数
  static int _fractionDigits = 2;

  static set fractionDigits(int value) {
    if (value != _fractionDigits) _fractionDigits = value;
  }

  static String format(double? price) {
    return formatNum(price, point: _fractionDigits);
  }
}
