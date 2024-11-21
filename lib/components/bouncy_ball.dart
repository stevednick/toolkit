import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BouncyBall extends PositionComponent with HasVisibility{
  late CircleComponent ball;
  double accel = 600;
  // double _deformationFactor = 1.0;
  // static const double maxDeformation = 1;

  BouncyBall() {
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
    ball.position.y = initialVelocity() * pointInBeat + (accel * pow(pointInBeat, 2) / 2);
    
    // Calculate deformation based on position
    // double normalizedPosition = ball.position.y / (accel / 2);
    // _deformationFactor = 1.0 - (maxDeformation * (1.0 - (normalizedPosition - 1).abs()));
    
    // Apply deformation
    // ball.scale = Vector2(1 / _deformationFactor, _deformationFactor);
  }

}