

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:lighthouse/ui/module_home/item/spot_exchange_quote_item.dart';
import 'package:lighthouse/ui/module_home/viewmodel/spot_quote_model.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SpotQuotePage extends StatefulWidget {

  final String coinCode;

  const SpotQuotePage({
    Key key,
    this.coinCode,
  }): super(key: key);


  @override
  _SpotQuotePageState createState() => _SpotQuotePageState();
}

class _SpotQuotePageState extends State<SpotQuotePage> with BasePageMixin<SpotQuotePage>, AutomaticKeepAliveClientMixin<SpotQuotePage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  SpotQuoteModel _quoteModel;

  @override
  void initState() {
    super.initState();

    _quoteModel = SpotQuoteModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initViewModel();
      }
    });
  }

  void initViewModel() {
    _quoteModel.getQuote(widget.coinCode);
  }

  @override
  Future<void> refresh({slient = false}) {
    return _quoteModel.getQuote(widget.coinCode);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<SpotQuoteModel>(
        model: _quoteModel,
        builder: (context, model, child) {
          return model.isFirst ? FirstRefresh() :
          EasyRefresh(
            topBouncing: false,
            bottomBouncing: false,
            emptyWidget: (model.isEmpty || model.isError) ? LoadingEmpty() : null,
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
    );
    
    
  }

  Widget _buildHeader() {

    double rate = _quoteModel.quoteBasic != null ? _quoteModel.quoteBasic.change_percent : 0;
    double price = _quoteModel.quoteBasic != null ? _quoteModel.quoteBasic.quote : 0;
    double cny = _quoteModel.quoteBasic != null ? _quoteModel.quoteBasic.cny : 0;
    double change_amount = _quoteModel.quoteBasic != null ? _quoteModel.quoteBasic.change_amount : 0;

    String groupStr = _quoteModel.quoteBasic != null ? _quoteModel.quoteBasic.data_src : '';
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
                      WidgetSpan(child: Icon(Icons.arrow_drop_down_sharp, color: Colours.text_red, size: 14),)
                    ]
                )),
              ),
              Container(
                width: 70,
                alignment: Alignment.centerRight,
                child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: S.of(context).proRate, style: TextStyles.textGray500_w400_12),
                      WidgetSpan(child: Icon(Icons.arrow_drop_down_sharp, color: Colours.text_red, size: 14),)
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
    final list = List.generate(_quoteModel.quoteList.length, (i) {
      return SpotExchangeQuoteItem(
        index: i,
        tradePlatform: _quoteModel.quoteList[i].name,
        price: _quoteModel.quoteList[i].quote,
        rate: _quoteModel.quoteList[i].change_percent,
        cny: _quoteModel.quoteList[i].cny,
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
