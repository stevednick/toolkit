import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/tools/config.dart';

class RangeSelectionBarLine extends PositionComponent{

  late RectangleComponent barLine;

  RangeSelectionBarLine(){
    drawLines();
  }

    void drawLines() {
    barLine = RectangleComponent(
      size: Vector2(lineWidth, lineGap * 4),
      paint: Paint()..color = Colors.black,
    )..position = Vector2(50, -2 * lineGap);
    add(barLine);
    barLine.setAlpha(0);
  }

  void showLine(bool show){
    barLine.setAlpha(show ? 255 : 0);
  }
}