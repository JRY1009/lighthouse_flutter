

import 'package:flutter/material.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/spot_address_assets_distribution.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/page/base_page.dart';
import 'package:lighthouse/ui/widget/appbar/spot_data_address_assets_distribution_bar.dart';
import 'package:lighthouse/ui/widget/appbar/spot_data_circulation_bar.dart';
import 'package:lighthouse/ui/widget/common_scroll_view.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/utils/toast_util.dart';

class SpotDataPage extends StatefulWidget {

  const SpotDataPage({
    Key key,
  }): super(key: key);


  @override
  _SpotDataPageState createState() => _SpotDataPageState();
}

class _SpotDataPageState extends State<SpotDataPage> with BasePageMixin<SpotDataPage>, AutomaticKeepAliveClientMixin<SpotDataPage>, SingleTickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  List<SpotAddressAssetsDistribution> _dataList = [];
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
      'page_size': 10,
    };

    return DioUtil.getInstance().post(Constant.URL_GET_NEWS, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            _finishRequest(success: false);
            return;
          }

          List<SpotAddressAssetsDistribution> dataList = SpotAddressAssetsDistribution.fromJsonList(data['data']['account_info']) ?? [];

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
    return !_init ? FirstRefresh() : CommonScrollView(
      physics: ClampingScrollPhysics(),
      children: [
        SpotDataCirculationBar(),

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
                alignment: Alignment.center,
                height: 200,
                child: Text('Treemap [TODO]',
                  style: TextStyles.textGray800_w400_14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            ],
          ),
        ),

        SpotDataAddressAssetsDistributionBar(dataList: _dataList,),
      ],
    );
  }
}
