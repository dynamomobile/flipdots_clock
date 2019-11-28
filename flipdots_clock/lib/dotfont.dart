// Copyright 2019 DYNAMO Consulting AB. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class DotFont {
  DotFont(this.columns, this.rows);

  final columns;
  final rows;

  List<String> charData(String char) {
    return null;
  }

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
