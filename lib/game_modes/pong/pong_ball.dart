import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PongBall extends PositionComponent with HasVisibility {
  late CircleComponent ball;
  double accel = 900;
  double xOffset = 235;
  // double _deformationFactor = 1.0;
  // static const double maxDeformation = 1;

  PongBall() {
    ball = CircleComponent(radius: 10);
    ball.paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    add(ball);
  }

  double initialVelocity() {
    return -accel / 2;
  }

  void positionBall(double pointInBeat) {
    ball.position.y = initialVelocity() * fixedRemainder(pointInBeat) +
        (accel * pow(fixedRemainder(pointInBeat), 2) / 2);
    if (pointInBeat < -1){
      ball.position.x = xOffset/2;
    } else if (pointInBeat < 0){
      ball.position.x = (1 - fixedRemainder(pointInBeat)) * xOffset / 2;
    } else if (pointInBeat < 1) {
      ball.position.x = 0;
    } else if (pointInBeat < 2){
      ball.position.x = pointInBeat.remainder(1) * xOffset;
    } else if (pointInBeat < 3){
      ball.position.x = xOffset;
    } else {
      ball.position.x = (1 - pointInBeat.remainder(1)) * xOffset;
    }

    // Calculate deformation based on position
    // double normalizedPosition = ball.position.y / (accel / 2);
    // _deformationFactor = 1.0 - (maxDeformation * (1.0 - (normalizedPosition - 1).abs()));

    // Apply deformation
    // ball.scale = Vector2(1 / _deformationFactor, _deformationFactor);
  }
  double fixedRemainder(double value){
    return (value+10).remainder(1);
  }
}
