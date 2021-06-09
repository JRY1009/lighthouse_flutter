

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:library_base/event/event.dart';
import 'package:library_base/event/ws_event.dart';
import 'package:library_base/model/quote_ws.dart';
import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_kchart/entity/depth_entity.dart';
import 'package:module_quote/quote_router.dart';

class SpotDepthModel extends ViewStateModel {

  List<DepthEntity>? bidsList, asksList;
  num bidAmountMax = 0, askAmountMax = 0;

  StreamSubscription? quoteSubscription;

  SpotDepthModel() :
        super(viewState: ViewState.first) {
  }

  void listenEvent() {
    quoteSubscription?.cancel();

    quoteSubscription = Event.eventBus.on<WsEvent>().listen((event) {
      QuoteWs quoteWs = event.quoteWs;
      if (quoteWs == null) {
        return;
      }
    });
  }

  Future getDepth(String chain, {bool isChart = true}) async {
    Map<String, dynamic> params = {
      'chain': chain,
    };

    setBusy();

    rootBundle.loadString(QuoteRouter.isRunModule ?
    'assets/depth.json' :
    'packages/module_quote/assets/depth.json').then((result) {
      final parseJson = json.decode(result);
      Map tick = parseJson['data'];
      var bids = tick['bids'].map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
      var asks = tick['asks'].map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();

      if (isChart) {
        initDepthChart(bids, asks);
      } else {
        initDepth(bids, asks);
      }
      
      setSuccess();
    });
  }
  
  void initDepthChart(List<DepthEntity>? bids, List<DepthEntity>? asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    bidsList = [];
    asksList = [];
    double amount = 0.0;
    bids.sort((left, right) => left.price.compareTo(right.price));
    //倒序循环 //累加买入委托量
    bids.reversed.forEach((item) {
      amount += item.amount;
      item.amount = amount;
      bidsList!.insert(0, item);
    });

    amount = 0.0;
    asks.sort((left, right) => left.price.compareTo(right.price));
    //循环 //累加买入委托量
    asks.forEach((item) {
      amount += item.amount;
      item.amount = amount;
      asksList!.add(item);
    });
  }

  void initDepth(List<DepthEntity> bids, List<DepthEntity> asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    bidsList = [];
    asksList = [];

    int index = 0;
    bids.sort((left, right) => left.price.compareTo(right.price));
    //循环
    bids.reversed.forEach((item) {
      if (index++ < 20) {
        bidAmountMax = max(bidAmountMax, item.amount);
      }
      bidsList!.add(item);
    });

    index = 0;
    asks.sort((left, right) => left.price.compareTo(right.price));
    //循环
    asks.forEach((item) {
      if (index++ < 20) {
        askAmountMax = max(askAmountMax, item.amount);
      }
      asksList!.add(item);
    });
  }

  @override
  void dispose() {
    quoteSubscription?.cancel();
    super.dispose();
  }
}
