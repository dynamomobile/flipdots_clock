// Copyright 2019 DYNAMO Consulting AB. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4;

enum SpinWidgetSpinDirection {
  left,
  right,
}

/// Spin widget. Spins a widget in 3D, full 360 or 180 degrees.
class SpinWidget extends AnimatedWidget {
  SpinWidget({
    Key key,
    @required Listenable listenable,
    this.child,
    this.begin = 0.0,
    this.end = 1.0,
    this.backColor = Colors.black,
    this.frontColor = Colors.white,
    this.spinDirection = SpinWidgetSpinDirection.left,
    this.halfSpin = false,
  })  : _itemKey = GlobalKey(),
        _animation = Tween<double>(
          begin: 0.0,
          end: halfSpin ? pi : pi * 2.0,
        ).animate(CurvedAnimation(
          parent: listenable,
          curve: Interval(
            begin,
            end,
            curve: Curves.fastOutSlowIn,
          ),
        )),
        super(key: key, listenable: listenable);

  final Widget child;
  final double begin;
  final double end;
  final Color backColor;
  final Color frontColor;
  final bool halfSpin;
  final SpinWidgetSpinDirection spinDirection;

  final _itemKey;
  final Animation _animation;

  @override
  Widget build(BuildContext context) {
    RenderBox box = _itemKey.currentContext?.findRenderObject();
    var itemSize = box?.size ?? Size.zero;
    final isBackSide =
        (_animation.value > pi / 2.0 && _animation.value < 3.0 * pi / 2.0);
    return Transform(
      alignment: Alignment(0, 0),
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.015)
        ..rotateY(spinDirection == SpinWidgetSpinDirection.left
            ? _animation.value
            : -_animation.value),
      child: Container(
        key: _itemKey,
        color: isBackSide ? backColor : frontColor,
        child: isBackSide
            ? Container(
                width: itemSize.width,
                height: itemSize.height,
              )
            : child,
      ),
    );
  }
}
