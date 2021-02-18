import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/chart/inapp_echart.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:module_home/viewmodel/treemap_model.dart';

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
    return ProviderWidget<TreemapModel>(
        model: _treemapModel,
        builder: (context, model, child) {
          return Scaffold(
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
                        child: Container(
                          child: _treemapModel.isFirst ? FirstRefresh() : InappEcharts(
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
                data: ${jsonEncode(_treemapModel.treeData)}
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
    );
  }

}

