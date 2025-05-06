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
    final gameState = ref.watch(simpleGameStateProvider);

    final isRunning = gameState.gameMode == GameMode.running &&
        gameState.isTimeTrialMode == true;

    final isUrgent = timerProvider.timeRemaining <= 5.0;

    return Positioned(
      top: 80,
      right: 40,
      child: Visibility(
        visible: isRunning,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 1.0,
            end: isUrgent ? 1.3 : 1.0,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Text(
                timingDisplayer.formatTime(timerProvider.timeRemaining),
                style: TextStyle(
                  fontSize: 30,
                  color: isUrgent ? Colors.red : Colors.black,
                  fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}