import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/tree_node.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/ui/provider/list_provider.dart';
import 'package:lighthouse/ui/widget/chart/inapp_echart.dart';
import 'package:lighthouse/ui/widget/dialog/dialog_util.dart';
import 'package:lighthouse/ui/widget/dialog/share_widget.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/widget/shot_view.dart';
import 'package:lighthouse/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';
import 'package:lighthouse/ui/widget/button/back_button.dart';

class TreemapPage extends StatefulWidget {

  TreemapPage({
    Key key,
  }) : super(key: key);

  _TreemapPageState createState() => _TreemapPageState();
}

class _TreemapPageState extends State<TreemapPage> {

  ListProvider<TreeNode> _listProvider = ListProvider<TreeNode>();
  List<Map<String, Object>> _data = [];

  bool _init = false;

  final _echartKey = GlobalKey<InappEchartsState>();
  ShotController _shotController = new ShotController();

  @override
  void initState() {
    super.initState();

    _requestData();
  }


  Future<void> _requestData() {
    Map<String, dynamic> params = {
    };

    return DioUtil.getInstance().get(Constant.URL_GET_TREEMAP, params: params,
        successCallBack: (data, headers) {
          if (data == null || data['data'] == null) {
            _finishRequest(success: false, noMore: false);
            return;
          }

          List<TreeNode> newsList = TreeNode.fromJsonList(data['data']) ?? [];
          _listProvider.clear();
          _listProvider.addAll(newsList);

          _data.clear();
          for (TreeNode treeNode in _listProvider.list) {
            Map<String, Object> nodeMap = {
              'name': treeNode.zh_name,
              'value': [treeNode.market_val, treeNode.change_percent, treeNode.color_index]
            };
            _data.add(nodeMap);
          }

          _finishRequest(success: true, noMore: true);
        },
        errorCallBack: (error) {
          _finishRequest(success: false, noMore: false);
          ToastUtil.error(error[Constant.MESSAGE]);
        });
  }

  void _finishRequest({bool success, bool noMore}) {
    setState(() {
      if (!_init) {
        _init = true;
      }
    });
  }

  Future<void> _share() async {
    Uint8List pngBytes = await _shotController.makeImageUint8List();
    Uint8List webBytes = await _echartKey?.currentState.webviewController.takeScreenshot();
    DialogUtil.showShareDialog(context,
        children: [
          ShareQRHeader(),
          Stack(
            children: [
              Container(
                color: Colours.white,
                child: Image.memory(pngBytes),
              ),
              Container(
                color: Colours.white,
                child: Image.memory(webBytes),
              )
            ],
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButtonEx(),
          elevation: 1,
          brightness: Brightness.light,
          backgroundColor: Colours.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share, color: Colours.black),
              onPressed: _share,
            )
          ],
          centerTitle: true,
          title: Text(S.of(context).treemap, style: TextStyles.textBlack16),
        ),
        body: ShotView(
          controller: _shotController,
          child: Column(
            children: [
              Expanded (
                child: Container(
                  child: !_init ? FirstRefresh() : InappEcharts(
                    key: _echartKey,
                    option: '''
            {
            series: [{
                type: 'treemap',
                left: '0%',
                right: '0%',
                bottom: '0%',
                top: '0%',
                silent: true,
                nodeClick: false,
                roam: false,
                breadcrumb: {
                    show: false
                },
                levels: [
                    {
                        color: ['#DAF6F3', '#ACEFE8', '#97EEE5', '#F8F8F8', '#FFF8F4', '#FFDECB', '#FCC09C'],
                        visualMin: 0,
                        visualMax: 6,
                        colorMappingBy: 'value', 
                        visualDimension: 2,
                        
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1,
                            gapWidth: 2,
                        },

                    }
                ],
                label: {
                    position: 'inside',
                    formatter: function (params) {
                        if (params.value[1] >= 0) {
                          var arr = [
                              '{name|' + params.name + '}',
                              '{label|' + params.value[1] + '%'  + '}',
                          ];
          
                          return arr.join('\\n');
                        } else {
                          var arr = [
                              '{name2|' + params.name + '}',
                              '{label2|' + params.value[1] + '%' + '}',
                          ];
          
                          return arr.join('\\n');
                        }
                    },
                    rich: {
                                label: {
                                    fontSize: 12,
                                    color: '#079F8E',
                                    lineHeight: 20,
                                    align: 'center'
                                },
                                name: {
                                    fontSize: 15,
                                    lineHeight: 30,
                                    color: '#079F8E'
                                },
                                label2: {
                                    fontSize: 12,
                                    color: '#F05A00',
                                    lineHeight: 20,
                                    align: 'center'
                                },
                                name2: {
                                    fontSize: 15,
                                    lineHeight: 30,
                                    color: '#F05A00'
                                },
                            }
                },
                data: ${jsonEncode(_data)}
            }]
            }
            ''',
                  ),
                ),
              ),
              Gaps.vGap10,
              Container(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Container(alignment: Alignment.center, child: Text('<-3%', style: TextStyles.textGray500_w400_10)), flex: 1),
                    Expanded(child: Container(alignment: Alignment.center, child: Text('<-1%', style: TextStyles.textGray500_w400_10)), flex: 1),
                    Expanded(child: Container(alignment: Alignment.center, child: Text('<0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                    Expanded(child: Container(alignment: Alignment.center, child: Text('>0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                    Expanded(child: Container(alignment: Alignment.center, child: Text('>+1%', style: TextStyles.textGray500_w400_10)), flex: 1),
                    Expanded(child: Container(alignment: Alignment.center, child: Text('>+3%', style: TextStyles.textGray500_w400_10)), flex: 1),
                  ],
                ),
              ),
              Container(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Container(color: Color(0xFFFCC09C)), flex: 1),
                    Expanded(child: Container(color: Color(0xFFFFDECB)), flex: 1),
                    Expanded(child: Container(color: Color(0xFFFFF8F4)), flex: 1),
                    Expanded(child: Container(color: Color(0xFFDAF6F3)), flex: 1),
                    Expanded(child: Container(color: Color(0xFFACEFE8)), flex: 1),
                    Expanded(child: Container(color: Color(0xFF97EEE5)), flex: 1),
                  ],
                ),
              ),

              Gaps.vGap5,
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(S.of(context).quoteDefinition, style: TextStyles.textGray500_w400_12)
              ),
              Gaps.vGap32
            ],
          )
        )
    );
  }

}

