import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/models/player/player.dart';

class SimpleGameState {

  final GameMode gameMode;
  final GameState gameState;

  final String gameText;

  final bool isTimeTrialMode;
  

  SimpleGameState({
    this.gameMode = GameMode.waitingToStart,
    this.gameText = "Set your range.",
    this.gameState = GameState.listening,
    this.isTimeTrialMode = false,
  });

  SimpleGameState copyWith(
      {GameMode? gameMode,
      GameState? gameState,
      String? gameText,
      bool? isTimeTrialMode}) {
    return SimpleGameState(
      gameMode: gameMode ?? this.gameMode,
      gameState: gameState ?? this.gameState,
      gameText: gameText ?? this.gameText,
      isTimeTrialMode: isTimeTrialMode ?? this.isTimeTrialMode,
    );
  }
}
