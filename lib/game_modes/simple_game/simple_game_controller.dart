import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toolkit/game_modes/simple_game/scoring/simple_game_score_manager.dart';
import 'package:toolkit/game_modes/simple_game/timing/simple_game_timing_manager.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum GameState { listening, correctNoteHeard, fadingIn}

class SimpleGameController {
  ValueNotifier<NoteData> currentNote = ValueNotifier<NoteData>(NoteData.placeholderValue);
  final NoteGenerator noteGenerator = NoteGenerator();
  late NoteChecker noteChecker;
  late Player player;
  final String playerKey = "SimpleTestKey";
  ValueNotifier<GameMode> gameMode = ValueNotifier(GameMode.waitingToStart);
  ValueNotifier<String> gameText = ValueNotifier("Set your range.");
  ValueNotifier<String> feedbackText = ValueNotifier("");
  Duration waitDuration = const Duration(milliseconds: 500);
  ValueNotifier<GameState> state = ValueNotifier(GameState.listening);
  bool showTempo = true;

  bool timeTrialMode = true;

  final SimpleGameScoreManager scoreManager = SimpleGameScoreManager();
  final SimpleGameTimingManager timingManager = SimpleGameTimingManager();

  bool bigJumpsMode = false;
  Function() triggerTick;

  SimpleGameController(this.triggerTick) {
    WakelockPlus.enable();
    player = Player(playerKey: playerKey);
    noteChecker = NoteChecker(
      correctNoteHeard,
      noteFeedback,
    );
  }

  void noteFeedback(int difference) {
    //
  }

  void update(double dt) {
    if (!timeTrialMode){
      return;
    }
    if (timingManager.updateTimeAndCheckIfFinished(dt)){
      gameMode.value = GameMode.waitingToStart;
      gameText.value = "Game Over";
      noteChecker.dispose();
    }
  }

  void correctNoteHeard() {
    if (state.value == GameState.listening) {
      changeNote();
      triggerTick();
      _incrementScore();
      _waitAndChangeNote();
      state.value = GameState.correctNoteHeard;
    }
  }

  void startButtonPressed() {
    if (gameMode.value == GameMode.waitingToStart) {
      
      scoreManager.resetScore();
      gameText.value = "Play the note.";
      noteChecker.initialize();
      gameMode.value = GameMode.running;
      //changeNote();
    } else if (gameMode.value == GameMode.running) {
      gameMode.value = GameMode.waitingToStart;
      gameText.value = "Set your range.";
      noteChecker.dispose();
    }
  }

  void sceneLoaded(){
    changeNote();
  }

  void _waitAndChangeNote() {

    Timer(waitDuration, () {

      state.value = GameState.fadingIn;
      Timer(waitDuration, () {
        state.value = GameState.listening;
      });
    });
  }


  void changeNote() {
    player.currentNote.value = noteGenerator.randomNoteFromRange(
        player, bigJumps: bigJumpsMode);
    noteChecker.noteToCheck = player.getNoteToCheck();
  }

  void _incrementScore() {
    scoreManager.addScore(1);
  }

  void dispose() {
    WakelockPlus.disable();
    noteChecker.dispose();
  }

  NoteData getNoteDataFromPlayer() {
    return player.currentNote.value;
  }
}
