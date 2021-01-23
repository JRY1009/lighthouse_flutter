import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lighthouse/mvvm/base_page.dart';
import 'package:lighthouse/mvvm/provider_widget.dart';
import 'package:lighthouse/net/model/article.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/ui/module_base/widget/easyrefresh/common_footer.dart';
import 'package:lighthouse/ui/module_base/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/module_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:lighthouse/ui/module_base/widget/easyrefresh/loading_empty.dart';
import 'package:lighthouse/ui/module_base/widget/easyrefresh/loading_empty_top.dart';
import 'package:lighthouse/ui/module_info/item/article_card_item.dart';
import 'package:lighthouse/ui/module_info/item/article_item.dart';
import 'package:lighthouse/ui/module_info/model/article_model.dart';
import 'package:lighthouse/utils/toast_util.dart';


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

  EasyRefreshController _easyController = EasyRefreshController();

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
          _easyController.finishRefresh(success: false);
        } else {
          _easyController.finishLoad(success: false, noMore: _articleModel.noMore);
        }
        ToastUtil.error(_articleModel.viewStateError.message);

      } else if (_articleModel.isSuccess || _articleModel.isEmpty) {
        if (_articleModel.page == 0) {
          _easyController.finishRefresh(success: true);
        } else {
          _easyController.finishLoad(success: true, noMore: _articleModel.noMore);
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
        _easyController.callRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    Widget refreshWidget = widget.isSingleCard ? FirstRefreshTop() : FirstRefresh();
    Widget emptyWidget = widget.isSingleCard ? LoadingEmptyTop() : LoadingEmpty();
    
    return ProviderWidget<ArticleModel>(
        model: _articleModel,
        builder: (context, model, child) {
          return model.isFirst ? refreshWidget : model.isEmpty ? emptyWidget : EasyRefresh(
            header: widget.isSupportPull ? MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main)) : null,
            footer:  CommonFooter(enableInfiniteLoad: !model.noMore),
            controller: _easyController,
//                firstRefresh配合NestedScrollView使用会造成刷新跳动问题
//                firstRefresh: true,
//                firstRefreshWidget: FirstRefresh(),
            topBouncing: false,
            emptyWidget: (model.isEmpty || model.isError) ? emptyWidget : null,
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index) {
                Article article = model.articleList[index];
                return widget.isSingleCard ? ArticleCardItem(
                  index: index,
                  title: '杜绝浪费矿机时空裂缝接SDK龙卷风克雷登斯荆防颗粒圣诞节快乐福建省断开连接付款了圣诞节疯狂了圣诞节',
                  time: 'article.created_at',
                  author: 'article.city',
                  imageUrl: 'article.avatar_300',
                ) : ArticleItem(
                  index: index,
                  title: 'article.account_name' + '杜绝浪费矿机时空裂缝接SDK龙卷风克雷登斯荆防颗粒圣诞节快乐福建省断开连接付款了圣诞节疯狂了圣诞节',
                  time: 'article.created_at',
                  author: 'article.city',
                  imageUrl: 'article.avatar_300',
                );
              },
              itemCount: model.articleList.length,
            ),

            onRefresh: widget.isSupportPull ? model.refresh : null,
            onLoad: model.noMore ? null : model.loadMore,
          );
        }
    );
  }
}
