import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/tools/note_checker.dart';
import 'package:toolkit/tools/note_generator.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum GameState { listening, correctNoteHeard }

class SimpleGameController {
  ValueNotifier<NoteData> currentNote = ValueNotifier<NoteData>(NoteData.placeholderValue);
  final NoteGenerator noteGenerator = NoteGenerator();
  late NoteChecker noteChecker;
  late Player player;
  final String playerKey = "SimpleTestKey";
  ValueNotifier<GameMode> gameMode = ValueNotifier(GameMode.waitingToStart);
  // ValueNotifier<String> countDownText = ValueNotifier("");
  ValueNotifier<String> gameText = ValueNotifier("Set your range.");
  ValueNotifier<String> feedbackText = ValueNotifier("");
  Duration waitDuration = const Duration(seconds: 1);
  ValueNotifier<GameState> state = ValueNotifier(GameState.listening);
  bool showTempo = true;

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

  void correctNoteHeard() {
    if (state.value == GameState.listening) {
      triggerTick();
      _incrementScore();
      _waitAndChangeNote();
      state.value = GameState.correctNoteHeard;
    }
  }

  void startButtonPressed() {
    if (gameMode.value == GameMode.waitingToStart) {
      player.score.value = 0;
      gameText.value = "Play the note.";
      noteChecker.initialize();
      gameMode.value = GameMode.running;
      changeNote();
    } else if (gameMode.value == GameMode.running) {
      gameMode.value = GameMode.waitingToStart;
      gameText.value = "Set your range.";
      noteChecker.dispose();
    }
  }

  void _waitAndChangeNote() {
    changeNote();
    Timer(waitDuration, () {
      state.value = GameState.listening;
    });
  }

  void changeNote() {
    player.currentNote.value = noteGenerator.randomNoteFromRange(
        player, bigJumps: bigJumpsMode);
    noteChecker.noteToCheck = player.getNoteToCheck();
  }

  void _incrementScore() {
    player.score.value++;
  }

  void dispose() {
    WakelockPlus.disable();
    noteChecker.dispose();
  }

  NoteData getNoteDataFromPlayer() {
    return player.currentNote.value;
  }
}
