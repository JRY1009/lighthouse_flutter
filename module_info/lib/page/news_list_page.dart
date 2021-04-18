import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_base/widget/easyrefresh/loading_empty_top.dart';
import 'package:module_info/info_router.dart';
import 'package:module_info/item/news_item.dart';
import 'package:module_info/model/news.dart';
import 'package:module_info/viewmodel/news_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  RefreshController _easyController = RefreshController();
  
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
          _easyController.refreshFailed();
        } else {
          _easyController.loadFailed();
        }
        ToastUtil.error(_newsModel.viewStateError.message);

      } else if (_newsModel.isSuccess || _newsModel.isEmpty) {
        if (_newsModel.page == 0) {
          _easyController.refreshCompleted(resetFooterState: !_newsModel.noMore);
        } else {
          if (_newsModel.noMore) {
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
      return _newsModel.refresh();
      
    } else {
      return Future<void>.delayed(const Duration(milliseconds: 100), () {
        _easyController.requestRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<NewsModel>(
        model: _newsModel,
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
                child: model.isFirst ? refreshWidget : (model.isEmpty || model.isError) ? emptyWidget : CustomScrollView(
                  slivers: _buildList(),
                )
            ),
          );
        }
    );
  }

  List<Widget> _buildList() {
    List<List<News>> dateNewsList = _newsModel.dateNewsList;

    final list = List.generate(dateNewsList.length, (i) {
      return SliverStickyHeader(
          header: _buildHeader(context, i),
          sliver: _buildItem(i)
      );
    });

    return list;
  }

  Widget _buildHeader(BuildContext context, int index) {
    List<News> newsList = _newsModel.dateNewsList[index];

    String dateFormat = '';
    DateTime dt = DateUtil.getDateTime(newsList.first.publish_time, isUtc: false);
    if (DateUtil.isToday(dt.millisecondsSinceEpoch)) {
      dateFormat = S.of(context).today;
    } else if (DateUtil.isYesterdayByMillis(dt.millisecondsSinceEpoch, DateTime.now().millisecondsSinceEpoch)) {
      dateFormat = S.of(context).yesterday;
    } else {
      dateFormat = DateUtil.getDateStrByDateTime(dt, format: DateFormat.ZH_MONTH_DAY);
    }

    dateFormat += '  ${DateUtil.getZHWeekDay(dt)}';

    return Container(
      height: 34.0,
      width: double.infinity,
      color: Colours.gray_50,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 9.0),
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            padding: EdgeInsets.only(bottom: 2),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Colours.transparent,
              image: DecorationImage(
                image: AssetImage(ImageUtil.getImgPath('bg_date'), package: InfoRouter.isRunModule ? null : Constant.moduleInfo),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(dt.day.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.textGray800_w400_12
            )
          ),
          Gaps.hGap8,
          Text(dateFormat,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.textGray500_w400_14
          )
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    List<News> newsList = _newsModel.dateNewsList[index];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, i) {
              News news = newsList[i];
              return NewsItem(
                  index: i,
                  news: news,
                  isLast: index == _newsModel.dateNewsList.length - 1 && i == newsList.length - 1
              );
            },
        childCount: newsList.length,
      )

    );

  }
}
