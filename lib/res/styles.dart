import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';

class TextStyles {

  static const TextStyle textMain16 = TextStyle(
    fontSize: 16.0,
    color: Colours.app_main,
  );

  static const TextStyle textMain14 = TextStyle(
    fontSize: 14.0,
    color: Colours.app_main,
  );

  static const TextStyle textBlackBold26 = TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: Colours.text_black,
  );

  static const TextStyle textBlack18 = TextStyle(
    fontSize: 18.0,
    color: Colours.text_black,
  );

  static const TextStyle textBlack14 = TextStyle(
    fontSize: 14.0,
    color: Colours.text_black,
  );

  static const TextStyle textGray14 = TextStyle(
    fontSize: 14.0,
    color: Colours.text_gray,
  );

  static const TextStyle textWhite14 = TextStyle(
    fontSize: 14.0,
    color: Colours.white,
  );

  static const TextStyle textWhite16 = TextStyle(
    fontSize: 16.0,
    color: Colours.white,
  );
}

class BorderStyles {

  static const OutlineInputBorder outlineInputR50Main = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide:  BorderSide(color: Colours.app_main)
  );

  static const OutlineInputBorder outlineInputR50Gray = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide:  BorderSide(color: Colours.border_gray)
  );
}