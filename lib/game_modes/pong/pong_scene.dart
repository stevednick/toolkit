import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/config.dart';
import 'package:toolkit/game_modes/pong/pong_ball.dart';
import 'package:toolkit/game_modes/pong/pong_controller.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/sprites/ball.dart';

class PongScene extends FlameGame {
  final PongController gameController;

  final Vector2 viewSize = Vector2(300, 500);
  final double staffWidth = 250;
  int side;
  late Note note;
  late Asset clefSprite;
  PositionComponent componentHolder = PositionComponent();
  PongBall pongBall = PongBall();

  NoteData noteData = NoteData.placeholderValue;

  PongScene(this.gameController, this.side) {
    getAndSetNote();
    //addClef();
    gameController.players[side].score.addListener(() {
      //ball.goGreen();
    });
    gameController.players[side].currentNote.addListener(() {
      getAndSetNote();
    });
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    world.add(componentHolder);
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;
    for (int player = 0; player < 2; player++) {
      drawLines();
      newNote(noteData);
    }
    if (side == 1) {
      world.add(pongBall);
      pongBall.position = Vector2(-400, -70);
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

  void newNote(NoteData data) {
    componentHolder.children.clear();
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
