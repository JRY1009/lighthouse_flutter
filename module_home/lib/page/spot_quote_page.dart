

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:library_base/widget/button/sort_button.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:module_home/item/spot_exchange_quote_item.dart';
import 'package:module_home/model/spot_exchange_quote.dart';
import 'package:module_home/viewmodel/spot_quote_model.dart';
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

  ShotController _shotController = new ShotController();

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
    _quoteModel.listenEvent();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _quoteModel.getQuote(widget.coinCode);
  }

  @override
  Future<Uint8List> screenShot() {
    return _shotController.makeImageUint8List();
  }

  //state 0 priceClicked，1 rateClicked
  void _changeSortState(int state) {
    _quoteModel.changeSortState(state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProviderWidget<SpotQuoteModel>(
        model: _quoteModel,
        builder: (context, model, child) {
          return model.isFirst ? FirstRefreshTop() :
          CommonScrollView(
              shotController: _shotController,
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false, //不滚动
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
                        )]
                  ),
                ),

              ]
          );
//          EasyRefresh(
//            topBouncing: false,
//            bottomBouncing: false,
//            emptyWidget: (model.isEmpty || model.isError) ? LoadingEmpty() : null,
//            child: ListView.builder(
//              padding: EdgeInsets.all(0.0),
//              itemBuilder: (context, index) {
//                return StickyHeader(
//                  header: Container(
//                    alignment: Alignment.centerLeft,
//                    width: double.infinity,
//                    color: Colours.normal_bg,
//                    height: 188.0,
//                    child: _buildHeader(),
//                  ),
//                  content: _buildItem(),
//                );
//              },
//              itemCount: 1,
//            ),
//
//            onRefresh: null,
//            onLoad: null,
//          );
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

    String priceStr = NumUtil.formatNum(price, point: 2);
    String cnyStr = NumUtil.formatNum(cny, point: 2);
    String changeAmountStr = (rate >= 0 ? '+' : '') + NumUtil.formatNum(change_amount, point: 2);

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
//                            WidgetSpan(
//                              child: Icon(rate >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
//                                  color: rate >= 0 ? Colours.text_green : Colours.text_red,
//                                  size: 14),)
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
              GestureDetector(
                  onTap: () =>_changeSortState(0),
                  child: Container(
                    width: 90,
                    alignment: Alignment.centerRight,
                    child: Text.rich(TextSpan(
                        children: [
                          TextSpan(text: S.of(context).proLatestPrice, style: TextStyles.textGray500_w400_12),
                          WidgetSpan(
                              child: SortButton(
                                  state: _quoteModel.sortState == QuoteSortState.PRICE_ASCEND ? SortButtonState.ASCEND :
                                  _quoteModel.sortState == QuoteSortState.PRICE_DESCEND ? SortButtonState.DESCEND : SortButtonState.NORMAL
                              )
                          )
                        ]
                    )),
                  )
              ),
              GestureDetector(
                  onTap: () =>_changeSortState(1),
                child: Container(
                  width: 70,
                  alignment: Alignment.centerRight,
                  child: Text.rich(TextSpan(
                      children: [
                        TextSpan(text: S.of(context).proRate, style: TextStyles.textGray500_w400_12),
                        WidgetSpan(
                            child: SortButton(
                                state: _quoteModel.sortState == QuoteSortState.RATE_ASCEND ? SortButtonState.ASCEND :
                                _quoteModel.sortState == QuoteSortState.RATE_DESCEND ? SortButtonState.DESCEND : SortButtonState.NORMAL
                            )
                        )
                      ]
                  )),
                )
              )
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildItem() {
    List<SpotExchangeQuote> sortedList = _quoteModel.getSortedList();
    
    final list = List.generate(sortedList.length, (i) {
      return SpotExchangeQuoteItem(
        index: i,
        tradePlatform: sortedList[i].name,
        price: sortedList[i].quote,
        rate: sortedList[i].change_percent,
        cny: sortedList[i].cny,
        ico: sortedList[i].ico,
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
