import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Ball extends PositionComponent {
  late CircleComponent ball;

  @override
  Future<void> onLoad() async {
    ball = CircleComponent(radius: 10);
    ball.paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    add(ball); // Add the ball after it's initialized
  }
  void bounce() {
  // Pulse Effect (Scale)
  ball.add(
    ScaleEffect.to(
      Vector2.all(1.5), // Scale up to 1.3x size
      EffectController(
        duration: 0.1, 
        reverseDuration: 0.1, 
        curve: Curves.easeOut
      ),
    ),
  );

  // // Flash Effect (Manual Color Change)
  // final originalColor = ball.paint.color; // Store original color
  // ball.paint.color = Colors.blue; // Change to flash color

  // // Revert back to original color after 100ms
  // Future.delayed(const Duration(milliseconds: 100), () {
  //   ball.paint.color = originalColor;
  // });
}


}
