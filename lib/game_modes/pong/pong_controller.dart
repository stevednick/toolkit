import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/models/tempo.dart';
import 'package:toolkit/tools/note_checker.dart';
import 'package:toolkit/tools/note_generator.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum GameState {
  waitingToStart,
  listening,
  correctNoteHeard,
}

bool gameRunning = false;

class PongController {
  ValueNotifier<String> countDownText = ValueNotifier<String>("");
  ValueNotifier<String> gameText = ValueNotifier("Set your range.");
  ValueNotifier<int> currentPlayer = ValueNotifier<int>(1);
  final NoteGenerator noteGenerator = NoteGenerator();
  late NoteChecker noteChecker;
  // late Player leftPlayer, rightPlayer;
  late List<Player> players;
  String leftPlayerKey = "leftTestKey", rightPlayerKey = "rightTestKey";

  Duration waitDuration = const Duration(seconds: 1);
  GameState _state = GameState.listening;
  ValueNotifier<GameMode> mode = ValueNotifier(GameMode.waitingToStart);
  ValueNotifier<int> currentBeat = ValueNotifier(0);
  ValueNotifier<String> leftFeedbackText = ValueNotifier("");
  ValueNotifier<String> rightFeedbackText = ValueNotifier("");
  String buttonText = "Start";
  int gameBPM = 60;
  double time = -4;
  Tempo tempo = Tempo(key: 'pong_tempo');

  PongController() {
    WakelockPlus.enable();
    setPlayers();
    noteChecker = NoteChecker(correctNoteHeard, getNoteDifference);
  }

  void startButtonPressed() {
    if (mode.value == GameMode.waitingToStart) {
      startCountdown();
    } else if (mode.value == GameMode.running) {
      endGame();
    } else if (mode.value == GameMode.finished) {
      currentPlayer.value = 0;
      players[0].score.value = 0;
      players[1].score.value = 0;
      startCountdown();
    }
  }

  void update(double dt) {
    int prevTime = time.toInt();
    time += dt * gameBPM / 60;

    if (time > 4) time -= 4;
    if (time.toInt() != prevTime) {
      nextBeat(time.toInt());
    }
    if (mode.value == GameMode.countingDown) {
      countDownText.value = (-time + 1).toInt().toString();
      if (time >= 0) {
        startGame();
        countDownText.value = "Go!";
        Timer _ = Timer(
          const Duration(seconds: 1),
          () {
            countDownText.value = "";
          },
        );
      }
    }
  }

  void resetTime() {
    time = -3;
  }

  void startGame() {
    buttonText = "Finish";
    currentPlayer.value = 0;
    currentBeat.value = 1;
    _state = GameState.listening;

    mode.value = GameMode.running;
    gameRunning = true;
  }

  void pauseGame() {
    mode.value = GameMode.paused;
  }

  void endGame() {
    gameText.value = "Set your range!";
    buttonText = "Start";
    mode.value = GameMode.finished;
    stopListener();
  }

  void startCountdown() async {
    gameBPM = await tempo.loadSavedTempo();
    startListener();
    changeNote(1);
    changeNote(0);
    resetTime();
    gameText.value = "";
    buttonText = "Wait";
    mode.value = GameMode.countingDown;
  }

  void getNoteDifference(int difference) {
    noteFeedback(difference, currentPlayer.value);
  }

  void noteFeedback(int difference, int side) {
    String t = "";
    if (difference > 0) {
      t = "Too High";
    } else if (difference < 0 && difference > -1000) {
      t = "Too Low";
    }
    leftFeedbackText.value = side == 0 ? t : "";
    rightFeedbackText.value = side == 1 ? t : "";
  }

  Future<void> setPlayers() async {
    players = [
      Player(playerKey: leftPlayerKey),
      Player(playerKey: rightPlayerKey)
    ];
  }

  void startListener() {
    noteChecker.initialize();
  }

  void stopListener() {
    noteChecker.dispose();
  }

  void correctNoteHeard() {
    if (_state == GameState.listening) {
      _incrementScore();
      //_waitAndChangeNote(currentPlayer.value);
      _state = GameState.correctNoteHeard;
    }
  }

  void nextBeat(int beat) {
    if (mode.value == GameMode.countingDown) return;
    if (beat == 0 || beat == 2) {
      changeNote(currentPlayer.value);
      currentPlayer.value ^= 1;
      noteChecker.noteToCheck = players[currentPlayer.value].getNoteToCheck();
      _state = GameState.listening;
    }
    // if (beat == 1 || beat == 3) {
    //   changeNote(currentPlayer.value);
    // }
  }

  // void nextGo() {
  //   changeNote(currentPlayer.value);

  //   // gameText.value = "Player ${currentPlayer.value + 1}";
  //   noteChecker.noteToCheck = players[currentPlayer.value].getNoteToCheck();

  // }

  void changeNote(player) {
    players[player].currentNote.value = noteGenerator.randomNoteFromRange(
        players[
            player]); // There's definitely a more elegant way to set this up...
  }

  void _incrementScore() {
    players[currentPlayer.value].incrementScore(1);
  }

  void dispose() {
    noteChecker.dispose();
    WakelockPlus.disable();
  }

  void onScreenPressed() {
    startListener();
  }

  NoteData getNoteDataFromPlayer(side) {
    return players[side].currentNote.value;
  }
}
