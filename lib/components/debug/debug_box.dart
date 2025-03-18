import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class DebugBox extends PositionComponent {
  final Vector2 s;
  final Paint paint;

  DebugBox(Vector2 position, this.s, {Color color = Colors.red}) 
      : paint = BasicPalette.blue.paint() {
        size = s;
    this.position = position;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), paint);
  }
}
