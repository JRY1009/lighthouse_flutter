
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/utils/sp_util.dart';

///语言
class LocaleProvider with ChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale? getLocale() {
    if (_locale == null || _locale.isEmpty) return null;
    var t = _locale.split("_");
    return Locale(t[0], t.length > 1 ? t[1] : null);
  }

  String _locale;

  LocaleProvider(this._locale);

  // 获取当前Locale的字符串表示
  String get locale => _locale;
  String get localeName => _getLocaleName();

  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  set locale(String locale) {
    if (_locale != locale) {
      _locale = locale;
      SPUtil.putString(SPUtil.key_locale, _locale);
      notifyListeners();
    }
  }


  String _getLocaleName() {
    switch(_locale) {
      case 'en':
        return S.current.english;
      case 'zh_CN':
        return S.current.chinese;
      default:
        return S.current.auto;
    }
  }
}