import 'dart:core';

import 'package:flutter/services.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/ui/widget/easyrefresh/first_refresh.dart';
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

  bool _init = false;

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
              onPressed: () => ToastUtil.normal('click share'),
            )
          ],
          centerTitle: true,
          title: Text(S.of(context).treemap, style: TextStyles.textBlack16),
        ),
        body: Container(
          child: Echarts(
            option: '''
            {
            series: [{
                type: 'treemap',
                left: '0%',
                right: '0%',
                bottom: '0%',
                top: '0%',
                nodeClick: false,
                roam: false,
                breadcrumb: {
                    show: false
                },
                levels: [
                    {
                        color: ['#ff0000', '#00ff00', '#0000ff', '#000000'],
                        visualMin: 0,
                        visualMax: 3,
                        colorMappingBy: 'value', 
                        visualDimension: 1,
                        
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1,
                            gapWidth: 1
                        }
                    }
                ],
                label: {
                    position: 'inside',
                    formatter: function (params) {
                        var arr = [
                            '{name|' + params.name + '}',
                            '{label|' + params.value[0] + '}',
                        ];
        
                        return arr.join('\\n');
                    },
                    rich: {
                                label: {
                                    fontSize: 12,
                                    color: '#fff',
                                    lineHeight: 20,
                                    align: 'center'
                                },
                                name: {
                                    fontSize: 15,
                                    lineHeight: 30,
                                    color: '#fff'
                                },
                            }
                },
                data: [{
                    name: 'nodeA', 
                    value: [10, 0],
                },
                {
                    name: 'nodeB',
                    value: [6, 1],
                },
                {
                    name: 'nodeC',
                    value: [5, 2]
                },
                {
                    name: 'nodeD',
                    value: [5, 2]
                },
                {
                    name: 'nodeE',
                    value: [4, 3]
                },
                ]
            }]
            }
            ''',
          ),
        )
    );
  }

}

