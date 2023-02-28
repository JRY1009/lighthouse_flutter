import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/global/locale_provider.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    LocaleProvider localeModel = Provider.of<LocaleProvider>(context);

    Widget _buildLanguageItem(String lan, value) {
      return ListTile(
        tileColor: Colours.white,
        title: Text(
          lan,
          // 对APP当前语言进行高亮显示
          style: TextStyle(
              color: localeModel.locale == value ? Colours.app_main : Colours.gray_800,
              fontSize: 14
          ),
        ),
        trailing: localeModel.locale == value ? Icon(Icons.done, color: Colours.app_main) : null,
        onTap: () {
          // 此行代码会通知MaterialApp重新build
          localeModel.locale = value;
        },
      );
    }

    return Scaffold(
        backgroundColor: Colours.normal_bg,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            backgroundColor: Colours.white,
            centerTitle: true,
            title: Text(S.of(context).language, style: TextStyles.textBlack16)
        ),
        body: Padding(

          padding: const EdgeInsets.only(top: 8.0),
          child: ListView(
            itemExtent: 48,
            children: ListTile.divideTiles(
                context: context,
                color: Colours.default_line,
                tiles: [
                  _buildLanguageItem(S.of(context).english, "en"),
                  _buildLanguageItem(S.of(context).chinese, "zh_CN"),
                  _buildLanguageItem(S.of(context).auto, ''),
                ]
            ).toList()
          )
        )
    );
  }
}
