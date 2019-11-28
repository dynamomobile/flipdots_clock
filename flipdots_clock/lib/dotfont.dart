// Copyright 2019 DYNAMO Consulting AB. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// Abstract class for the bitmap font. Draw a character by supply a callback for updating individual bits.
abstract class DotFont {
  DotFont(this.columns, this.rows);

  final columns;
  final rows;

  @protected
  List<String> charData(String char);

  void _drawCharData(List<String> charData, int offsetX, int offsetY,
      void update(int x, int y, bool active)) {
    for (int y = 0; y < rows; y++) {
      final line = charData[y];
      for (int x = 0; x < columns; x++) {
        update(x + offsetX, y + offsetY, line[x] == '#');
      }
    }
  }

  void drawChar(int offsetX, int offsetY, String char,
      void update(int x, int y, bool active)) {
    final charData = this.charData(char);
    if (charData != null) {
      _drawCharData(charData, offsetX, offsetY, update);
    }
  }
}
