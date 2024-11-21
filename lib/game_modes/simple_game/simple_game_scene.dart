import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/arrow.dart';
import 'package:toolkit/components/bouncy_ball.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/components/tick.dart';
import 'package:toolkit/config.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/tempo.dart';
import 'package:toolkit/tools/note_generator.dart';

class SimpleGameScene extends FlameGame {
  final SimpleGameController gameController;

  final Vector2 viewSize = Vector2(300, 500);
  double staffWidth() {
    return 250;
  }

  late Note note;
  late Asset clefSprite;
  PositionComponent componentHolder = PositionComponent();
  final NoteGenerator noteGenerator = NoteGenerator();
  final BouncyBall bouncyBall = BouncyBall();
  double gameTime = 0.0;
  bool showArrow = true;
  bool showBall = false;
  Tick tick = Tick();
  Arrow arrow = Arrow();

  // final bool _ghostNotesOn = false;

  Tempo tempo = Tempo();
  late double beatSeconds;

  NoteData noteData = NoteData.placeholderValue;

  SimpleGameScene(this.gameController) {
    gameController.player.currentNote.addListener(() {
      getAndSetNote();
    });
    gameController.state.addListener(() {
      showArrow = gameController.state.value == GameState.listening;
      if (gameController.state.value == GameState.correctNoteHeard) {
        tick.showTick();
      }
    });
    gameController.gameMode.addListener(() {
      setTempo();
    });
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    world.add(componentHolder);
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;
    drawLines();
    world.add(bouncyBall); // todo extract bouncyBall stuff...
    bouncyBall.position = Vector2(-120, -70);
    tick.position = Vector2(150, -90);
    world.add(tick); // todo extract tick stuff...
    arrow.position = Vector2(190, 0);
    world.add(arrow); // todo you know...
    await setTempo();
  }

  Future<void> setTempo() async {
    showBall = gameController.showTempo;
    bouncyBall.isVisible = showBall;
    beatSeconds = await tempo.loadBeatSeconds();
  }

  @override
  void update(double dt) {
    if (showBall) {
      gameTime += dt; // todo extract this timing shit.
      while (gameTime > beatSeconds) {
        gameTime -= beatSeconds;
      }
      if (gameTime < 0) {
        gameTime = 0;
      }
      bouncyBall.positionBall(gameTime / beatSeconds);
    }
    if (showArrow) {
      arrow.setScale(
        gameController.noteChecker.distanceToCorrectNote(),
      );
    }
    super.update(dt);
  }

  @override
  void onDispose() {
    super.onDispose();
    gameController.player.currentNote.removeListener(getAndSetNote);
    gameController.dispose();
  }

  void newNote(NoteData data) {
    // Change this to just change the note.
    componentHolder.children.clear();
    clefSprite = noteData.clef.sprite..positionSprite();
    PositionComponent clefHolder = PositionComponent();
    componentHolder.add(clefHolder);
    noteData = data;
    note = Note(noteData)..position = Vector2(40, 0);
    componentHolder.add(note);
    clefHolder.add(clefSprite);
    clefHolder.position = Vector2(-70, 0);
  }

  void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: Vector2(staffWidth(), lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(-staffWidth() / 2, i * lineGap);
      world.add(newLine);
    }
  }

  void getAndSetNote() {
    noteData = gameController.getNoteDataFromPlayer();
    newNote(noteData);
  }

  @override
  Color backgroundColor() => Colors.white;
}
