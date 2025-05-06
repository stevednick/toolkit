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

    add(ball); 
  }

  void bounce() {
    ball.add(
      ScaleEffect.to(
        Vector2.all(1.5), 
        EffectController(
            duration: 0.1, reverseDuration: 0.1, curve: Curves.easeOut),
      ),
    );
  }
}
