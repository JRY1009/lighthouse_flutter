import 'dart:convert';
import 'dart:core';

import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/widget/chart/inapp_echart.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:lighthouse/ui/module_home/viewmodel/treemap_model.dart';
import 'package:flutter/material.dart';

class SpotTreemap extends StatefulWidget {

  SpotTreemap({
    Key key,
  }) : super(key: key);

  _SpotTreemapState createState() => _SpotTreemapState();
}

class _SpotTreemapState extends State<SpotTreemap> {

  TreemapModel _treemapModel;

  @override
  void initState() {
    super.initState();

    initViewModel();
  }

  void initViewModel() {
    _treemapModel = TreemapModel();
    _treemapModel.getTreemap();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TreemapModel>(
        model: _treemapModel,
        builder: (context, model, child) {
          return Scaffold(
              body: Column(
                children: [
                  Expanded (
                    child: Container(
                      child: _treemapModel.isFirst ? FirstRefresh() : InappEcharts(
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
                data: ${jsonEncode(_treemapModel.treeData)}
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
    );

  }

}

