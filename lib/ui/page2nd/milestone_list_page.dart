import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/milestone.dart';
import 'package:lighthouse/net/model/news.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/ui/item/article_item.dart';
import 'package:lighthouse/ui/item/milestone_item.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/provider/list_provider.dart';
import 'package:lighthouse/ui/widget/easyrefresh/common_footer.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/widget/easyrefresh/loading_empty.dart';
import 'package:lighthouse/utils/toast_util.dart';
import 'package:provider/provider.dart';


class MileStoneListPage extends StatefulWidget {
  
  final bool isSupportPull;  //是否支持手动下拉刷新

  MileStoneListPage({
    Key key,
    this.isSupportPull = true
  }) : super(key: key);

  @override
  _MileStoneListPageState createState() {
    return _MileStoneListPageState(isSupportPull: isSupportPull);
  }
}

class _MileStoneListPageState extends State<MileStoneListPage> with BasePageMixin<MileStoneListPage>, AutomaticKeepAliveClientMixin<MileStoneListPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  bool isSupportPull;

  EasyRefreshController _easyController = EasyRefreshController();
  ListProvider<MileStone> _listProvider = ListProvider<MileStone>();
  int _page = 0;
  int _pageSize = 20;
  bool _init = false;

  _MileStoneListPageState({
    this.isSupportPull
  });

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  @override
  void dispose() {
    _easyController.dispose();
    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    if (slient) {
      _page = 0;
      return _requestData();

    } else {
      return Future<void>.delayed(const Duration(milliseconds: 100), () {
        _easyController.callRefresh();
      });
    }
  }

  Future<void> _refresh() {
    _page = 0;
    _requestData();
  }

  Future<void> _loadMore() {
    _page ++;
    _requestData();
  }

  Future<void> _requestData() {
    Map<String, dynamic> params = {
      'tag': 'bitcoin',
      'page_num': _page,
      'page_size': _pageSize,
    };

    return DioUtil.getInstance().get(Constant.URL_GET_MILESTONES, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            _finishRequest(success: false, noMore: false);
            return;
          }

          List<MileStone> newsList = MileStone.fromJsonList(data['data']['records']) ?? [];
          if (_page == 0) {
            _listProvider.clear();
            _listProvider.addAll(newsList);

          } else {
            _listProvider.addAll(newsList);
          }

          _finishRequest(success: true, noMore: newsList?.length < _pageSize);
        },
        errorCallBack: (error) {
          _finishRequest(success: false, noMore: false);
          ToastUtil.error(error[Constant.MESSAGE]);
        });
  }

  void _finishRequest({bool success, bool noMore}) {
    if (_page == 0) {
      if (success) {
        _easyController.resetLoadState();
      }
      _easyController.finishRefresh(success: success, noMore: noMore);
    } else {
      _easyController.finishLoad(success: success, noMore: noMore);
    }

    if (!_init) {
      _init = true;
    }

    _listProvider.notify(noMore: noMore);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider<ListProvider<MileStone>>(
        create: (_) => _listProvider,
        child: Consumer<ListProvider<MileStone>>(
            builder: (_, _provider, __) {
              return !_init ? FirstRefresh() : EasyRefresh(
                header: isSupportPull ? MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main)) : null,
                footer:  CommonFooter(enableInfiniteLoad: !_provider.noMore),
                controller: _easyController,
//                firstRefresh配合NestedScrollView使用会造成刷新跳动问题
//                firstRefresh: true,
//                firstRefreshWidget: FirstRefresh(),
                topBouncing: false,
                emptyWidget: _listProvider.list.isEmpty ? LoadingEmpty() : null,
                child: ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return MileStoneItem(
                      index: index,
                      content: _provider.list[index].content,
                      time: _provider.list[index].date,
                      isLast: index == (_provider.list.length - 1),
                    );
                  },
                  itemCount: _provider.list.length,
                ),

                onRefresh: isSupportPull ? _refresh : null,
                onLoad: _loadMore,
              );
            }
        )
    );
  }
}
