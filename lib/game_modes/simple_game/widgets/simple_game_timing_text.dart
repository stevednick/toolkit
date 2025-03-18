import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/timer_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/timing/timing_displayer.dart';
import 'package:toolkit/models/game_mode.dart';

class SimpleGameTimingText extends ConsumerWidget {
  SimpleGameTimingText({super.key});
  final TimingDisplayer timingDisplayer = TimingDisplayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerProvider = ref.watch(timerStateProvider);
    final provider = ref.watch(simpleGameStateProvider);
    return Positioned(
      top: 80,
      right: 40,
      child: Visibility(
        visible: provider.gameMode == GameMode.running &&
            provider.isTimeTrialMode == true,
        child: Text(
          timingDisplayer.formatTime(timerProvider.timeRemaining),
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
