import 'package:flutter/material.dart';

class SimpleGameTimingManager {
  ValueNotifier<double> currentTime = ValueNotifier(20);
  final double _gameDuration = 20;

  bool updateTimeAndCheckIfFinished(double time) {
    currentTime.value -= time;
    return currentTime.value <= 0;
  }

  void addTime(double time) {
    currentTime.value += time;
  }

  void resetTime() {
    currentTime.value = _gameDuration;
  }
}