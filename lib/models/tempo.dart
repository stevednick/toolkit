import 'package:shared_preferences/shared_preferences.dart';

class Tempo{
    final List<int> tempos = [
    40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 63, 66, 69, 72, 76, 80, 84, 88, 92, 96, 
    100, 104, 108, 112, 116, 120, 126, 132, 138, 144, 152, 160, 168, 176,
  ];

  Future<double> loadBeatSeconds() async {
    int tempo = await loadSavedTempo();
    return 60/tempo;
  }

  Future<int> loadSavedTempo() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('savedTempo') ?? 72;
  }

  Future<void> saveTempo(int tempo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('savedTempo', tempo);
  }
}