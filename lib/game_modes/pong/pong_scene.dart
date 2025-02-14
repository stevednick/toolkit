import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/stave.dart';
import 'package:toolkit/components/tick.dart';
import 'package:toolkit/game_modes/pong/pong_ball.dart';
import 'package:toolkit/game_modes/pong/pong_controller.dart';

class PongScene extends FlameGame{
  final PongController gameController;
  double screenWidth = 1000;
  final double width = 1200;

  late List<Stave> staves;

  PongBall pongBall = PongBall();

  List<Tick> ticks = [Tick(), Tick()];

  PongScene(this.gameController){
    addStaves();
    addListeners();
    addPongBall();
    addTicks();
  }

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.zoom = screenWidth / width;
    camera.viewfinder.anchor = Anchor.center;
    return super.onLoad();
  }
  @override
  void update(double dt){
    gameController.update(dt);
    pongBall.positionBall(gameController.time);
    super.update(dt);
  }

  void addListeners(){
    for (int i = 0; i < 2; i++) {
      gameController.players[i].currentNote.addListener(() {
        staves[i].changeNote(
          gameController.players[i].currentNote.value,
          0.4
        );
      });
      gameController.players[i].score.addListener(() {
        ticks[i].showTick();
      });
    }
  }

  Future<void> addStaves() async {
    staves = [
      Stave(gameController.players[0], 300)..position = Vector2(-300, 0),
      Stave(gameController.players[1], 300)..position = Vector2(300, 0),
    ];
    world.addAll(staves);
  }

  void addPongBall(){
    world.add(pongBall);
    pongBall.position = Vector2(-160, -70);
  }

  void addTicks(){
    for (int i = 0; i < 2; i++) {
      world.add(ticks[i]);
      ticks[i].position = Vector2(150 * (i * 2 - 1), -100);
    }
  }

  @override
  Color backgroundColor() => Colors.white;
}