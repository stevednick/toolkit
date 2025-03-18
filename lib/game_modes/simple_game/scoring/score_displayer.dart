class ScoreDisplayer {
  String displayScore(double score) {
    return 'Score: ${formatScore(score)}';
  }

  String formatScore(double score) {
    return score
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
