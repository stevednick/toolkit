import 'package:toolkit/components/bouncy_ball.dart';

class GameTimer {
  double _gameTime = 0.0;
  double _beatSeconds;
  final BouncyBall bouncyBall;

  GameTimer(this._beatSeconds, this.bouncyBall);

  void update(double dt) {
    _gameTime += dt;
    while (_gameTime > _beatSeconds) {
      _gameTime -= _beatSeconds;
    }

    if (_gameTime < 0) _gameTime = 0;
    bouncyBall.positionBall(_gameTime / _beatSeconds);
  }

  void setBeatSeconds(double beatSeconds) {
    _beatSeconds = beatSeconds;
  }

  double get gameTime => _gameTime;
}