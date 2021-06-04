import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/chart/inapp_echart.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/easyrefresh/loading_empty.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:module_quote/viewmodel/treemap_model.dart';

class TreemapPage extends StatefulWidget {

  TreemapPage({
    Key key,
  }) : super(key: key);

  _TreemapPageState createState() => _TreemapPageState();
}

class _TreemapPageState extends State<TreemapPage> {

  TreemapModel _treemapModel;

  final _echartKey = GlobalKey<InappEchartsState>();
  ShotController _shotController = new ShotController();

  @override
  void initState() {
    super.initState();

    initViewModel();
  }

  void initViewModel() {
    _treemapModel = TreemapModel();
    _treemapModel.getTreemap();
  }


  Future<void> _share() async {
    Uint8List pngBytes = await _shotController.makeImageUint8List();
    Uint8List webBytes = await _echartKey?.currentState.webviewController.takeScreenshot();
    DialogUtil.showShareDialog(context,
        children: [
          Container(
            height: 46,
            color: Colours.white,
            padding: EdgeInsets.only(left: 15, top: 16, right: 16, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).treemap,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.textGray800_w700_16
                ),
                Text(DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.NORMAL),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.textGray500_w400_12
                )
              ],
            ),
          ),

          Container(
            color: Colours.white,
            child: Image.memory(webBytes),
          ),
          ShareQRHeader(),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TreemapModel>(
        model: _treemapModel,
        builder: (context, model, child) {
          Widget echart = InappEcharts(
            key: _echartKey,
            onLoad: () {
              _treemapModel.setSuccess();
            },
            option: '''
            {
            series: [{
                type: 'treemap',
                squareRatio: 0.8,
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
                        color: ['#651A21', '#8E242E', '#B72E3B', '#CC3341', '#8797AB', '#4E9768', '#45875D', '#3A794D', '#2B553A'],
                        visualMin: 0,
                        visualMax: 8,
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
                        if (params.value[0] >= 250000000000) {
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
                                    color: '#FFFFFF',
                                    lineHeight: 12,
                                    align: 'center'
                                },
                                name: {
                                    fontSize: 14,
                                    lineHeight: 14,
                                    color: '#FFFFFF',
                                    align: 'center'
                                },
                                label2: {
                                    fontSize: 10,
                                    color: '#FFFFFF',
                                    lineHeight: 10,
                                    align: 'center'
                                },
                                name2: {
                                    fontSize: 10,
                                    lineHeight: 10,
                                    color: '#FFFFFF',
                                    align: 'center'
                                },
                            }
                },
                data: ${jsonEncode(_treemapModel.treeData)}
            }]
            }
            ''',
          );

          return Scaffold(
              backgroundColor: Colours.white,
              appBar: AppBar(
                leading: BackButtonEx(),
                elevation: 1,
                brightness: Brightness.light,
                backgroundColor: Colours.white,
                actions: <Widget>[
                  IconButton(
                    icon: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
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
                          child: Stack(
                              children: [
                                echart,
                                (_treemapModel.isFirst || _treemapModel.isIdle) ? FirstRefresh() :
                                (_treemapModel.isEmpty || _treemapModel.isError) ? LoadingEmpty() : Gaps.empty
                              ])
                      ),
                      Gaps.vGap10,
                      Container(
                        height: 20,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(child: Container(alignment: Alignment.center, child: Text('-8.0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                            Expanded(child: Container(alignment: Alignment.center, child: Text('-6.0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                            Expanded(child: Container(alignment: Alignment.center, child: Text('-4.0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                            Expanded(child: Container(alignment: Alignment.center, child: Text('-2.0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                            Expanded(child: Container(alignment: Alignment.center, child: Text('0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                            Expanded(child: Container(alignment: Alignment.center, child: Text('+2.0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                            Expanded(child: Container(alignment: Alignment.center, child: Text('+4.0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                            Expanded(child: Container(alignment: Alignment.center, child: Text('+6.0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                            Expanded(child: Container(alignment: Alignment.center, child: Text('+8.0%', style: TextStyles.textGray500_w400_10)), flex: 1),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(child: Container(color: Color(0xFF651A21)), flex: 1),
                            Expanded(child: Container(color: Color(0xFF8E242E)), flex: 1),
                            Expanded(child: Container(color: Color(0xFFB72E3B)), flex: 1),
                            Expanded(child: Container(color: Color(0xFFCC3341)), flex: 1),
                            Expanded(child: Container(color: Color(0xFF8797AB)), flex: 1),
                            Expanded(child: Container(color: Color(0xFF4E9768)), flex: 1),
                            Expanded(child: Container(color: Color(0xFF45875D)), flex: 1),
                            Expanded(child: Container(color: Color(0xFF3A794D)), flex: 1),
                            Expanded(child: Container(color: Color(0xFF2B553A)), flex: 1),
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
    );
  }

}

