import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_base/widget/easyrefresh/loading_empty_top.dart';
import 'package:module_info/item/article_card_item.dart';
import 'package:module_info/item/article_item.dart';
import 'package:module_info/model/article.dart';
import 'package:module_info/viewmodel/article_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class ArticleListPage extends StatefulWidget {
  
  final bool isSupportPull;  //是否支持手动下拉刷新
  final bool isSingleCard;  //每个item是否有单独card
  final String tag;

  ArticleListPage({
    Key key,
    this.tag = '',
    this.isSupportPull = true,
    this.isSingleCard = false
  }) : super(key: key);

  @override
  _ArticleListPageState createState() {
    return _ArticleListPageState();
  }
}

class _ArticleListPageState extends State<ArticleListPage> with BasePageMixin<ArticleListPage>, AutomaticKeepAliveClientMixin<ArticleListPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  RefreshController _easyController = RefreshController();

  ArticleModel _articleModel;

  @override
  void initState() {
    super.initState();

    _articleModel = ArticleModel(widget.tag);

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
    _articleModel.refresh();

    _articleModel.addListener(() {
      if (_articleModel.isError) {
        if (_articleModel.page == 0) {
          _easyController.refreshFailed();
        } else {
          _easyController.loadFailed();
        }
        ToastUtil.error(_articleModel.viewStateError.message);

      } else if (_articleModel.isSuccess || _articleModel.isEmpty) {
        if (_articleModel.page == 0) {
          _easyController.refreshCompleted(resetFooterState: !_articleModel.noMore);
        } else {
          if (_articleModel.noMore) {
            _easyController.loadNoData();
          } else {
            _easyController.loadComplete();
          }
        }
      }
    });
  }
  
  @override
  Future<void> refresh({slient = false}) {
    if (slient) {
      return _articleModel.refresh();

    } else {
      return Future<void>.delayed(const Duration(milliseconds: 100), () {
        _easyController.requestRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    
    return ProviderWidget<ArticleModel>(
        model: _articleModel,
        builder: (context, model, child) {
          Widget refreshWidget = widget.isSupportPull ? FirstRefresh() : FirstRefreshTop();
          Widget emptyWidget = widget.isSupportPull ? LoadingEmpty() : LoadingEmptyTop();

          return ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: SmartRefresher(
                controller: _easyController,
                enablePullDown: widget.isSupportPull,
                enablePullUp: !model.noMore,
                onRefresh: widget.isSupportPull ? model.refresh : null,
                onLoading: model.noMore ? null : model.loadMore,
                child: model.isFirst ? refreshWidget : model.isEmpty ? emptyWidget : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        Article article = model.articleList[index];
                        return widget.isSingleCard ? ArticleCardItem(
                          index: index,
                          aritcle: article,
                        ) : ArticleItem(
                          index: index,
                          aritcle: article,
                        );
                      },
                        childCount: model.articleList.length,
                      ),
                    ),
                  ],
                )
            ),
          );
        }
    );
  }
}
