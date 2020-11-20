import 'package:flutter/material.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/styles.dart';

class MileStoneItem extends StatelessWidget {

  final int index;
  final String content;
  final String time;
  final bool isLast;

  const MileStoneItem(
      {Key key,
        this.index,
        this.content,
        this.isLast = false,
        this.time
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: 80,
                  padding: EdgeInsets.fromLTRB(20, 22, 0, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('2020',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.textGray400_w400_12
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 3.0),
                        child: Text('11/11', style: TextStyles.textGray800_w400_15),
                      ),
                    ],
                  )
              ),
              Container(
                height: double.infinity,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        width: 0.6,
                        height: 26,
                        child: index == 0 ? null : VerticalDivider(width: 0.6, color: Colours.gray_200),
                      ),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colours.gray_200,
                        ),
                      ),
                      Expanded(
                        child: VerticalDivider(width: 0.6, color: Colours.gray_200),
                      ),
                    ]
                ),

              ),
              Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 18, isLast ? 20 : 6),
                    child: Text((content ?? '') + '第三方递四方速递发送到发送到发送到发第三方士大夫沙雕放松的发送到发送到范德萨范德萨范德萨',
                        strutStyle: StrutStyle(forceStrutHeight: true, height:1, leading: 0.5),
                        style: TextStyles.textGray800_w400_15
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
