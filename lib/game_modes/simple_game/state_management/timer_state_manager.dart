import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState{
  final double timeRemaining;
  static const double gameDuration = 20.0;
  final double timeIncreaseAmount;
  final double multiplacationFactor = 0.99;
  static const double countDownDuration = 3.0;
  static const double startingTimeIncreaseAmount = 2.5;
  

  TimerState({
    this.timeRemaining = gameDuration,
    this.timeIncreaseAmount = startingTimeIncreaseAmount,
  });

  TimerState copyWith({
    double? timeRemaining,
    double? timeIncreaseAmount,
  }) {
    return TimerState(
      timeRemaining: timeRemaining ?? this.timeRemaining,
      timeIncreaseAmount: timeIncreaseAmount ?? this.timeIncreaseAmount,
    );
  }
}

class TimerStateManager extends StateNotifier<TimerState> {
  TimerStateManager() : super(TimerState());

  void decrementTime(double time) {
    state = state.copyWith(timeRemaining: state.timeRemaining - time);
  }

  void addTime(double time) {
    double timeRemaining = state.timeRemaining + state.timeIncreaseAmount;
    double timeIncreaseAmount = state.timeIncreaseAmount * state.multiplacationFactor;
    state = state.copyWith(timeRemaining: timeRemaining, timeIncreaseAmount: timeIncreaseAmount);
  }

  void resetTime() {
    state = state.copyWith(timeRemaining: TimerState.gameDuration, timeIncreaseAmount: TimerState.startingTimeIncreaseAmount);
  }

  void startCountdown(){
    state = state.copyWith(timeRemaining: TimerState.countDownDuration);
  }
}

final timerStateProvider =
    StateNotifierProvider<TimerStateManager, TimerState>((ref) {
  return TimerStateManager();
});