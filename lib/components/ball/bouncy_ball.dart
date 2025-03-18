import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:toolkit/components/ball/ball.dart';

class BouncyBall extends PositionComponent with HasVisibility {
  Ball ball = Ball();

  BouncyBall() {
    add(ball);
  }

  double accel = 600;

  double initialVelocity() {
    return -accel / 2;
  }

  void positionBall(double pointInBeat) {
    // Todo add flash to ball on landing?
    ball.position.y =
        initialVelocity() * pointInBeat + (accel * pow(pointInBeat, 2) / 2);
  }
  void bounce() {
    ball.bounce();
  }
}
