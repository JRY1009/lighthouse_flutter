
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/res/gaps.dart';

class MoneyUnitSelectDialog extends StatelessWidget {

  final ValueChanged<String> selectCallback;


  MoneyUnitSelectDialog({
    Key key,
    this.selectCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min, //wrap_content
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              child: Column(
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        selectCallback('CNY');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
                          ),
                          child: Text('CNY',
                            style: TextStyles.textGray800_w400_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      )
                  ),

                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        selectCallback('USD');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.6, color: Colours.default_line))
                          ),
                          child: Text('USD',
                            style: TextStyles.textGray800_w400_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      )
                  ),

                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        selectCallback('BTC');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0))),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: double.infinity,
                          child: Text('BTC',
                            style: TextStyles.textGray800_w400_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      )
                  ),
                ],
              ),
            ),
            Gaps.vGap10
          ],
        )
    );
  }
}
