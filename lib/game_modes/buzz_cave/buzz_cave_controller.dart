import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toolkit/tools/tools.dart';
import 'dart:math';

class BuzzCaveController {
  PitchGetter pitchGetter = PitchGetter();
  NoteGetter noteGetter = NoteGetter();
  ValueNotifier<double> heardPitch = ValueNotifier(0);
  ValueNotifier<double> heardNote = ValueNotifier(0.0);
  ValueNotifier<int> lives = ValueNotifier(1);

  double middleNote = 0; // Todo: integrate these into the functionality. Pass ball position to scene from here? Or scene uses these values for its own calculations?
  double range = 1;
  double ballSize = 1;

  double middlePitch = 340;
  double zoomModifier = 10;
  int spawnPeriodMillis = 1500;
  ValueNotifier<int> enemiesSpawned = ValueNotifier(0);
  ValueNotifier<int> enemiesHit = ValueNotifier(0);

  ValueNotifier<BuzzGameState> state = ValueNotifier(BuzzGameState.waitingToStart);
  String startButtonText = "Start";

  BuzzCaveController() {
    pitchGetter.pitchNotifier.addListener(_onPitchDetected);
    Timer _ =
          Timer.periodic(Duration(milliseconds: spawnPeriodMillis), (timer) {
      spawnEnemy();
    });
  }

  void startPressed() {
    if (state.value == BuzzGameState.waitingToStart) {
      pitchGetter.startListening();
      state.value = BuzzGameState.running;
      startButtonText = "Pause";
    } else {
      pitchGetter.stopListening();
      state.value = BuzzGameState.waitingToStart;
      startButtonText = "Start";
    }
  }

  double getBallPosition(){

    return mapValueToPosition(heardNote.value, -range, range, -2, 2, 1);
    //return (heardNote.value - middleNote)/range;
  }

  double mapValueToPosition(double value, double minValue, double maxValue, double minY, double maxY, double edgeBuffer) {
    if (value < minValue) {
      // Value is below the range, slow down movement
      double distanceOutside = minValue - value;
      double scaledPosition = minY - (edgeBuffer * log(1 + distanceOutside));  // Inverse exponential decay
      return max(minY, scaledPosition);  // Ensure the ball stays on the screen
    } else if (value > maxValue) {
      // Value is above the range, slow down movement
      double distanceOutside = value - maxValue;
      double scaledPosition = maxY + (edgeBuffer * log(1 + distanceOutside));  // Inverse exponential decay
      return min(maxY, scaledPosition);  // Ensure the ball stays on the screen
    } else {
      // Value is inside the range, map linearly
      return minY + ((value - minValue) / (maxValue - minValue)) * (maxY - minY);
    }
  }

  void spawnEnemy() {
    if (state.value == BuzzGameState.running){
      enemiesSpawned.value += 1;
    }
  }

  void enemyHit() {
    lives.value -= 1;
    if (lives.value == 0){
      gameOver();
    }
  }

  void pickMeUpHit() {
    enemiesHit.value += 1;
  }

  void gameOver(){
    state.value = BuzzGameState.gameOver;
  }



  void _onPitchDetected() {
    heardPitch.value = pitchGetter.pitchNotifier.value;
    heardNote.value = noteGetter.getNoteWithTuningFromFrequency(pitchGetter.pitchNotifier.value);
  }

  void dispose() {
    pitchGetter.stopListening();
  }
}

enum BuzzGameState { // TODO: Add paused mode. 
  waitingToStart,
  running,
  paused,
  gameOver,
}
