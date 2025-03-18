import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/simple_game/scoring/simple_game_score_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/score_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/timer_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/timing/simple_game_timing_manager.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum GameState { listening, correctNoteHeard, fadingIn }

class SimpleGameController {
  late SimpleGameStateManager gameStateManager;
  late TimerStateManager timerStateManager;

  ValueNotifier<NoteData> currentNote =
      ValueNotifier<NoteData>(NoteData.placeholderValue);
  final NoteGenerator noteGenerator = NoteGenerator();
  late NoteChecker noteChecker;
  late Player player;
  final String playerKey = "SimpleTestKey";
  //ValueNotifier<String> gameText = ValueNotifier("Set your range.");
  //ValueNotifier<String> feedbackText = ValueNotifier("");
  Duration waitDuration = const Duration(milliseconds: 500);

  bool showTempo = true;

  late WidgetRef ref;

  bool bigJumpsMode = false;
  Function() triggerTick;

  SimpleGameController(this.triggerTick, this.ref) {
    WakelockPlus.enable();
    gameStateManager = ref.read(simpleGameStateProvider.notifier);
    timerStateManager = ref.read(timerStateProvider.notifier);
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
    // Delay the state update after the frame is rendered
    if (!ref.read(simpleGameStateProvider).isTimeTrialMode) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timerStateManager.decrementTime(dt);
      if (ref.read(timerStateProvider).timeRemaining <= 0) {
        gameStateManager.setGameMode(GameMode.waitingToStart);
        gameStateManager.setGameText("Game Over");
        noteChecker.dispose();
      }
    });
  }

  void correctNoteHeard() {
    if (ref.read(simpleGameStateProvider).gameState == GameState.listening) {
      changeNote();
      triggerTick();
      _incrementScore();
      _waitAndChangeNote();
      gameStateManager.setGameState(GameState.correctNoteHeard);
      timerStateManager.addTime(2);
      
    }
  }

  void startButtonPressed() {
    if (ref.read(simpleGameStateProvider).gameMode == GameMode.waitingToStart) {
      gameStateManager.reset();
      timerStateManager.resetTime();
      gameStateManager.setGameText("Play the note.");
      noteChecker.initialize();
      gameStateManager.setGameMode(GameMode.running);
      //changeNote();
    } else if (ref.read(simpleGameStateProvider).gameMode == GameMode.running) {
      gameStateManager.setGameMode(GameMode.waitingToStart);
      gameStateManager.setGameText("Set your range.");
      noteChecker.dispose();
    }
  }

  void sceneLoaded() {
    changeNote();
  }

  void _waitAndChangeNote() {
    Timer(waitDuration, () {
      gameStateManager.setGameState(GameState.fadingIn);
      Timer(waitDuration, () {
        gameStateManager.setGameState(GameState.listening);
      });
    });
  }

  void changeNote() {
    player.currentNote.value =
        noteGenerator.randomNoteFromRange(player, bigJumps: bigJumpsMode);
    noteChecker.noteToCheck = player.getNoteToCheck();
    currentNote.value = player.currentNote.value;
  }

  void _incrementScore() {
    ref.read(simpleGameScoreProvider.notifier).incrementScore();
  }

  void dispose() {
    WakelockPlus.disable();
    noteChecker.dispose();
  }

  NoteData getNoteDataFromPlayer() {
    return player.currentNote.value;
  }
}
