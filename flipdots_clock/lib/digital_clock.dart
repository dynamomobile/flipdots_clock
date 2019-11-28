// Copyright 2019 DYNAMO Consulting AB. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'dot.dart';
import 'dot_display.dart';
import 'dotfont_8x8.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  Timer _timer;

  DotDisplay _display;

  int get _columns {
    return 5 * 8; // 5 chars with 8 pixel width
  }

  int get _rows {
    return (_columns * 3 / 5).floor(); // Fit in the 5:3 aspect ratio
  }

  @override
  void initState() {
    super.initState();
    _display = DotDisplay(columns: _columns, rows: _rows);
    initializeDateFormatting();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      var dateTime = DateTime.now();

      layoutDisplay(dateTime);

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: dateTime.millisecond),
        _updateTime,
      );
    });
  }

  final _lightTheme = DotDisplayTheme(
    background: Color(0xFFE0E0E0),
    dotColors: DotColors(Color(0xFFD0D0D0), Color(0xFF202020)),
  );

  final _darkTheme = DotDisplayTheme(
    background: Color(0xFF101010),
    dotColors: DotColors(Color(0xFF202020), Color(0xFFD0D0D0)),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    return Container(
      color: colors.background,
      child: IgnorePointer(
        child: GridView.count(
          crossAxisCount: _columns,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          children: List.generate(_columns * _rows, (index) {
            final x = index % _columns;
            final y = (index / _columns).floor();
            return _display.dot(x, y)?.widget(colors.dotColors);
          }),
        ),
      ),
    );
  }

  void layoutDisplay(DateTime dateTime) {
    final _dotFont = DotFont8x8();

    final date = DateFormat.Md().format(dateTime);
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(dateTime);
    final minute = DateFormat('mm').format(dateTime);
    final second = DateFormat('ss').format(dateTime);

    var offsetX = 0;
    var offsetY = 2;

    _display.drawString(_dotFont, offsetX, offsetY, '$hour:$minute');

    offsetX = 0;
    offsetY = _display.rows - _dotFont.rows - 1;

    _display.drawString(_dotFont, offsetX, offsetY, '     ');

    switch ((int.parse(second) / 5).floor() % 4) {
      case 0: // first 5 seconds...
      case 3: // last 5 seconds, before the minutes increment
        offsetX = _display.columns - _dotFont.columns * 2;
        _display.drawString(_dotFont, offsetX, offsetY, second);
        break;
      case 1: // Show date
        _display.drawString(_dotFont, offsetX, offsetY, date);
        break;
      case 2: // Show temperature
        // Trim temperature string to fit
        final temp =
            widget.model.temperatureString.replaceFirst(RegExp(r'\.[0-9]'), '');
        offsetX += (5 - temp.length) * _dotFont.columns;
        _display.drawString(_dotFont, offsetX, offsetY, temp);
        break;
      default:
    }
  }
}
