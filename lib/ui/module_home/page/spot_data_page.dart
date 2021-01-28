

import 'package:flutter/material.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/spot_address_assets_distribution.dart';
import 'package:lighthouse/net/model/spot_data_basic.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/module_home/viewmodel/spot_data_model.dart';
import 'package:lighthouse/ui/module_home/widget/spot_data_address_assets_distribution_bar.dart';
import 'package:lighthouse/ui/module_home/widget/spot_data_circulation_bar.dart';
import 'package:lighthouse/ui/module_home/widget/spot_data_treemap.dart';
import 'package:library_base/utils/log_util.dart';
import 'package:library_base/utils/toast_util.dart';

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
          return model.isFirst ? FirstRefresh() :
          CommonScrollView(
            physics: ClampingScrollPhysics(),
            children: [
              SpotDataCirculationBar(spotDataBasic: model.dataBasic),

              Container(
                margin: const EdgeInsets.fromLTRB(12, 9, 12, 9),
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  boxShadow: BoxShadows.normalBoxShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 15, top: 18),
                      child: Text(S.of(context).proAssetsCompare,
                        style: TextStyles.textGray800_w400_15,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 15, top: 12, right: 15, bottom: 15),
                      height: 200,
                      child: SpotTreemap(),
                    )
                  ],
                ),
              ),

              SpotDataAddressAssetsDistributionBar(spotDataBasic: model.dataBasic, dataList: model.dataList),
            ],
          );
        }
    );

  }
}
