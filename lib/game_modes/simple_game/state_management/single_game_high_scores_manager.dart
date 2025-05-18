import 'package:toolkit/tools/shared_prefs_manager.dart';

class SingleGameHighScoresManager { // Refactoring needs to be done. 
  static final SingleGameHighScoresManager _instance =
      SingleGameHighScoresManager._internal();

  factory SingleGameHighScoresManager() => _instance;

  SingleGameHighScoresManager._internal();

  int bestNotes = 0;
  double bestScore = 0.0;

  final String bestNotesString = "single_player_best_notes";
  final String bestScoreString = "single_player_best_score";

  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      bestNotes = await SharedPrefsManager.load<int>(bestNotesString) ?? 0;
      bestScore = await SharedPrefsManager.load<double>(bestScoreString) ?? 0.0;
      _isInitialized = true;
    }
  }

Future<void> saveHighScore(double score) async { // Todo look at and refine? Working by coincidence? 
  await init();

  double storedBestScore = await SharedPrefsManager.load<double>(bestScoreString) ?? 0.0; // Load latest saved score
  print("Score: $score, Stored Best Score: $storedBestScore");

  if (score > storedBestScore) {  // Compare against actual stored value
    bestScore = score;
    await SharedPrefsManager.save<double>(bestScoreString, score);
    print("New High Score Saved!");
  } else {
    print("Score was not high enough to update.");
  }
}
Future<void> saveBestNotes(int notes) async {
  await init();

  int storedBestNotes = await SharedPrefsManager.load<int>(bestNotesString) ?? 0;
  print("Notes: $notes, Stored Best Notes: $storedBestNotes");

  if (notes > storedBestNotes) {  // Compare against actual stored value
    bestNotes = notes;
    await SharedPrefsManager.save<int>(bestNotesString, notes);
    print("New Best Notes Saved!");
  } else {
    print("Notes count was not high enough to update.");
  }
}

  Future<void> resetScores() async {
    await init();
    bestNotes = 0;
    bestScore = 0.0;
    await SharedPrefsManager.save<int>(bestNotesString, 0);
    await SharedPrefsManager.save<double>(bestScoreString, 0.0);
  }
}
