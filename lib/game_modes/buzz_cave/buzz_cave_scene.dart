import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart';  // Import Flame collision package
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/buzz_cave/buzz_cave_controller.dart';

class BuzzCaveScene extends FlameGame with HasCollisionDetection {
  final Vector2 viewSize = Vector2(500, 300);
  late BuzzCaveController gameController;
  final PlayerBallComponent player = PlayerBallComponent();

  double smoothFactor = 5.0;
  Vector2 targetPosition = Vector2(0, 0);

  Vector2 spawnPosition = Vector2(600, 0);
  double spawnHeightVariation = 150;
  int spawnPeriodmillis = 1500;
  double gameYLimit = 100;

  BuzzCaveScene(this.gameController) {
    gameController.heardPitch.addListener(() {
      targetPosition = Vector2(-200, gameController.getBallPosition()*-gameYLimit);
    });
    gameController.enemiesSpawned.addListener((){
      spawnEnemy();
      player.isVisible = true;
    });
  }

  @override
  FutureOr<void> onLoad() async{
    setUpBall();
    super.onLoad();
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;
  }

  void setUpBall() {
    world.add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Interpolate manually between the ball's current position and the target position
    player.position.x += (targetPosition.x - player.position.x) * smoothFactor * dt;
    player.position.y += (targetPosition.y - player.position.y) * smoothFactor * dt;
  }

  @override
  void onDispose() {
    gameController.dispose();
    super.onDispose();
  }

  void spawnEnemy() {
    ObstacleBallComponent enemy;
    if (Random().nextInt(2) > 0){
      enemy = ObstacleBallComponent(Colors.green, gameController.pickMeUpHit);
    } else {
      enemy = ObstacleBallComponent(Colors.red, gameController.enemyHit);
    }
    enemy.position = spawnPosition;
    Random random = Random();
    double yOffset = (random.nextDouble() * spawnHeightVariation * 2) - spawnHeightVariation;
    enemy.position.y += yOffset;
    world.add(enemy);
  }

  @override
  Color backgroundColor() => Colors.white;
}

// Define the BallComponent with collision
class PlayerBallComponent extends CircleComponent with CollisionCallbacks, HasVisibility {
  PlayerBallComponent() {
    radius = 10;
    paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
  }

  @override
  Future<void> onLoad() async {
    // Add CircleHitbox for collision detection
    add(CircleHitbox());
    isVisible = false;
    super.onLoad();
  }
}

class ObstacleBallComponent extends CircleComponent with CollisionCallbacks {

  final Color colour;
  double enemySpeed = 400;

  final Function() onHit;

  ObstacleBallComponent(this.colour, this.onHit){
    radius = 30;
    paint = Paint()
      ..color = colour
      ..style = PaintingStyle.fill;
  }

  @override
  Future<void> onLoad() async {
    // Add CircleHitbox for collision detection
    add(CircleHitbox());
    super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= enemySpeed * dt;
    super.update(dt);
    if (position.x <= -300) {
      removeFromParent();
    }
  }

  // Override the collision callback
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    onHit();
    removeFromParent();
    super.onCollision(intersectionPoints, other);
  }
}