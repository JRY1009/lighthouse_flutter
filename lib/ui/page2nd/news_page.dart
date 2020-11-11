import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lighthouse/constant/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/news.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/ui/item/news_item.dart';
import 'package:lighthouse/ui/provider/list_provider.dart';
import 'package:lighthouse/ui/widget/easyrefresh/common_footer.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/widget/easyrefresh/loading_empty.dart';
import 'package:lighthouse/utils/toast_util.dart';
import 'package:provider/provider.dart';


class NewsPage extends StatefulWidget {


  final bool isSupportPull;  //是否支持手动下拉刷新

  NewsPage({
    Key key,
    this.isSupportPull = true
  }) : super(key: key);

  @override
  NewsPageState createState() {
    return NewsPageState(isSupportPull: isSupportPull);
  }
}

class NewsPageState extends State<NewsPage> with AutomaticKeepAliveClientMixin<NewsPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  bool isSupportPull;

  EasyRefreshController _controller = EasyRefreshController();
  ListProvider<News> _listProvider = ListProvider<News>();
  int _page = 0;
  int _pageSize = 10;
  bool _init = false;

  NewsPageState({
    this.isSupportPull
  });

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> refresh({showHeader = false}) {
    if (showHeader) {
      _controller.callRefresh();
    } else {
      _page = 0;
      return _requestData();
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
      'auth': 1,
      'sort': 1,
      'page': _page,
      'page_size': _pageSize,
    };

    return DioUtil.getInstance().post(Constant.URL_GET_NEWS, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            _finishRequest(success: false, noMore: false);
            return;
          }

          List<News> newsList = News.fromJsonList(data['data']['account_info']);
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
        _controller.resetLoadState();
      }
      _controller.finishRefresh(success: success, noMore: noMore);
    } else {
      _controller.finishLoad(success: success, noMore: noMore);
    }

    if (!_init) {
      _init = true;
    }

    _listProvider.notify(noMore: noMore);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListProvider<News>>(
        create: (_) => _listProvider,
        child: Consumer<ListProvider<News>>(
            builder: (_, _provider, __) {
              return !_init ? FirstRefresh() : EasyRefresh(
                header: isSupportPull ? MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main)) : null,
                footer:  CommonFooter(enableInfiniteLoad: !_provider.noMore),
                controller: _controller,
//                firstRefresh配合NestedScrollView使用会造成刷新跳动问题
//                firstRefresh: true,
//                firstRefreshWidget: FirstRefresh(),
                topBouncing: false,
                emptyWidget: _listProvider.list.isEmpty ? LoadingEmpty() : null,
                child: ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return NewsItem(
                      title: _provider.list[index].account_name,
                      time: _provider.list[index].created_at,
                      author: _provider.list[index].city,
                      imageUrl: _provider.list[index].avatar_300,
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
