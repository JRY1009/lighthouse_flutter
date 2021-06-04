

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
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:module_quote/model/quote_index_platform.dart';
import 'package:module_quote/viewmodel/index_platform_model.dart';
import 'package:module_quote/item/index_platform_item.dart';

class IndexPlatformPage extends StatefulWidget {

  final String coinCode;

  const IndexPlatformPage({
    Key key,
    this.coinCode,
  }): super(key: key);


  @override
  _IndexPlatformPageState createState() => _IndexPlatformPageState();
}

class _IndexPlatformPageState extends State<IndexPlatformPage> with BasePageMixin<IndexPlatformPage>, AutomaticKeepAliveClientMixin<IndexPlatformPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  ShotController _shotController = new ShotController();

  IndexPlatformModel _quoteModel;

  @override
  void initState() {
    super.initState();

    _quoteModel = IndexPlatformModel();
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

    return ProviderWidget<IndexPlatformModel>(
        model: _quoteModel,
        builder: (context, model, child) {

          List<QuoteIndexPlatform> sortedList = _quoteModel.getSortedList();

          return model.isFirst ? FirstRefreshTop() :
          CommonScrollView(
              shotController: _shotController,
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          color: Colours.white,
                          height: 55.0,
                          child: _buildHeader(),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false, //不滚动
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          itemBuilder: (context, i) {
                            return IndexPlatformItem(
                              index: i,
                              quoteIndexPlatform: sortedList[i]
                            );
                          },
                          itemCount: sortedList.length,
                        )]
                  ),
                ),
                Gaps.vGap10
              ]
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

    String priceStr = NumUtil.formatNum(price, point: 2);
    String cnyStr = NumUtil.formatNum(cny, point: 2);
    String changeAmountStr = (rate >= 0 ? '+' : '') + NumUtil.formatNum(change_amount, point: 2);

    return Column(
      children: [
        Container(
          height: 46.0,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 9, left: 15, right: 15),
//          decoration: BoxDecoration(
//              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
//          ),
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
                    width: 110,
                    alignment: Alignment.centerRight,
                    child: Text.rich(TextSpan(
                        children: [
                          TextSpan(text: S.of(context).proLatestPrice, style: TextStyles.textGray500_w400_12),
                          WidgetSpan(
                              child: SortButton(
                                  state: _quoteModel.sortState == IndexPlatformSortState.PRICE_ASCEND ? SortButtonState.ASCEND :
                                  _quoteModel.sortState == IndexPlatformSortState.PRICE_DESCEND ? SortButtonState.DESCEND : SortButtonState.NORMAL
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
                                  state: _quoteModel.sortState == IndexPlatformSortState.RATE_ASCEND ? SortButtonState.ASCEND :
                                  _quoteModel.sortState == IndexPlatformSortState.RATE_DESCEND ? SortButtonState.DESCEND : SortButtonState.NORMAL
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

}
