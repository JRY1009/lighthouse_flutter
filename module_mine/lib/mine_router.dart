
import 'package:flutter/material.dart';
import 'package:library_base/router/i_router.dart';
import 'package:library_base/router/page_builder.dart';
import 'package:library_base/router/routers.dart';
import 'package:module_mine/page/about_page.dart';
import 'package:module_mine/page/area_page.dart';
import 'package:module_mine/page/bind_phone_page.dart';
import 'package:module_mine/page/forget_pwd_page.dart';
import 'package:module_mine/page/language_page.dart';
import 'package:module_mine/page/login_page.dart';
import 'package:module_mine/page/login_sms_page.dart';
import 'package:module_mine/page/mine_page.dart';
import 'package:module_mine/page/modify_nickname_page.dart';
import 'package:module_mine/page/modify_pwd_page.dart';
import 'package:module_mine/page/set_pwd_page.dart';
import 'package:module_mine/page/setting_page.dart';

class MineRouter implements IRouter{

  static bool isRunModule = false;

  @override
  List<PageBuilder> getPageBuilders() {
    return [
      PageBuilder(Routers.minePage, (params) {
        Key? key = params?.getObj('key');
        return MinePage(key: key);
      }),

      PageBuilder(Routers.areaPage, (params) {
        String? areaCode = params?.getString('areaCode');
        return AreaPage(areaCode);
      }),

      PageBuilder(Routers.loginPage, (params) {
        String? phone = params?.getString('phone');
        bool agreeChecked = params?.getBool('agreeChecked') ?? false;
        return LoginPage(phone: phone, agreeChecked: agreeChecked);
      }),

      PageBuilder(Routers.loginSmsPage, (params) {
        String? phone = params?.getString('phone');
        bool agreeChecked = params?.getBool('agreeChecked') ?? false;
        return LoginSmsPage(phone: phone, agreeChecked: agreeChecked);
      }),

      PageBuilder(Routers.aboutPage, (_) => AboutPage()),
      PageBuilder(Routers.settingPage, (_) => SettingPage()),
      PageBuilder(Routers.modifyNicknamePage, (_) => ModifyNicknamePage()),
      PageBuilder(Routers.setPwdPage, (_) => SetPwdPage()),
      PageBuilder(Routers.modifyPwdPage, (_) => ModifyPwdPage()),
      PageBuilder(Routers.forgetPwdPage, (_) => ForgetPwdPage()),
      PageBuilder(Routers.languagePage, (_) => LanguagePage()),
      PageBuilder(Routers.bindPhonePage, (_) => BindPhonePage()),
    ];
  }
}