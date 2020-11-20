

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/spot_address_assets_distribution.dart';
import 'package:lighthouse/net/model/spot_trade_platform_data.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/item/spot_address_assets_distribution_item.dart';
import 'package:lighthouse/ui/item/spot_trade_platform_data_item.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/appbar/spot_data_address_assets_distribution_bar.dart';
import 'package:lighthouse/ui/widget/appbar/spot_data_circulation_bar.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/widget/easyrefresh/loading_empty.dart';
import 'package:lighthouse/utils/toast_util.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SpotQuotePage extends StatefulWidget {

  const SpotQuotePage({
    Key key,
  }): super(key: key);


  @override
  _SpotQuotePageState createState() => _SpotQuotePageState();
}

class _SpotQuotePageState extends State<SpotQuotePage> with BasePageMixin<SpotQuotePage>, AutomaticKeepAliveClientMixin<SpotQuotePage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  List<SpotTradePlatformData> _dataList = [];
  bool _init = false;

  @override
  void initState() {
    super.initState();
    _requestData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _requestData();
  }

  Future<void> _requestData() {

    Map<String, dynamic> params = {
      'auth': 1,
      'sort': 1,
      'page': 0,
      'page_size': 20,
    };

    return DioUtil.getInstance().post(Constant.URL_GET_NEWS, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            _finishRequest(success: false);
            return;
          }

          List<SpotTradePlatformData> dataList = SpotTradePlatformData.fromJsonList(data['data']['account_info']) ?? [];

          _dataList.clear();
          _dataList.addAll(dataList);
          _finishRequest(success: true);
        },
        errorCallBack: (error) {
          _finishRequest(success: false);
          ToastUtil.error(error[Constant.MESSAGE]);
        });
  }

  void _finishRequest({bool success}) {
    if (!_init) {
      _init = true;
    }

    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return !_init ? FirstRefresh() :
    EasyRefresh(
      topBouncing: false,
      bottomBouncing: false,
      emptyWidget: _dataList.isEmpty ? LoadingEmpty() : null,
      child: ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemBuilder: (context, index) {
          return StickyHeader(
            header: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              color: Colours.normal_bg,
              height: 188.0,
              child: _buildHeader(),
            ),
            content: _buildItem(),
          );
        },
        itemCount: 2,
      ),

      onRefresh: null,
      onLoad: null,
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 115,
          margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 9),
          decoration: BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
            boxShadow: BoxShadows.normalBoxShadow,
          ),
          child: Column (
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 15, top: 18),
                child: Text(S.of(context).proTradePlatformData,
                  style: TextStyles.textGray800_w400_15,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gaps.vGap15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.bottomLeft,
                      child: Text.rich(TextSpan(
                          children: [
                            TextSpan(text: '\$', style: TextStyles.textRed_w400_12),
                            TextSpan(text: '12222.12', style: TextStyles.textRed_w400_22),
                            WidgetSpan(child: Icon(Icons.arrow_downward, color: Colours.text_red, size: 14),)
                          ]
                      ))
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 15),
                      alignment: Alignment.bottomRight,
                      child: Text('+11.11%  +123,22',
                        style: TextStyles.textRed_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                ],
              ),

              Gaps.vGap5,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: Text('≈￥82333.4',
                        style: TextStyles.textGray500_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),

                  Container(
                      margin: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerLeft,
                      child: Text('CME GROUP',
                        style: TextStyles.textGray500_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                ],
              ),
              Gaps.vGap15,
            ],
          ),
        ),
        Container(
          height: 46.0,
          width: double.infinity,
          margin: const EdgeInsets.only(left: 12, top: 9, right: 12),
          padding: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
            boxShadow: BoxShadows.normalBoxShadow,
          ),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Text(S.of(context).proTradePlatform, style: TextStyles.textGray500_w400_12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,)
              ),
              Container(
                width: 90,
                alignment: Alignment.centerRight,
                child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: S.of(context).proLatestPrice, style: TextStyles.textGray500_w400_12),
                      WidgetSpan(child: Icon(Icons.compare_arrows, color: Colours.text_red, size: 14),)
                    ]
                )),
              ),
              Container(
                width: 70,
                alignment: Alignment.centerRight,
                child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: S.of(context).proRate, style: TextStyles.textGray500_w400_12),
                      WidgetSpan(child: Icon(Icons.compare_arrows, color: Colours.text_red, size: 14),)
                    ]
                )),
              )
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildItem() {
    final list = List.generate(_dataList.length, (i) {
      return SpotTradePlatformDataItem(
        index: i,
        tradePlatform: '',
        price: '12345.22',
        rate: '10.11%',
      );
    });
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 12, bottom: 9, right: 12),
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0)),
          boxShadow: BoxShadows.normalBoxShadow,
        ),
        child:Column(
            children: list
        )
    );
  }
}
