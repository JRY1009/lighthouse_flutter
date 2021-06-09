
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/utils/object_util.dart';

class LeaveMessage {

  static const String SOURCE_APP = 'APP';
  static const String SOURCE_OFFICIAL_ACCOUNTS = 'OFFICIAL_ACCOUNTS';

  num? id;
  num? user_id;
  String? createdAt;
  String? nick_name;
  String? source;
  String? remark;
  String? content;
  String? head_ico;

  String? get sourceText => _getSourceText();
  String? _getSourceText() {
    if (source == SOURCE_APP) {
      return S.current.sourceFromApp;
    } else if (source == SOURCE_OFFICIAL_ACCOUNTS) {
      return S.current.sourceFromOfficialAccount;
    }
    return null;
  }

  LeaveMessage({
    this.id,
    this.user_id,
    this.createdAt,
    this.nick_name,
    this.source,
    this.remark,
    this.content,
    this.head_ico,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LeaveMessage &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  LeaveMessage.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'] ?? 0;
    user_id = jsonMap['user_id'] ?? 0;
    createdAt = jsonMap['createdAt'] ?? '';
    nick_name = jsonMap['nick_name'] ?? '';
    source = jsonMap['source'] ?? '';
    remark = jsonMap['remark'] ?? '';
    content = jsonMap['content'] ?? '';
    head_ico = jsonMap['head_ico'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['id'] = this.id;
    jsonMap['user_id'] = this.user_id;
    jsonMap['createdAt'] = this.createdAt;
    jsonMap['nick_name'] = this.nick_name;
    jsonMap['source'] = this.source;
    jsonMap['remark'] = this.remark;
    jsonMap['content'] = this.content;
    jsonMap['head_ico'] = this.head_ico;

    return jsonMap;
  }

  static List<LeaveMessage>? fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<LeaveMessage> items = [];
    for(Map<String, dynamic> map in mapList) {
      items.add(LeaveMessage.fromJson(map));
    }
    return items;
  }
}
