

import 'package:flutter/material.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/spot_address_assets_distribution.dart';
import 'package:lighthouse/net/model/spot_data_basic.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/module_home/widget/spot_data_address_assets_distribution_bar.dart';
import 'package:lighthouse/ui/module_home/widget/spot_data_circulation_bar.dart';
import 'package:lighthouse/ui/module_home/widget/spot_data_treemap.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/utils/log_util.dart';
import 'package:lighthouse/utils/toast_util.dart';

class SpotDataPage extends StatefulWidget {

  const SpotDataPage({
    Key key,
  }): super(key: key);


  @override
  _SpotDataPageState createState() => _SpotDataPageState();
}

class _SpotDataPageState extends State<SpotDataPage> with WidgetsBindingObserver, BasePageMixin<SpotDataPage>, AutomaticKeepAliveClientMixin<SpotDataPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  SpotDataBasic _spotDataBasic;
  List<SpotAddressAssetsDistribution> _dataList = [];
  bool _init = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    Future.delayed(new Duration(milliseconds: 100), () {
      if (mounted) {
        _requestData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LogUtil.v('SpotDataPage: didChangeDependencies', tag: 'SpotDataPage');
  }


  @override
  void didUpdateWidget(SpotDataPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtil.v('SpotDataPage: didUpdateWidget', tag: 'SpotDataPage');
  }


  @override
  void deactivate() {
    super.deactivate();
    LogUtil.v('SpotDataPage: deactivate', tag: 'SpotDataPage');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.detached) {
    }
    LogUtil.v('SpotDataPage: ' + state.toString(), tag: 'SpotDataPage');
  }

  @override
  Future<void> refresh({slient = false}) {
    return _requestData();
  }

  Future<void> _requestData() {

    Map<String, dynamic> params = {
      'chain': 'bitcoin',
    };

    return DioUtil.getInstance().get(Constant.URL_GET_CHAIN_DATA, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            _finishRequest(success: false);
            return;
          }

          _spotDataBasic = SpotDataBasic.fromJson(data['data']);
          List<SpotAddressAssetsDistribution> dataList = _spotDataBasic?.address_balance_list;

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

    if (mounted) {
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return !_init ? FirstRefresh() : CommonScrollView(
      physics: ClampingScrollPhysics(),
      children: [
        SpotDataCirculationBar(spotDataBasic: _spotDataBasic),

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

        SpotDataAddressAssetsDistributionBar(spotDataBasic: _spotDataBasic, dataList: _dataList,),
      ],
    );
  }
}
