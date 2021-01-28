
import 'package:library_base/utils/object_util.dart';

class TreeNode {

  String code;
  String zh_name;
  int market_val;    //市值
  double change_percent;//涨幅

  int get color_index => _getColorIndex();

  int _getColorIndex() {
    if (change_percent > 0 && change_percent < 1.0) {
      return 0;
    } else if (change_percent >= 1.0 && change_percent < 3.0) {
      return 1;
    } else if (change_percent >= 3.0) {
      return 2;
    } else if (change_percent == 0) {
      return 4;
    } else if (change_percent < 0 && change_percent >= -1.0) {
      return 4;
    } else if (change_percent < -1.0 && change_percent >= -3.0) {
      return 5;
    } else if (change_percent < -3.0) {
      return 6;
    }
  }

  TreeNode({
    this.code,
    this.zh_name,
    this.market_val,
    this.change_percent,
  });

  TreeNode.fromJson(Map<String, dynamic> jsonMap) {
    code = jsonMap['code'];
    zh_name = jsonMap['zh_name'];
    market_val = jsonMap['market_val'];
    change_percent = jsonMap['change_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['code'] = this.code;
    jsonMap['zh_name'] = this.zh_name;
    jsonMap['market_val'] = this.market_val;
    jsonMap['change_percent'] = this.change_percent;

    return jsonMap;
  }

  static List<TreeNode> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<TreeNode> items = new List<TreeNode>();
    for(Map<String, dynamic> map in mapList) {
      items.add(TreeNode.fromJson(map));
    }
    return items;
  }
}
