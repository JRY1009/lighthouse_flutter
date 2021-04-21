

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/router/routers.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:module_home/viewmodel/spot_data_model.dart';
import 'package:module_home/widget/spot_data_address_assets_distribution_bar.dart';
import 'package:module_home/widget/spot_data_circulation_bar.dart';
import 'package:module_home/widget/spot_data_treemap.dart';

class SpotDataPage extends StatefulWidget {

  final String coinCode;

  const SpotDataPage({
    Key key,
    this.coinCode,
  }): super(key: key);


  @override
  _SpotDataPageState createState() => _SpotDataPageState();
}

class _SpotDataPageState extends State<SpotDataPage> with WidgetsBindingObserver, BasePageMixin<SpotDataPage>, AutomaticKeepAliveClientMixin<SpotDataPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  SpotDataModel _dataModel;

  @override
  void initState() {
    super.initState();

    _dataModel = SpotDataModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initViewModel();
      }
    });
  }

  void initViewModel() {
    _dataModel.getData(widget.coinCode);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> refresh({slient = false}) {
    _dataModel.getData(widget.coinCode);
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<SpotDataModel>(
        model: _dataModel,
        builder: (context, model, child) {
          return model.isFirst ? FirstRefreshTop() :
          CommonScrollView(
            physics: ClampingScrollPhysics(),
            children: [
              SpotDataCirculationBar(spotDataBasic: model.dataBasic),

              GestureDetector(
                onTap: () => Routers.navigateTo(context, Routers.treemapPage),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(15, 18, 16, 9),
                          height: 24,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(S.of(context).proAssetsCompare,
                                    style: TextStyles.textGray800_w700_18,
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(S.of(context).all, style: TextStyles.textGray400_w400_12),
                                      Gaps.hGap3,
                                      Icon(Icons.keyboard_arrow_right, color: Colours.gray_400, size: 15),
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 15, top: 12, right: 15, bottom: 15),
                        height: 200,
                        child: SpotTreemap(),
                      )
                    ],
                  ),
                )
              ),
              SpotDataAddressAssetsDistributionBar(spotDataBasic: model.dataBasic, dataList: model.dataList),
            ],
          );
        }
    );

  }
}
