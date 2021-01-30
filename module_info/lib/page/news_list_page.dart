import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/widget/easyrefresh/common_footer.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:module_info/item/news_item.dart';
import 'package:module_info/model/news.dart';
import 'package:module_info/viewmodel/news_model.dart';


class NewsListPage extends StatefulWidget {
  
  final bool isSupportPull;  //是否支持手动下拉刷新
  final String tag;

  NewsListPage({
    Key key,
    this.tag = '',
    this.isSupportPull = true
  }) : super(key: key);

  @override
  _NewsListPageState createState() {
    return _NewsListPageState();
  }
}

class _NewsListPageState extends State<NewsListPage> with BasePageMixin<NewsListPage>, AutomaticKeepAliveClientMixin<NewsListPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  EasyRefreshController _easyController = EasyRefreshController();
  
  NewsModel _newsModel;

  @override
  void initState() {
    super.initState();

    _newsModel = NewsModel(widget.tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initViewModel();
      }
    });
  }

  @override
  void dispose() {
    _easyController.dispose();
    super.dispose();
  }

  void initViewModel() {
    _newsModel.refresh();

    _newsModel.addListener(() {
      if (_newsModel.isError) {
        if (_newsModel.page == 0) {
          _easyController.finishRefresh(success: false);
        } else {
          _easyController.finishLoad(success: false, noMore: _newsModel.noMore);
        }
        ToastUtil.error(_newsModel.viewStateError.message);

      } else if (_newsModel.isSuccess || _newsModel.isEmpty) {
        if (_newsModel.page == 0) {
          _easyController.finishRefresh(success: true);
        } else {
          _easyController.finishLoad(success: true, noMore: _newsModel.noMore);
        }
      }
    });
  }
  
  @override
  Future<void> refresh({slient = false}) {
    if (slient) {
      return _newsModel.refresh();
      
    } else {
      return Future<void>.delayed(const Duration(milliseconds: 100), () {
        _easyController.callRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<NewsModel>(
        model: _newsModel,
        builder: (context, model, child) {
          return model.isFirst ? FirstRefresh() : EasyRefresh(
            header: widget.isSupportPull ? MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main)) : null,
            footer:  CommonFooter(enableInfiniteLoad: !model.noMore),
            controller: _easyController,
//                firstRefresh配合NestedScrollView使用会造成刷新跳动问题
//                firstRefresh: true,
//                firstRefreshWidget: FirstRefresh(),
            topBouncing: false,
            emptyWidget: (model.isEmpty || model.isError) ? LoadingEmpty() : null,
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index) {
                News news = model.newsList[index];
                return NewsItem(
                  index: index,
                  title: '杜绝浪费矿机时空裂缝接SDK龙卷风克雷登斯荆防颗粒圣诞节快乐福建省断开连接付款了圣诞节疯狂了圣诞节',
                  time: 'article.created_at',
                  author: 'article.city',
                  imageUrl: 'article.avatar_300',
                  isLast: index == (model.newsList.length - 1),
                );
              },
              itemCount: model.newsList.length,
            ),

            onRefresh: widget.isSupportPull ? model.refresh : null,
            onLoad: model.noMore ? null : model.loadMore,
          );
        }
    );
  }
}
