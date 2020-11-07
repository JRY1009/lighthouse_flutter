import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// EnDecode Util.
class EncryptUtil {
  /// md5 加密
  static String encodeMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  /// aes加密
  static String encodeAes(String data, String key, String vector) {
    final encrypter = Encrypter(AES(Key.fromUtf8(key)));
    final encrypted = encrypter.encrypt(data, iv: IV.fromUtf8(vector));
    return encrypted.base16;
  }

  /// Base64加密
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /// Base64解密
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }
}
