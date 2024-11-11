import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
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

  //ValueNotifier<List<NoteData>> notes = ValueNotifier<List<NoteData>>([NoteData(name: "", pos: 0, accidental: Accidental.flat, clef: Clef.bass(), noteNum: 0), NoteData(name: "", pos: 0, accidental: Accidental.flat, clef: Clef.bass(), noteNum: 0)]);
  int countDownCounter = 3;
  ValueNotifier<String> countDownText = ValueNotifier<String>("");
  ValueNotifier<String> gameText = ValueNotifier("Set your range.");
  ValueNotifier<int> currentPlayer = ValueNotifier<int>(1);
  final NoteGenerator noteGenerator = NoteGenerator();
  late NoteChecker noteChecker;
  // late Player leftPlayer, rightPlayer;
  late List<Player> players;
  String leftPlayerKey = "leftTestKey", rightPlayerKey = "rightTestKey";
  late Timer gameTimer;

  Duration waitDuration = const Duration(seconds: 1);
  GameState _state = GameState.listening;
  ValueNotifier<GameMode> mode = ValueNotifier(GameMode.waitingToStart);
  ValueNotifier<int> currentBeat = ValueNotifier(0);
  ValueNotifier<String> leftFeedbackText = ValueNotifier("");
  ValueNotifier<String> rightFeedbackText = ValueNotifier("");
  String buttonText = "Start";
  int gameBPM = 40;
  

  PongController() {
    WakelockPlus.enable();
    setPlayers();
    noteChecker = NoteChecker(
      correctNoteHeard, getNoteDifference
    );
    
  }

  void startButtonPressed() {
    if (mode.value == GameMode.waitingToStart) {
      startListener();
      changeNote(1);
      changeNote(0);
      startCountdown();
    } else if (mode.value == GameMode.running) {
      endGame();
    } else if (mode.value == GameMode.finished) {
      currentPlayer.value = 0;
      players[0].score.value = 0;
      players[1].score.value = 0;
      changeNote(1);
      changeNote(0);
      startCountdown();
    }
  }

  void startGame() {
    //if (!gameRunning) nextGo();
    //currentPlayer.value ^= 1;
    //startListener();
    buttonText = "Finish";
    currentPlayer.value = 0;
    currentBeat.value = 1;
    _state = GameState.listening;
    double gameMillis = 60000/gameBPM;
    gameTimer = Timer.periodic(Duration(milliseconds: gameMillis.toInt()), (timer) {
      nextBeat();
    });
    mode.value = GameMode.running;
    gameRunning = true;
  }

  void pauseGame() {
    mode.value = GameMode.paused;
    gameTimer.cancel();
  }

  void endGame() {
    gameText.value = "Set your range!";
    buttonText = "Start";
    mode.value = GameMode.finished;
    gameTimer.cancel();
    stopListener();
  }

  void startCountdown() {
    
    gameText.value = "Player 1 Get Ready!";
    buttonText = "Wait";
    mode.value = GameMode.countingDown;
    countDownCounter = 3;
    countDownText.value = "3";
    double gameMillis = 60000/gameBPM;
    print("Timer Should Starts");
    Timer.periodic(Duration(milliseconds: gameMillis.toInt()), (timer) {
      print("Timer Starts");
      decreaseCountdown();
      if (countDownCounter == 0) timer.cancel();
    });
  }

  void decreaseCountdown() {
    countDownCounter--;
    if (countDownCounter > 0) {
      countDownText.value = countDownCounter.toString();
    } else {
      countDownText.value = "Go!";
      gameText.value = "Player 1";
      startGame();
      Timer.periodic(const Duration(seconds: 3), (timer) {
        countDownText.value = "";
        timer.cancel();
      });
    }
  }

  void getNoteDifference(int difference){
    print("Difference $difference, side ${currentPlayer.value}");
    noteFeedback(difference, currentPlayer.value);
  }

  void noteFeedback(int difference, int side){
    String t = "";
    if (difference > 0){
      t = "Too High";
    } else if (difference < 0 && difference > -1000){
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

  void stopListener(){
    noteChecker.dispose();
  }


  void correctNoteHeard() {
    if (_state == GameState.listening) {
      _incrementScore();
      //_waitAndChangeNote(currentPlayer.value);
      _state = GameState.correctNoteHeard;
    }
  }

  void nextBeat() {
    currentBeat.value++;
    if (currentBeat.value >= 5) currentBeat.value = 1;
    if (currentBeat.value == 1 || currentBeat.value == 3) nextGo();
  }

  void nextGo() {
    changeNote(currentPlayer.value);
    
    currentPlayer.value ^= 1;
    gameText.value = "Player ${currentPlayer.value + 1}";
    noteChecker.noteToCheck = players[currentPlayer.value].getNoteToCheck();
    _state = GameState.listening;
  }

  void changeNote(player) {
    players[player].currentNote.value = noteGenerator.randomNoteFromRange(players[player]); // There's definitely a more elegant way to set this up...
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
