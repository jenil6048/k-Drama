
import 'package:flutter/scheduler.dart';


///use for tab bar controller in state less widget
class CustomTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

///use like this
/// TabController tabController=TabController(length: 2,vsync: CustomTickerProvider());
/// controller.animateTo(0);
