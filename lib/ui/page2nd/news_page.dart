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

  final bool supportPullRefresh;  //是否支持手动下拉刷新

  NewsPage({this.supportPullRefresh = true});

  @override
  _NewsPageState createState() {
    return _NewsPageState(supportPullRefresh: supportPullRefresh);
  }
}

class _NewsPageState extends State<NewsPage> {

  bool supportPullRefresh;

  EasyRefreshController _controller = EasyRefreshController();
  ListProvider<News> _listProvider = ListProvider<News>();
  int _page = 0;
  int _pageSize = 10;

  _NewsPageState({this.supportPullRefresh});

  Future<void> _refresh() async {
    _page = 0;
    await _requestData();
  }

  Future<void> _loadMore() async {
    _page ++;
    await _requestData();
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
      _listProvider.notify();
    } else {
      _controller.finishLoad(success: success, noMore: noMore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListProvider<News>>(
      create: (_) => _listProvider,
      child: Scaffold(
          body: Consumer<ListProvider<News>>(
              builder: (_, _provider, __) {
                return Column(
                  children: <Widget>[
                    Expanded(child: EasyRefresh.custom(
                      header: supportPullRefresh ? BallPulseHeader(color: Colours.app_main) : null,
                      footer:  CommonFooter(),
                      topBouncing: false,
                      bottomBouncing: false,
                      controller: _controller,
                      firstRefresh: true,
                      firstRefreshWidget: FirstRefresh(),
                      emptyWidget: _listProvider.list.isEmpty ? LoadingEmpty() : null,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return NewsItem(
                                title: _provider.list[index].account_name,
                                time: _provider.list[index].created_at,
                                author: _provider.list[index].city,
                                imageUrl: _provider.list[index].avatar_300,
                              );
                            },
                            childCount: _provider.list.length,
                          ),
                        ),
                      ],
                      onRefresh: _refresh,
                      onLoad: _loadMore,
                    ))

                  ],
                );
              }
          )

      ),
    );
  }
}
