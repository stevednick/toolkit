import 'package:shared_preferences/shared_preferences.dart';

class SingleGameHighScoresManager {
  static final SingleGameHighScoresManager _instance =
      SingleGameHighScoresManager._internal();

  factory SingleGameHighScoresManager() => _instance;

  SingleGameHighScoresManager._internal();

  int bestNotes = 0;
  double bestScore = 0.0;

  final String bestNotesString = "single_player_best_notes";
  final String bestScoreString = "single_player_best_score";

  final String difficultyScorePrefix = "single_player_difficulty_score_";
  final String difficultyNotesPrefix = "single_player_difficulty_notes_";

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      bestNotes = _prefs?.getInt(bestNotesString) ?? 0;
      bestScore = _prefs?.getDouble(bestScoreString) ?? 0.0;
      _isInitialized = true;
    }
  }

  Future<double> getHighScore(double difficultyLevel) async {
    await init();
    //String key = "highScoreKey";
    return _prefs?.getDouble(bestScoreString) ?? 0.0;
  }

  Future<int> getBestNotes(double difficultyLevel) async {
    await init();
    return _prefs?.getInt(bestNotesString) ?? 0;
  }

Future<void> saveHighScore(double difficultyLevel, double score) async {
  await init();

  double storedBestScore = _prefs?.getDouble(bestScoreString) ?? 0.0; // Load latest saved score
  print("Score: $score, Stored Best Score: $storedBestScore");

  if (score > storedBestScore) {  // Compare against actual stored value
    bestScore = score;
    await _prefs?.setDouble(bestScoreString, score);
    print("New High Score Saved!");
  } else {
    print("Score was not high enough to update.");
  }
}
Future<void> saveBestNotes(double difficultyLevel, int notes) async {
  await init();

  int storedBestNotes = _prefs?.getInt(bestNotesString) ?? 0; // Load latest saved value
  print("Notes: $notes, Stored Best Notes: $storedBestNotes");

  if (notes > storedBestNotes) {  // Compare against actual stored value
    bestNotes = notes;
    await _prefs?.setInt(bestNotesString, notes);
    print("New Best Notes Saved!");
  } else {
    print("Notes count was not high enough to update.");
  }
}


  Future<void> resetScores() async {
    await init();
    bestNotes = 0;
    bestScore = 0.0;
    await _prefs?.setInt(bestNotesString, 0);
    await _prefs?.setDouble(bestScoreString, 0.0);
  }
}
