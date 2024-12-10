import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/components.dart';
import 'package:toolkit/tools/config.dart';
import 'package:toolkit/game_modes/pong/pong_ball.dart';
import 'package:toolkit/game_modes/pong/pong_controller.dart';
import 'package:toolkit/models/models.dart';

class PongScene extends FlameGame {
  final PongController gameController;

  final Vector2 viewSize = Vector2(300, 500);
  final double staffWidth = 250;
  int side;
  late Note note;
  late Asset clefSprite;
  PositionComponent componentHolder = PositionComponent();
  PongBall pongBall = PongBall();
  Tick tick = Tick();

  NoteData noteData = NoteData.placeholderValue;

  PongScene(this.gameController, this.side) {
    getAndSetNote();
    //addClef();
    gameController.players[side].score.addListener(() {
      tick.showTick();
    });
    gameController.players[side].currentNote.addListener(() {
      getAndSetNote();
    });
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    world.add(componentHolder);
    //camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.zoom = 0.85;
    camera.viewfinder.anchor = Anchor.center;
    world.add(tick);
    tick.position = Vector2(150, -70);
    for (int player = 0; player < 2; player++) {
      drawLines();
      newNote(noteData);
    }
    if (side == 1) {
      world.add(pongBall);
      pongBall.position = Vector2(-360, -70);
    }
  }

  @override
  void update(double dt) {
    if (side == 1) {
      gameController.update(dt);
      pongBall.positionBall(gameController.time);
    }

    // TODO: implement update
    super.update(dt);
  }

  @override
  void onDispose() {
    super.onDispose();
    gameController.dispose();
  }

  // void setBallPosition(double width){
  //   if (side == 1) {
  //     pongBall.position = Vector2(-320 - width, -70);
  //     pongBall.xOffset = width+180;
  //   }
  // }

  void newNote(NoteData data) {
    componentHolder.children.toList().forEach((child) {
      child.removeFromParent();
    });
    noteData = data;
    note = Note(noteData)..position = Vector2(40, 0);
    componentHolder.add(note);
    clefSprite = noteData.clef.sprite..positionSprite();
    PositionComponent clefHolder = PositionComponent();
    componentHolder.add(clefHolder);
    clefHolder.add(clefSprite);
    clefHolder.position = Vector2(-70, 0);
  }

  void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: Vector2(staffWidth, lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(-staffWidth / 2, i * lineGap);
      world.add(newLine);
    }
  }

  void getAndSetNote() {
    noteData = gameController.getNoteDataFromPlayer(side);
    newNote(noteData);
  }

  @override
  Color backgroundColor() => Colors.white;
}
