import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/model/area.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/router/routers.dart';
import 'package:lighthouse/ui/item/area_item.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/provider/list_provider.dart';
import 'package:lighthouse/ui/widget/button/back_button.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/widget/easyrefresh/loading_empty.dart';
import 'package:lighthouse/ui/widget/textfield/search_text_field.dart';
import 'package:provider/provider.dart';


class AreaPage extends StatefulWidget {

  final String areaCode;

  AreaPage(this.areaCode);

  @override
  _AreaPageState createState() {
    return _AreaPageState(areaCode: areaCode);
  }
}

class _AreaPageState extends State<AreaPage> with BasePageMixin<AreaPage> {

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  String areaCode;
  ListProvider<Area> _listProvider = ListProvider<Area>();
  List<Area> _allList = [];
  List<Area> _searchList = [];

  _AreaPageState({this.areaCode});

  Future<void> _refresh() async {
    return Area.loadAreaFromFile().then((value) {
      value.sort((a, b) {
        List<int> al = a.sort_name.codeUnits;
        List<int> bl = b.sort_name.codeUnits;
        for (int i = 0; i < al.length; i++) {
          if (bl.length <= i) return 1;
          if (al[i] > bl[i]) {
            return 1;
          } else if (al[i] < bl[i]) return -1;
        }
        return 0;
      });

      _allList.addAll(value);
      _listProvider.addAll(value);
      _listProvider.notify();
    });
  }

  void _selectArea(Area area) {
    setState(() {});

    areaCode = '+' + area?.code;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Routers.goBackWithParams(context, areaCode);
    });
  }

  void _search() {
    String key = _searchController.text.toLowerCase();
    _searchList.clear();
    _listProvider.clear();

    if (WidgetsBinding.instance.window.locale.toString() == 'zh_CN') {
      _allList.forEach((element) {
        if (element.cn_name.toLowerCase().contains(key) ||
            element.short_pinyin.toLowerCase().contains(key) ||
            element.first_pinyin.toLowerCase().contains(key) ||
            element.code.contains(key)) {
          _searchList.add(element);
        }
      });
    } else {
      _allList.forEach((element) {
        if (element.us_name.toLowerCase().contains(key) ||
            element.short_pinyin.contains(key) ||
            element.first_pinyin.contains(key) ||
            element.code.contains(key)) {
          _searchList.add(element);
        }
      });
    }

    if (_searchList.isEmpty) {
      _listProvider.addAll(_allList);
      _listProvider.notify();
    } else {
      _listProvider.addAll(_searchList);
      _listProvider.notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListProvider<Area>>(
      create: (_) => _listProvider,
      child: Scaffold(
          appBar: AppBar(
              leading: BackButtonEx(),
              elevation: 0.5,
              brightness: Brightness.light,
              backgroundColor: Colours.white,
              centerTitle: true,
              title: Text(S.of(context).countryArea, style: TextStyles.textBlack18)
          ),
          body: Consumer<ListProvider<Area>>(
              builder: (_, _provider, __) {
                return Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                      child: SearchTextField(
                        focusNode: _searchNode,
                        controller: _searchController,
                        onTextChanged: _search,
                      ),
                    ),
                    Expanded(child: EasyRefresh.custom(
                      header: MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main)),
                      firstRefresh: true,
                      firstRefreshWidget: FirstRefresh(),
                      emptyWidget: _listProvider.list.isEmpty ? LoadingEmpty() : null,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return AreaItem(
                                title: '+' + _provider.list[index].code + '  ' + _provider.list[index].name,
                                check: areaCode == ('+' + _provider.list[index].code),
                                onPressed: () { _selectArea(_provider.list[index]); },
                              );
                            },
                            childCount: _provider.list.length,
                          ),
                        ),
                      ],
                      onRefresh: _refresh,
                      onLoad: null,
                    ))

                  ],
                );
              }
          )

      ),
    );
  }
}
