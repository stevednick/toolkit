import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/simple_game/scoring/score_displayer.dart';
import 'package:toolkit/game_modes/simple_game/scoring/simple_game_score_manager.dart';

class SimpleGameScoreText extends StatelessWidget {
  SimpleGameScoreText({super.key, required this.scoreManager});
  final SimpleGameScoreManager scoreManager;
  late ScoreDisplayer displayer = ScoreDisplayer();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: scoreManager.score,
      builder: (context, score, child) {
        return Text(
          displayer.displayScore(score),
          style: const TextStyle(fontSize: 30, color: Colors.black),
        );
      },
    );
  }
}
