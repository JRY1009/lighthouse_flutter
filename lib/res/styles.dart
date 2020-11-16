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

  static const TextStyle textBlack20 = TextStyle(
    fontSize: 20.0,
    color: Colours.text_black,
  );

  static const TextStyle textBlack18 = TextStyle(
    fontSize: 18.0,
    color: Colours.text_black,
  );

  static const TextStyle textBlack16 = TextStyle(
    fontSize: 16.0,
    color: Colours.text_black,
  );

  static const TextStyle textBlack14 = TextStyle(
    fontSize: 14.0,
    color: Colours.text_black,
  );

  static const TextStyle textWhite14 = TextStyle(
    fontSize: 14.0,
    color: Colours.white,
  );

  static const TextStyle textWhite15 = TextStyle(
    fontSize: 15.0,
    color: Colours.white,
  );

  static const TextStyle textWhite16 = TextStyle(
    fontSize: 16.0,
    color: Colours.white,
  );

  static const TextStyle textWhite24 = TextStyle(
    fontSize: 24.0,
    color: Colours.white,
  );

  static const TextStyle textGray800_w400_17 = TextStyle(
      color: Colours.gray_800,
      fontWeight: FontWeight.w400,
      fontSize: 17
  );

  static const TextStyle textGray800_w400_16 = TextStyle(
      color: Colours.gray_800, fontWeight: FontWeight.w400, fontSize: 16
  );

  static const TextStyle textGray800_w400_15 = TextStyle(
      color: Colours.gray_800, fontWeight: FontWeight.w400, fontSize: 15
  );

  static const TextStyle textGray800_w400_14 = TextStyle(
      color: Colours.gray_800, fontWeight: FontWeight.w400, fontSize: 14
  );

  static const TextStyle textGray800_w400_12 = TextStyle(
      color: Colours.gray_800, fontWeight: FontWeight.w400, fontSize: 12
  );

  static const TextStyle textGray500_w400_12 = TextStyle(
      color: Colours.gray_500, fontWeight: FontWeight.w400, fontSize: 12
  );

  static const TextStyle textGray500_w400_14 = TextStyle(
      color: Colours.gray_500, fontWeight: FontWeight.w400, fontSize: 14
  );

  static const TextStyle textGray400_w400_16 = TextStyle(
      color: Colours.gray_400, fontWeight: FontWeight.w400, fontSize: 16
  );

  static const TextStyle textGray400_w400_14 = TextStyle(
      color: Colours.gray_400, fontWeight: FontWeight.w400, fontSize: 14
  );

  static const TextStyle textGray400_w400_12 = TextStyle(
      color: Colours.gray_400, fontWeight: FontWeight.w400, fontSize: 12
  );

  static const TextStyle textRed400_w400_12 = TextStyle(
      color: Colours.text_red, fontWeight: FontWeight.w400, fontSize: 12
  );

  static const TextStyle textRed400_w400_15 = TextStyle(
      color: Colours.text_red, fontWeight: FontWeight.w400, fontSize: 15
  );

  static const TextStyle textRed400_w400_22 = TextStyle(
      color: Colours.text_red, fontWeight: FontWeight.w400, fontSize: 22
  );

  static const TextStyle textGreen400_w400_12 = TextStyle(
      color: Colours.text_green, fontWeight: FontWeight.w400, fontSize: 12
  );

  static const TextStyle textGreen400_w400_15 = TextStyle(
      color: Colours.text_green, fontWeight: FontWeight.w400, fontSize: 15
  );

  static const TextStyle textGreen400_w400_22 = TextStyle(
      color: Colours.text_green, fontWeight: FontWeight.w400, fontSize: 22
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

  static const UnderlineInputBorder underlineInputMain = UnderlineInputBorder(
      borderSide:  BorderSide(color: Colours.app_main)
  );

  static const UnderlineInputBorder underlineInputGray = UnderlineInputBorder(
      borderSide:  BorderSide(color: Colours.border_gray)
  );
}

class BoxShadows {

  static const List<BoxShadow> normalBoxShadow = [
    BoxShadow(
      color: Colours.normal_border_shadow,
      offset: Offset(0.0, 4.0),
      blurRadius: 30.0,
      spreadRadius: 0.0,
    ),
  ];
}
