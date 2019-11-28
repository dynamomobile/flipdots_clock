// Copyright 2019 DYNAMO Consulting AB. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'dot.dart';
import 'dotfont.dart';

class DotDisplayTheme {
  DotDisplayTheme({this.background, this.dotColors});

  Color background;
  DotColors dotColors;
}

class DotDisplay {
  DotDisplay({this.columns, this.rows})
      : _grid = List.generate(columns,
            (column) => List.generate(rows, (row) => Dot(x: column, y: row)));

  final int columns;
  final int rows;
  final List<List<Dot>> _grid;

  void invert() {
    _grid.forEach((row) {
      row.forEach((dot) {
        dot.invert();
      });
    });
  }

  void setDot(int x, int y, bool active) {
    // Clip to boundary
    if (x >= 0 && x < columns && y >= 0 && y < rows) {
      _grid[x][y].active = active;
    }
  }

  Dot dot(int x, int y) {
    if (x >= 0 && x < columns && y >= 0 && y < rows) {
      return _grid[x][y];
    }
    return null;
  }

  int drawString(DotFont dotFont, int offsetX, int offsetY, String string) {
    var width = 0;
    string.split('').forEach((char) {
      dotFont.drawChar(offsetX + width, offsetY, char, (x, y, active) {
        setDot(x, y, active);
      });
      width += dotFont.columns;
    });
    return width;
  }
}
