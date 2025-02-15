import 'dart:math';
import 'package:flame/components.dart';
import 'package:toolkit/components/ball/ball.dart';

class PongBall extends PositionComponent with HasVisibility {
  late Ball ball;
  double accel = 1000;
  double xOffset = 320;
  PongBall() {
    ball = Ball();
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
  }
  double fixedRemainder(double value){
    return (value+10).remainder(1);
  }
}
