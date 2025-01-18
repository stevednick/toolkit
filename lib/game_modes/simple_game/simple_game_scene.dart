import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/components.dart';
import 'package:toolkit/components/stave.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';

class SimpleGameScene extends FlameGame {
  final SimpleGameController gameController;
  final GameStateManager stateManager = GameStateManager();

  final NoteGenerator noteGenerator = NoteGenerator();

  bool loadComplete = false;

  NoteData currentNoteData = NoteData.placeholderValue;
  late NoteData nextNote;
  bool noteChangeQueued = false;

  late Stave stave;

  double width = 1000;
  double screenWidthRatio = 3;

  late PositionManager positionManager;

  Tick tick = Tick();

  final BouncyBall bouncyBall = BouncyBall();
  Tempo tempo = Tempo(key: 'simple_game_tempo');
  double beatSeconds = 1000;
  double gameTime = 0;

  bool fadeClef = false;
  bool initialNoteLoaded = false;

  SimpleGameScene(
    this.gameController,
  );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    gameController.player.currentNote.addListener(() {
      if (!initialNoteLoaded) {
        queueNewNote(gameController.player.currentNote.value);
        initialNoteLoaded = true;
      }
    });
    gameController.state.addListener(() {
      if (gameController.state.value == GameState.correctNoteHeard) {
        queueNewNote(gameController.player.currentNote.value);
        tick.showTick();
      }
    });

    stateManager.showGhostNotes = //  todo Move loading to state manager?
        await Settings.getSetting(Settings.ghostNoteString);
    stateManager.showBall = await Settings.getSetting(Settings.tempoKey);
    positionManager = PositionManager(stateManager);
    await buildAllElements();
    gameController.noteChecker.noteNotifier.addListener(() {
      if (stateManager.showGhostNotes) {
        stave.showGhostNote(
            gameController.noteChecker.noteNotifier.value,
            gameController.player.currentNote.value.noteNum);
      }
    });
    //camera.viewfinder.zoom =
    //    positionManager.scaleFactor(width, screenWidthRatio);
    camera.viewfinder.anchor = Anchor.center;
    loadComplete = true;
    gameController.changeNote();
    beatSeconds = await tempo.loadBeatSeconds();
    stave = Stave(gameController.player, width/screenWidthRatio,
        showGhostNotes: stateManager.showGhostNotes);
    world.add(stave);
  }

  Future<void> buildAllElements() async {
    world.add(tick);
    tick.position = Vector2(250, -90);
    currentNoteData = gameController.currentNote.value;
    bouncyBall.position = positionManager.bouncyBallPosition();
    world.add(bouncyBall);
    bouncyBall.isVisible = stateManager.showBall;
  }

  void queueNewNote(NoteData newNoteData) {
    nextNote = newNoteData;
    noteChangeQueued = true;
  }

  Future<void> changeNote() async {
    if (loadComplete && noteChangeQueued) {
      currentNoteData = nextNote;
      stave.changeNote(currentNoteData, 0.5);
      noteChangeQueued = false;
    }
  }

  void updateBallPosition(double dt) {
    if (stateManager.showBall) {
      gameTime += dt; // todo extract this timing shit.
      while (gameTime > beatSeconds) {
        gameTime -= beatSeconds;
      }
      if (gameTime < 0) {
        gameTime = 0;
      }
      bouncyBall.positionBall(gameTime / beatSeconds);
    }
  }

  @override
  void update(double dt) {
    changeNote();
    updateBallPosition(dt);
    super.update(dt);
  }

  @override
  Color backgroundColor() => Colors.white;
}

class GameStateManager {
  bool showGhostNotes = true;
  bool showBall = false;
}

class PositionManager {
  //final KeySignature keySignature;
  final GameStateManager stateManager;
  final double staffWidth = 280;
  final double ghostNoteExtension = 130;
  PositionManager(this.stateManager);

  Vector2 bouncyBallPosition() {
    return Vector2(120, -70);
  }
}
