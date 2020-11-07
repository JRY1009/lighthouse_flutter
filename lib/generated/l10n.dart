// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Login`
  String get welcomeLogin {
    return Intl.message(
      'Welcome Login',
      name: 'welcomeLogin',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Regist`
  String get welcomeRegist {
    return Intl.message(
      'Welcome Regist',
      name: 'welcomeRegist',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get loginPhone {
    return Intl.message(
      'Phone Number',
      name: 'loginPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get loginPhoneHint {
    return Intl.message(
      'Please enter your phone number',
      name: 'loginPhoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Phone number cannot be empty!`
  String get loginPhoneError {
    return Intl.message(
      'Phone number cannot be empty!',
      name: 'loginPhoneError',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passwordHint {
    return Intl.message(
      'Please enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be less than 6 digits!`
  String get passwordError {
    return Intl.message(
      'Password cannot be less than 6 digits!',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get forgetPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login Success`
  String get loginSuccess {
    return Intl.message(
      'Login Success',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Password`
  String get repeatPassword {
    return Intl.message(
      'Repeat Password',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register Success`
  String get registerSuccess {
    return Intl.message(
      'Register Success',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `没有账号？`
  String get noAccount {
    return Intl.message(
      '没有账号？',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `点此注册`
  String get clickRegister {
    return Intl.message(
      '点此注册',
      name: 'clickRegister',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}