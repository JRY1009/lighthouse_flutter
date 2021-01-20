
import 'package:flutter/widgets.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';

class QuotationTab extends StatefulWidget {

  const QuotationTab({
    this.title,
    this.subTitle,
    this.subStyle
  });

  final String title;
  final String subTitle;
  final TextStyle subStyle;

  @override
  _QuotationTabState createState() => _QuotationTabState();
}

class _QuotationTabState extends State<QuotationTab> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.title ?? '',
            style: TextStyles.textGray800_w400_15,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Gaps.vGap3,
          Text(widget.subTitle ?? '',
            style: widget.subStyle ?? TextStyles.textGray400_w400_12,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
