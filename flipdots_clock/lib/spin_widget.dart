// Copyright 2019 DYNAMO Consulting AB. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector3;

enum SpinWidgetSpinDirection {
  left,
  right,
}

/// Spin widget. Spins a widget in 3D, full 360 or 180 degrees.
class SpinWidget extends StatefulWidget {
  SpinWidget({
    Key key,
    this.child,
    this.delay = -1.0,
    this.duration = 0.7,
    this.backColor = Colors.black,
    this.frontColor = Colors.white,
    this.spinDirection = SpinWidgetSpinDirection.left,
    this.halfSpin = false,
  }) : super(key: key);

  static int counter = 0;

  final Widget child;
  final double delay;
  final double duration;
  final Color backColor;
  final Color frontColor;
  final bool halfSpin;
  final SpinWidgetSpinDirection spinDirection;
  final _stateId = SpinWidget.counter++;

  @override
  _SpinWidgetState createState() => _SpinWidgetState();
}

class _SpinWidgetState extends State<SpinWidget> with TickerProviderStateMixin {
  _SpinWidgetState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox box = _itemKey.currentContext.findRenderObject();
      _itemSize = box.size;
      _itemSize = _itemSize / 2.0;
    });
  }

  int _id = -1;

  final _itemKey = GlobalKey();
  var _itemSize = Size.zero;
  var _angle = 0.0;
  AnimationController _animationController;
  Animation _animation;

  @override
  Widget build(BuildContext context) {
    final isBackSide = (_angle > pi / 2.0 && _angle < 3.0 * pi / 2.0);
    if (widget._stateId != _id &&
        widget.delay >= 0.0 &&
        _animationController == null) {
      this._spin();
      _id = widget._stateId;
    }
    return Container(
      transform: Matrix4.identity()
        ..translate(_itemSize.width, _itemSize.height),
      child: Container(
        key: _itemKey,
        color: isBackSide ? widget.backColor : widget.frontColor,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.015)
          ..rotate(
              Vector3(
                  0,
                  widget.spinDirection == SpinWidgetSpinDirection.left ? 1 : -1,
                  0),
              _angle)
          ..translate(-_itemSize.width, -_itemSize.height),
        // Child widget disabled for this project. If you want to use this code,
        // uncomment below part to enable the child widget.
        // child: isBackSide
        //     ? Container(
        //         width: _itemSize.width * 2,
        //         height: _itemSize.height * 2,
        //       )
        //     : widget.child,
      ),
    );
  }

  void _spin() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: (1000.0 * widget.duration).toInt()),
        vsync: this);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
    final tween =
        Tween<double>(begin: 0.0, end: widget.halfSpin ? pi : pi * 2.0)
            .animate(_animation);
    tween.addListener(() {
      setState(() {
        _angle = tween.value;
      });
    });
    tween.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _dismissAnimation();
      }
    });
    Future.delayed(Duration(milliseconds: (1000.0 * widget.delay).toInt()))
        .then((_) {
      _animationController?.forward();
    });
  }

  void _dismissAnimation() {
    _animationController?.dispose();
    _animationController = null;
    _animation = null;
  }

  @override
  void dispose() {
    _dismissAnimation();
    super.dispose();
  }
}
