class TimingDisplayer {
  String formatTime(double seconds) {
    int minutes = seconds ~/ 60; // Get the whole minutes
    int remainingSeconds = (seconds % 60).toInt(); // Get the remaining seconds
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
