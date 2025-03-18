import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoreState{
  final double score;

  ScoreState({
    this.score = 0,
  });

  ScoreState copyWith({
    double? score,
  }) {
    return ScoreState(
      score: score ?? this.score,
    );
  }
}

class ScoreStateManager extends StateNotifier<ScoreState> {
  ScoreStateManager() : super(ScoreState());

  void reset(){
    state = state.copyWith(score: 0);
  }

  void incrementScore() {
    state = state.copyWith(score: state.score + 1);
  }

  void increaseScoreBy(int amount) {
    state = state.copyWith(score: state.score + amount);
  }

}

final simpleGameScoreProvider =
    StateNotifierProvider<ScoreStateManager, ScoreState>((ref) {
  return ScoreStateManager();
});