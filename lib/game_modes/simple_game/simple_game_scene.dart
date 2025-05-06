import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/components/ball/bouncy_ball.dart';
import 'package:toolkit/components/components.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';

class SimpleGameScene extends FlameGame {
  late SimpleGameStateManager gameStateManager;
  final SimpleGameController gameController;  // can this be removed altogether?
  final GameStateManager stateManager = GameStateManager();

  final NoteGenerator noteGenerator = NoteGenerator();

  bool loadComplete = false;

  NoteData currentNoteData = NoteData.placeholderValue;  // Tgis needs to move to state Manager
  late NoteData nextNote; // ?
  bool noteChangeQueued = false; // ?

  late Stave stave; // Stays

  double width = 1000;
  double screenWidthRatio = 3;

  late PositionManager positionManager; // ?

  Tick tick = Tick();

  final BouncyBall bouncyBall = BouncyBall();
  Tempo tempo = Tempo(key: 'simple_game_tempo'); // Move
  double beatSeconds = 1000; // Move
  double gameTime = 0; // Move

  bool fadeClef = false;
  bool initialNoteLoaded = false;

  WidgetRef ref;

  SimpleGameScene(
    this.gameController,
    this.ref,
  ) {
    gameStateManager = ref.read(simpleGameStateProvider.notifier);
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    gameController.player.currentNote.addListener(() { // Extract
      if (!initialNoteLoaded) {
        queueNewNote(gameController.player.currentNote.value);
        initialNoteLoaded = true;
      }
    });

    stateManager.showGhostNotes = //  todo Move loading to state manager?
        await Settings.getSetting(Settings.ghostNoteString);
    
    positionManager = PositionManager(stateManager);
    currentNoteData = gameController.currentNote.value;
    gameController.noteChecker.noteNotifier.addListener(() { // Move
      if (stateManager.showGhostNotes) {
        stave.showGhostNote(gameController.noteChecker.noteNotifier.value,
            gameController.currentNote.value.noteNum);
      }
    });
    camera.viewfinder.anchor = Anchor.center;
    loadComplete = true;
    gameController.changeNote(); // Move
    beatSeconds = await tempo.loadBeatSeconds(); // Move
    stave = Stave(gameController.player, width / screenWidthRatio,
        showGhostNotes: stateManager.showGhostNotes);
    world.add(stave);
    await setUpBall();
    setUpTick();
  }

  Future<void> setUpBall() async {
    stateManager.showBall = await Settings.getSetting(Settings.tempoKey);
    if (ref.watch(simpleGameStateProvider).isTimeTrialMode){
      stateManager.showBall = false;
    }
    world.add(bouncyBall);
    bouncyBall.isVisible = stateManager.showBall;
    bouncyBall.position = stave.positionManager.ballPosition();
    bouncyBall.scale = stave.positionManager.scaleMultiplier();
  }

  void setUpTick(){
    world.add(tick);
    tick.position = Vector2(250, -90);
  }

  @override
  Future<void> onMount() async {
    super.onMount();
    // Listen for changes in the game state, but only trigger when necessary
    ref.listenManual<SimpleGameState>(  // Is there a better way to do this?
      simpleGameStateProvider,
      (previous, next) {
        if (previous?.gameState != next.gameState) {
          if (next.gameState != GameState.correctNoteHeard) return;
          queueNewNote(gameController.player.currentNote.value);
          tick.showTick(); 
        }
      },
    );
  }

  void queueNewNote(NoteData newNoteData) { // Move
    nextNote = newNoteData;
    noteChangeQueued = true;
  }

  // Extract This Stuff, thought required! 
  Future<void> changeNote() async { // Move
    if (loadComplete && noteChangeQueued) {
      currentNoteData = nextNote;
      stave.changeNote(currentNoteData, 0.5);
      noteChangeQueued = false;
    }
  }

  // Extract This! 
  void updateBallPosition(double dt) { // ??
    if (stateManager.showBall) {
      gameTime += dt; // todo extract this timing shit.
      while (gameTime > beatSeconds) {
        gameTime -= beatSeconds;
        bouncyBall.bounce();
      }
      if (gameTime < 0) {
        gameTime = 0;
      }
      bouncyBall.positionBall(gameTime / beatSeconds);
    }
  }

  @override
  void update(double dt) {  // Updates useful, how/where to share?
    gameController.update(dt); 
    changeNote(); // Move
    updateBallPosition(dt);
    super.update(dt);
  }

  @override
  Color backgroundColor() => Colors.white;
}

class GameStateManager { // No longer needed, extract/delete
  bool showGhostNotes = true;
  bool showBall = false;
}

class PositionManager { // Hmm
  //final KeySignature keySignature;
  final GameStateManager stateManager;
  final double staffWidth = 280;
  final double ghostNoteExtension = 130;
  PositionManager(this.stateManager);

  Vector2 bouncyBallPosition() {
    return Vector2(130, -50);
  }
}
