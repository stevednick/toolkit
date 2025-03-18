import 'package:flutter/material.dart';

class SimpleGameScoreManager {
  ValueNotifier<double> score = ValueNotifier(0);

  void addScore(double amountToAdd) {
    score.value += amountToAdd;
  }

  void resetScore() {
    score.value = 0;
  }
}