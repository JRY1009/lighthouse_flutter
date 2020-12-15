

import 'package:lighthouse/net/model/quote_ws.dart';

class WsEvent {
  QuoteWs quoteWs;
  WsEventState state;

  WsEvent(this.quoteWs, this.state);
}

enum WsEventState {
  quote
}
