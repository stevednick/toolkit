import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState{
  final double timeRemaining;
  final double gameDuration = 20.0;

  TimerState({
    this.timeRemaining = 20.0,
  });

  TimerState copyWith({
    double? timeRemaining,
  }) {
    return TimerState(
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }
}

class TimerStateManager extends StateNotifier<TimerState> {
  TimerStateManager() : super(TimerState());

  void decrementTime(double time) {
    state = state.copyWith(timeRemaining: state.timeRemaining - time);
  }

  void addTime(double time) {
    state = state.copyWith(timeRemaining: state.timeRemaining + time);
  }

  void resetTime() {
    state = state.copyWith(timeRemaining: 20.0);
  }
}

final timerStateProvider =
    StateNotifierProvider<TimerStateManager, TimerState>((ref) {
  return TimerStateManager();
});