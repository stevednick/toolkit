import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';

import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state.dart';
import 'package:toolkit/models/game_mode.dart';

class SimpleGameStateManager extends StateNotifier<SimpleGameState> {
  SimpleGameStateManager() : super(SimpleGameState());

  void reset(){
    state = state.copyWith(gameMode: GameMode.waitingToStart, gameText: "Set your range.", gameState: GameState.listening);
  }

  void setGameMode(GameMode gameMode) {
    state = state.copyWith(gameMode: gameMode);
  }

  void setGameState(GameState gameState) {
    state = state.copyWith(gameState: gameState);
  }

  void setGameText(String gameText) {
    state = state.copyWith(gameText: gameText);
  }

  void setIsTimeTrialMode(bool isTimeTrialMode) {
    print("Setting isTimeTrialMode to $isTimeTrialMode");
    state = state.copyWith(isTimeTrialMode: isTimeTrialMode);
  }
}

final simpleGameStateProvider =
    StateNotifierProvider<SimpleGameStateManager, SimpleGameState>((ref) {
  return SimpleGameStateManager();
});