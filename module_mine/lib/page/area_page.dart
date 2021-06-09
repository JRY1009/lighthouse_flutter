import 'dart:async';

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/textfield/search_text_field.dart';
import 'package:module_mine/item/area_item.dart';
import 'package:module_mine/model/area.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class AreaPage extends StatefulWidget {

  final String? areaCode;

  AreaPage(this.areaCode);

  @override
  _AreaPageState createState() {
    return _AreaPageState(areaCode: areaCode);
  }
}

class _AreaPageState extends State<AreaPage> with BasePageMixin<AreaPage> {

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  String? areaCode;
  List<Area> _currentList = [];
  List<Area> _allList = [];
  List<Area> _searchList = [];

  RefreshController _easyController = RefreshController();
  bool _init = false;

  _AreaPageState({this.areaCode});

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        _refresh();
      }
    });
  }

  Future<void> _refresh() async {
    return Area.loadAreaFromFile().then((value) {
      value!.sort((a, b) {
        List<int> al = a.sort_name!.codeUnits;
        List<int> bl = b.sort_name!.codeUnits;
        for (int i = 0; i < al.length; i++) {
          if (bl.length <= i) return 1;
          if (al[i] > bl[i]) {
            return 1;
          } else if (al[i] < bl[i]) return -1;
        }
        return 0;
      });

      _init = true;
      _allList.addAll(value);
      _currentList.addAll(value);
      setState(() {});
    });
  }

  void _selectArea(Area area) {
    setState(() {});

    areaCode = '+' + area.code!;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Routers.goBackWithParams(context, areaCode!);
    });
  }

  void _search() {
    String key = _searchController.text.toLowerCase();
    _searchList.clear();
    _currentList.clear();

    if (WidgetsBinding.instance!.window.locale.toString() == 'zh_CN') {
      _allList.forEach((element) {
        if (element.cn_name!.toLowerCase().contains(key) ||
            element.short_pinyin.toLowerCase().contains(key) ||
            element.first_pinyin.toLowerCase().contains(key) ||
            element.code!.contains(key)) {
          _searchList.add(element);
        }
      });
    } else {
      _allList.forEach((element) {
        if (element.us_name!.toLowerCase().contains(key) ||
            element.short_pinyin.contains(key) ||
            element.first_pinyin.contains(key) ||
            element.code!.contains(key)) {
          _searchList.add(element);
        }
      });
    }

    if (_searchList.isEmpty) {
      _currentList.addAll(_allList);
    } else {
      _currentList.addAll(_searchList);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0.5,
            brightness: Brightness.light,
            backgroundColor: Colours.white,
            centerTitle: true,
            title: Text(S.of(context).countryArea, style: TextStyles.textBlack18)
        ),
        body: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: SearchTextField(
                focusNode: _searchNode,
                controller: _searchController,
                onTextChanged: _search,
              ),
            ),
            Expanded(
              child: !_init ? FirstRefresh() : SmartRefresher(
                  controller: _easyController,
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return AreaItem(
                              title: '+' + _currentList[index].code! + '  ' + _currentList[index].name!,
                              check: areaCode == ('+' + _currentList[index].code!),
                              onPressed: () { _selectArea(_currentList[index]); },
                            );
                          },
                          childCount: _currentList.length,
                        ),
                      ),
                    ],
                  )
              ),
            )
          ],
        )
    );
  }
}
