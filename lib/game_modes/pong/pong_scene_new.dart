import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/stave/stave.dart';
import 'package:toolkit/game_modes/pong/pong_ball.dart';
import 'package:toolkit/game_modes/pong/pong_controller.dart';

class PongScene extends FlameGame{
  final PongController gameController;
  double screenWidth = 1000;
  final double width = 1200;

  late List<Stave> staves;

  PongBall pongBall = PongBall();

  PongScene(this.gameController){
    addStaves();
    addListeners();
    addPongBall();
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
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
    print("Adding listeners");
    gameController.players[0].currentNote.addListener(() {
      print("Note changed");
      staves[0].changeNote(gameController.players[0].currentNote.value, 0.4);
      
    });
    gameController.players[1].currentNote.addListener(() {
      staves[1].changeNote(gameController.players[1].currentNote.value, 0.4);
    });
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

  @override
  Color backgroundColor() => Colors.white;
}