import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/tools/shared_prefs_manager.dart';

class Tempo{

    final List<int> tempos = [
    40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 63, 66, 69, 72, 76, 80, 84, 88, 92, 96, 
    100, 104, 108, 112, 116, 120, 126, 132, 138, 144, 152, 160, 168, 176,
  ];

  final String key;

  Tempo({required this.key});

  Future<double> loadBeatSeconds() async {
    int tempo = await loadSavedTempo();
    return 60/tempo;
  }

  Future<int> loadSavedTempo() async {
    int tempo = await SharedPrefsManager.load<int>(key) ?? 72;
    return tempo;
  }

  Future<void> saveTempo(int tempo) async {
    await SharedPrefsManager.save<int>(key, tempo);

  }
}