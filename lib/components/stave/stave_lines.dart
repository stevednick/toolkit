import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/stave.dart';
import 'package:toolkit/tools/config.dart';

class StaveLines extends PositionComponent {

  late StavePositionManager positionManager;

  StaveLines(this.positionManager){
    drawLines();
  }

   void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: positionManager.staffLineSize(),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(positionManager.staffLinePosX(), i * lineGap);
      add(newLine);
    }
  }
}