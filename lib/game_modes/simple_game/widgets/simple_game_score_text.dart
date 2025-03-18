import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/simple_game/scoring/score_displayer.dart';
import 'package:toolkit/game_modes/simple_game/scoring/simple_game_score_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/score_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';
import 'package:toolkit/models/game_mode.dart';

class SimpleGameScoreText extends ConsumerWidget {

  const SimpleGameScoreText({super.key});
  
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final ScoreDisplayer displayer = ScoreDisplayer();
    final provider = ref.read(simpleGameStateProvider);
    final scoreManager = ref.watch(simpleGameScoreProvider);
    return Positioned(
      top: 40,
      right: 40,
      child: Visibility(
        visible: provider.gameMode == GameMode.running,
        child: Text(
          "Score: ${scoreManager.score.toInt()}",
          //displayer.displayScore(provider.score.toDouble()),
          style: const TextStyle(fontSize: 30, color: Colors.black),
        ),
      ),
    );
  }

}
