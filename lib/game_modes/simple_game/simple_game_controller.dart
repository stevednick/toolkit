import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/accidental.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/tools/note_checker.dart';
import 'package:toolkit/tools/note_generator.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum GameState { listening, changingNote }

class SimpleGameController {
  ValueNotifier<NoteData> currentNote = ValueNotifier<NoteData>(NoteData.placeholderValue);
  final NoteGenerator noteGenerator = NoteGenerator();
  late NoteChecker noteChecker;
  late Player player;
  final String playerKey = "SimpleTestKey";
  GameMode gameMode = GameMode.waitingToStart;
  // ValueNotifier<String> countDownText = ValueNotifier("");
  ValueNotifier<String> gameText = ValueNotifier("Set your range.");
  ValueNotifier<String> feedbackText = ValueNotifier("");
  Duration waitDuration = const Duration(seconds: 1);
  GameState _state = GameState.listening;

  bool ghostNotesOn = true;

  SimpleGameController() {
    WakelockPlus.enable();
    player = Player(playerKey: playerKey);
    noteChecker = NoteChecker(
      correctNoteHeard,
      noteFeedback,
    );
    //changeNote();
  }

  void noteFeedback(int difference) {
    if (difference > 0) {
      feedbackText.value = "Too High";
    } else if (difference < 0 && difference > -1000) {
      feedbackText.value = "Too Low";
    } else {
      feedbackText.value = "";
    }
  }

  void correctNoteHeard() {
    if (_state == GameState.listening) {
      _incrementScore();
      _waitAndChangeNote();
      _state = GameState.changingNote;
    }
  }

  void startButtonPressed() {
    if (gameMode == GameMode.waitingToStart) {
      player.score.value = 0;
      gameText.value = "Play the note.";
      noteChecker.initialize();
      gameMode = GameMode.running;
      changeNote();
    } else if (gameMode == GameMode.running) {
      gameMode = GameMode.waitingToStart;
      gameText.value = "Set your range.";
      noteChecker.dispose();
    }
  }

  void _waitAndChangeNote() {
    changeNote();
    Timer(waitDuration, () {
      _state = GameState.listening;
    });
  }

  void changeNote() {
    player.currentNote.value = noteGenerator.randomNoteFromRange(
        player);
    noteChecker.noteToCheck = player.getNoteToCheck();
    print(
        "noteChecker: ${noteChecker.noteToCheck}, curentNote ${currentNote.value.noteNum}");
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
