

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_base/constant/constant.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/mvvm/base_page.dart';
import 'package:library_base/mvvm/provider_widget.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/gaps.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/widget/button/back_button.dart';
import 'package:library_base/widget/common_scroll_view.dart';
import 'package:library_base/widget/dialog/dialog_util.dart';
import 'package:library_base/widget/dialog/share_widget.dart';
import 'package:library_base/widget/easyrefresh/first_refresh.dart';
import 'package:library_base/widget/image/local_image.dart';
import 'package:library_base/widget/shot_view.dart';
import 'package:library_base/utils/image_util.dart';
import 'package:module_quote/item/global_quote_item.dart';
import 'package:module_quote/item/global_quote_round_item.dart';
import 'package:module_quote/viewmodel/global_quote_model.dart';
import 'package:module_quote/quote_router.dart';
import 'package:module_quote/widget/global_quote_appbar.dart';

import '../quote_router.dart';


class GlobalQuotePage extends StatefulWidget {

  GlobalQuotePage({
    Key? key,
  }) : super(key: key);

  @override
  _GlobalQuotePageState createState() => _GlobalQuotePageState();
}

class _GlobalQuotePageState extends State<GlobalQuotePage> with BasePageMixin<GlobalQuotePage>, SingleTickerProviderStateMixin {

  ShotController _shotController = new ShotController();

  late GlobalQuoteModel _globalQuoteModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initViewModel() {
    _globalQuoteModel = GlobalQuoteModel();
    _globalQuoteModel.getGlobalAll();
  }

  @override
  Future<void> refresh({slient = false}) {
    return _globalQuoteModel.getGlobalAll();
  }

  Future<void> _share() async {
    Uint8List pngBytes = await _shotController.makeImageUint8List();

    DialogUtil.showShareDialog(context,
        children: [
          Container(
            color: Colours.gray_100,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      child: RotatedBox(
                        quarterTurns: 1, // 90°的整数倍
                        child: Image.memory(pngBytes),
                      ),
                    ),
                    Container(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: GlobalQuoteShareBar(btcUsdPair: _globalQuoteModel.btcUsdPair, ethUsdPair: _globalQuoteModel.ethUsdPair),
                      ),
                    ),
                    Positioned(
                        bottom: 24,
                        left: 30,
                        child: Container(
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Text(DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.NORMAL) ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.textGray500_w400_12
                            ),
                          ),
                        )
                    )
                  ],
                ),
                ShareQRFoooter(backgroundColor: Colours.gray_100),
              ],
            ),
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.gray_100,
        appBar: AppBar(
            leading: BackButtonEx(),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            backgroundColor: Colours.white,
            actions: <Widget>[
              IconButton(
                icon: LocalImage('icon_share', package: Constant.baseLib, width: 20, height: 20),
                onPressed: _share,
              )
            ],
            centerTitle: true,
            title: Text(S.of(context).globalQuote, style: TextStyles.textBlack16)
        ),
        body: ProviderWidget<GlobalQuoteModel>(
            model: _globalQuoteModel,
            builder: (context, model, child) {
              String? package = QuoteRouter.isRunModule ? null : Constant.moduleQuote;
              return RefreshIndicator(
                  onRefresh: model.getGlobalAll,
                  child: model.isFirst ? FirstRefresh() :
                  Stack(
                    children: [
                      CommonScrollView(
                        physics: ClampingScrollPhysics(),
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: ClampingScrollPhysics(),
                                    child: ShotView(
                                      controller: _shotController,
                                      child: Container(
                                        height: 428,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(ImageUtil.getImgPath('bg_world_map'), package: package),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: AspectRatio (
                                            aspectRatio: 1.7,
                                            child: Stack(
                                              children: _buildItem(),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                              ),


                              Container(
                                  margin: EdgeInsets.fromLTRB(12, 400, 12, 20),
                                  decoration: BoxDecoration(
                                    color: Colours.white,
                                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                                    boxShadow: BoxShadows.normalBoxShadow,
                                  ),
                                  child: Column(
                                    children: [

                                      GridView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.fromLTRB(15, 18, 15, 12),
                                        physics: const NeverScrollableScrollPhysics(),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 0.95,
                                        ),
                                        itemCount: model.quoteList.length,
                                        itemBuilder: (_, index) {
                                          return GlobalQuoteItem(
                                            index: index,
                                            name: model.quoteList[index].zh_name,
                                            price: model.quoteList[index].quote as double,
                                            change: model.quoteList[index].change_amount as double,
                                            rate: model.quoteList[index].change_percent as double,
                                          );
                                        },
                                      ),
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          child: Text('*' + S.of(context).quoteDefinition, style: TextStyles.textGray500_w400_12)
                                      ),
                                      Gaps.vGap18,
                                    ],
                                  )
                              ),
                            ],
                          ),


                        ],
                      ),

                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: GlobalQuoteAppBar(height: 55),
                      ),
                    ],
                  )

              );
            }
        )
    );
  }

  List<Widget> _buildItem() {
    final list = List.generate(_globalQuoteModel.quoteList.length, (index) {
      return GlobalQuoteRoundItem(
        index: index,
        name: _globalQuoteModel.quoteList[index].zh_name,
        posX: _globalQuoteModel.quoteList[index].posX as double,
        posY: _globalQuoteModel.quoteList[index].posY as double,
        rate: _globalQuoteModel.quoteList[index].change_percent as double,
      );
    });
    return list;
  }
}
