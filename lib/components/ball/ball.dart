import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ball extends PositionComponent{
  late CircleComponent ball;

  Ball() {
    ball = CircleComponent(radius: 10);
    ball.paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    add(ball);
  }
}
