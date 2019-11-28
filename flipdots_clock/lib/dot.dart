// Copyright 2019 DYNAMO Consulting AB. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'spin_widget.dart';

/// Colors used for a dot when creating the spinning widget.
class DotColors {
  DotColors(this.frontside, this.backside);

  Color frontside;
  Color backside;
}

/// Single dot that keeps track of current and previous state for animation update.
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
        spinDirection: SpinWidgetSpinDirection.right,
        frontColor: active ? colors.frontside : colors.backside,
        backColor: active ? colors.backside : colors.frontside,
      );
    }
  }
}
