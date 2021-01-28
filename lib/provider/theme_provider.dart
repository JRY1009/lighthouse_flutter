import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/utils/sp_util.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => ['system', 'light', 'dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  
  void syncTheme() {
    final String theme = SPUtil.getString(SPUtil.key_theme);
    if (theme.isNotEmpty && theme != ThemeMode.system.value) {
      notifyListeners();
    }
  }

  void changeTheme(ThemeMode themeMode) {
    SPUtil.putString(SPUtil.key_theme, themeMode.value);
    notifyListeners();
  }

  ThemeMode getThemeMode(){
    final String theme = SPUtil.getString(SPUtil.key_theme);
    switch(theme) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData getThemeData({bool isDarkMode = false}) {
    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
    );
  }

}