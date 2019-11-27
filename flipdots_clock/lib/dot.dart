import 'package:flutter/material.dart';

import 'spin_widget.dart';

class DotColors {
  DotColors(this.frontside, this.backside);

  Color frontside;
  Color backside;
}

class Dot {
  Dot({this.x, this.y});

  int x;
  int y;
  bool active = false;
  bool _wasActive = false;

  void invert() {
    active = !active;
  }

  Widget widget(DotColors colors) {
    if (active == _wasActive) {
      return Container(
        color: active ? colors.backside : colors.frontside,
      );
    } else {
      _wasActive = active;
      return SpinWidget(
        key: UniqueKey(),
        delay: x * 0.01,
        duration: 0.8,
        halfSpin: true,
        frontColor: active ? colors.frontside : colors.backside,
        backColor: active ? colors.backside : colors.frontside,
      );
    }
  }
}
