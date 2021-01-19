

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/spot_exchange_quote.dart';
import 'package:lighthouse/net/model/spot_exchange_quote_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/item/spot_exchange_quote_item.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/widget/easyrefresh/loading_empty.dart';
import 'package:lighthouse/utils/num_util.dart';
import 'package:lighthouse/utils/object_util.dart';
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

  SpotExchangeQuoteBasic _exchangeQuoteBasic;
  List<SpotExchangeQuote> _quoteList = [];

  bool _init = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(new Duration(milliseconds: 100), () {
      if (mounted) {
        _requestData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SpotQuotePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Future<void> refresh({slient = false}) {
    return _requestData();
  }

  Future<void> _requestData() {
    Map<String, dynamic> params = {
      'chain': 'bitcoin',
    };

    return DioUtil.getInstance().get(Constant.URL_GET_CHAIN_QUOTE, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            _finishRequest(success: false);
            return;
          }

          _exchangeQuoteBasic = SpotExchangeQuoteBasic.fromJson(data['data']);
          _quoteList = _exchangeQuoteBasic?.exchange_quote_list;

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

    if (mounted) {
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return !_init ? FirstRefresh() :
    EasyRefresh(
      topBouncing: false,
      bottomBouncing: false,
      emptyWidget: ObjectUtil.isEmpty(_quoteList) ? LoadingEmpty() : null,
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
        itemCount: 1,
      ),

      onRefresh: null,
      onLoad: null,
    );
  }

  Widget _buildHeader() {

    double rate = _exchangeQuoteBasic != null ? _exchangeQuoteBasic.change_percent : 0;
    double price = _exchangeQuoteBasic != null ? _exchangeQuoteBasic.quote : 0;
    double cny = _exchangeQuoteBasic != null ? _exchangeQuoteBasic.cny : 0;
    double change_amount = _exchangeQuoteBasic != null ? _exchangeQuoteBasic.change_amount : 0;

    String groupStr = _exchangeQuoteBasic != null ? _exchangeQuoteBasic.data_src : '';
    String rateStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(rate, 2).toString() + '%';
    String priceStr = NumUtil.getNumByValueDouble(price, 2).toString();
    String cnyStr = NumUtil.getNumByValueDouble(cny, 2).toString();
    String changeAmountStr = (rate >= 0 ? '+' : '') + NumUtil.getNumByValueDouble(change_amount, 2).toString();

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
                height: 20,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 15, top: 18),
                child: Text(S.of(context).proTradePlatformData,
                  style: TextStyles.textGray800_w400_15,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gaps.vGap12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      height: 30,
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.bottomLeft,
                      child: Text.rich(TextSpan(
                          children: [
                            TextSpan(text: '\$', style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12),
                            TextSpan(text: priceStr, style: rate >= 0 ? TextStyles.textGreen_w400_22 : TextStyles.textRed_w400_22),
                            WidgetSpan(
                              child: Icon(rate >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: rate >= 0 ? Colours.text_green : Colours.text_red,
                                  size: 14),)
                          ]
                      ))
                  ),
                  Container(
                      height: 15,
                      margin: EdgeInsets.only(right: 15),
                      alignment: Alignment.bottomRight,
                      child: Text(rateStr + '  ' + changeAmountStr,
                        style: rate >= 0 ? TextStyles.textGreen_w400_12 : TextStyles.textRed_w400_12,
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
                      height: 15,
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: Text('≈￥' + cnyStr,
                        style: TextStyles.textGray500_w400_12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),

                  Container(
                      height: 15,
                      margin: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(groupStr,
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
          ),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 100,
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
    final list = List.generate(_quoteList.length, (i) {
      return SpotExchangeQuoteItem(
        index: i,
        tradePlatform: _quoteList[i].name,
        price: _quoteList[i].quote,
        rate: _quoteList[i].change_percent,
        cny: _quoteList[i].cny,
      );
    });
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 12, bottom: 9, right: 12),
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0)),
        ),
        child: Column(
            children: list
        )
    );
  }
}
