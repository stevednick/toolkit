import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/stave_position_manager.dart';

class StaveLineDrawer {
  final PositionComponent parent;
  final StavePositionManager positionManager;

  StaveLineDrawer(this.parent, this.positionManager);

  void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: positionManager.staffLineSize(),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(positionManager.staffLinePosX(), i * lineGap);
      parent.add(newLine);
    }
  }
}
