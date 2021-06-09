import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  SPUtil._internal();

  static const String key_theme = 'key_theme';
  static const String key_locale = 'key_locale';
  static const String key_latest_account = 'key_latest_account';
  static const String key_first_login = 'key_first_login';
  static const String key_old_version = 'key_old_version';

  static SharedPreferences? _spf;

  static Future<SharedPreferences?> init() async {
    if (_spf == null) {
      _spf = await SharedPreferences.getInstance();
    }
    return _spf;
  }

  /// put object.
  static Future<bool>? putObject(String key, Object value) {
    if (_spf == null) return null;
    return _spf!.setString(key, value == null ? "" : json.encode(value));
  }

  /// get obj.
  static T? getObj<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map? getObject(String key) {
    if (_spf == null) return null;
    String? _data = _spf!.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// get string.
  static String getString(String key, {String defValue = ''}) {
    if (_spf == null) return defValue;
    return _spf!.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool>? putString(String key, String value) {
    if (_spf == null) return null;
    return _spf!.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    if (_spf == null) return defValue;
    return _spf!.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool>? putBool(String key, bool value) {
    if (_spf == null) return null;
    return _spf!.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue = 0}) {
    if (_spf == null) return defValue;
    return _spf!.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool>? putInt(String key, int value) {
    if (_spf == null) return null;
    return _spf!.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_spf == null) return defValue;
    return _spf!.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool>? putDouble(String key, double value) {
    if (_spf == null) return null;
    return _spf!.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_spf == null) return defValue;
    return _spf!.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool>? putStringList(String key, List<String> value) {
    if (_spf == null) return null;
    return _spf!.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object? defValue}) {
    if (_spf == null) return defValue;
    return _spf!.get(key) ?? defValue;
  }

  /// have key.
  static bool? haveKey(String key) {
    if (_spf == null) return null;
    return _spf!.getKeys().contains(key);
  }

  /// get keys.
  static Set<String>? getKeys() {
    if (_spf == null) return null;
    return _spf!.getKeys();
  }

  /// remove.
  static Future<bool>? remove(String key) {
    if (_spf == null) return null;
    return _spf!.remove(key);
  }

  /// clear.
  static Future<bool>? clear() {
    if (_spf == null) return null;
    return _spf!.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _spf != null;
  }
}
