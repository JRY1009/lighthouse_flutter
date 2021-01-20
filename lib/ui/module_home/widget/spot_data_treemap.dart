import 'dart:convert';
import 'dart:core';

import 'package:lighthouse/net/constant.dart';
import 'package:lighthouse/net/dio_util.dart';
import 'package:lighthouse/net/model/tree_node.dart';
import 'package:lighthouse/ui/module_base/provider/list_provider.dart';
import 'package:lighthouse/ui/module_base/widget/chart/inapp_echart.dart';
import 'package:lighthouse/ui/module_base/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/utils/toast_util.dart';
import 'package:flutter/material.dart';

class SpotTreemap extends StatefulWidget {

  SpotTreemap({
    Key key,
  }) : super(key: key);

  _SpotTreemapState createState() => _SpotTreemapState();
}

class _SpotTreemapState extends State<SpotTreemap> {

  ListProvider<TreeNode> _listProvider = ListProvider<TreeNode>();
  List<Map<String, Object>> _data = [];

  bool _init = false;

  final _echartKey = GlobalKey<InappEchartsState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
                                    fontSize: 11,
                                    color: '#079F8E',
                                    lineHeight: 12,
                                    align: 'center'
                                },
                                name: {
                                    fontSize: 14,
                                    lineHeight: 15,
                                    color: '#079F8E'
                                },
                                label2: {
                                    fontSize: 11,
                                    color: '#F05A00',
                                    lineHeight: 12,
                                    align: 'center'
                                },
                                name2: {
                                    fontSize: 14,
                                    lineHeight: 15,
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
              ],
            )
    );
  }

}

