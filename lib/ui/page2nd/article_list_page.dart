import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/article.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/ui/item/article_card_item.dart';
import 'package:lighthouse/ui/item/article_item.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/provider/list_provider.dart';
import 'package:lighthouse/ui/widget/easyrefresh/common_footer.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh_top.dart';
import 'package:lighthouse/ui/widget/easyrefresh/loading_empty_top.dart';
import 'package:lighthouse/utils/toast_util.dart';
import 'package:provider/provider.dart';


class ArticleListPage extends StatefulWidget {
  
  final bool isSupportPull;  //是否支持手动下拉刷新
  final bool isSingleCard;  //每个item是否有单独card

  ArticleListPage({
    Key key,
    this.isSupportPull = true,
    this.isSingleCard = false
  }) : super(key: key);

  @override
  _ArticleListPageState createState() {
    return _ArticleListPageState(isSupportPull: isSupportPull);
  }
}

class _ArticleListPageState extends State<ArticleListPage> with BasePageMixin<ArticleListPage>, AutomaticKeepAliveClientMixin<ArticleListPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  bool isSupportPull;

  EasyRefreshController _easyController = EasyRefreshController();
  ListProvider<Article> _listProvider = ListProvider<Article>();
  int _page = 0;
  int _pageSize = 20;
  bool _init = false;

  _ArticleListPageState({
    this.isSupportPull
  });

  @override
  void initState() {
    super.initState();

    Future.delayed(new Duration(milliseconds: 100), () {
      if (mounted) {
        _refresh();
      }
    });
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

          List<Article> newsList = Article.fromJsonList(data['data']['account_info']) ?? [];
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

    return ChangeNotifierProvider<ListProvider<Article>>(
        create: (_) => _listProvider,
        child: Consumer<ListProvider<Article>>(
            builder: (_, _provider, __) {
              return !_init ? FirstRefreshTop() : EasyRefresh(
                header: isSupportPull ? MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main)) : null,
                footer:  CommonFooter(enableInfiniteLoad: !_provider.noMore),
                controller: _easyController,
//                firstRefresh配合NestedScrollView使用会造成刷新跳动问题
//                firstRefresh: true,
//                firstRefreshWidget: FirstRefresh(),
                topBouncing: false,
                emptyWidget: _listProvider.list.isEmpty ? LoadingEmptyTop() : null,
                child: ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return widget.isSingleCard ? ArticleCardItem(
                      index: index,
                      title: _provider.list[index].account_name + '杜绝浪费矿机时空裂缝接SDK龙卷风克雷登斯荆防颗粒圣诞节快乐福建省断开连接付款了圣诞节疯狂了圣诞节',
                      time: _provider.list[index].created_at,
                      author: _provider.list[index].city,
                      imageUrl: _provider.list[index].avatar_300,
                    ) : ArticleItem(
                      index: index,
                      title: _provider.list[index].account_name + '杜绝浪费矿机时空裂缝接SDK龙卷风克雷登斯荆防颗粒圣诞节快乐福建省断开连接付款了圣诞节疯狂了圣诞节',
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
