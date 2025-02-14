import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ball extends CircleComponent {
  Ball() {
    radius = 10;
    paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
  }
}

class BouncyBall extends PositionComponent with HasVisibility {
  late Ball ball;
  double accel = 600;

  BouncyBall({Ball? ball}) : ball = ball ?? Ball() {
    add(this.ball);
  }

  double initialVelocity() {
    return -accel / 2;
  }

  void positionBall(double pointInBeat) {
    ball.position.y = initialVelocity() * pointInBeat + (accel * pow(pointInBeat, 2) / 2);
  }
}