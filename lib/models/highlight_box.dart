import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class HighlightBox extends PositionComponent {
  final Vector2 start;
  final Vector2 end;

  HighlightBox(this.start, this.end);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = const Color(0x8800FF00) // Semi-transparent green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(
      Rect.fromPoints(
        Offset(start.x, start.y),
        Offset(end.x, end.y),
      ),
      paint,
    );
  }
}