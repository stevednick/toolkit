import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/tools/shared_prefs_manager.dart';

class ClefThreshold {
  late int trebleClefThreshold;
  late int bassClefThreshold;

  final String trebleKey;
  final String bassKey;

  ClefThreshold({this.trebleKey = 'trebleKey', this.bassKey = 'bassKey'}) {
    _loadValues();
  }
  Future<void> _loadValues() async {
    trebleClefThreshold = await SharedPrefsManager.load<int>(trebleKey) ?? -3;
    bassClefThreshold = await SharedPrefsManager.load<int>(bassKey) ?? 3;
  }

  Future<List<int>> getValues() async {
    _loadValues();
    return [trebleClefThreshold, bassClefThreshold];
  }

  Future<void> saveValues() async {
    await SharedPrefsManager.save<int>(trebleKey, trebleClefThreshold);
    await SharedPrefsManager.save<int>(bassKey, bassClefThreshold);
  }

  void increment(bool isTreble, bool incrementUp) async {
    if (isTreble) {
      if (incrementUp) {
        if (trebleClefThreshold < bassClefThreshold) trebleClefThreshold++; // Increment 'top' if within the limit
      } else {
        trebleClefThreshold--; // Decrement 'top' if it won't cross 'bottom'
      }
    } else {
      if (incrementUp) {
        bassClefThreshold++; // Increment 'bottom' if it won't cross 'top'
      } else {
        if (bassClefThreshold > trebleClefThreshold) bassClefThreshold--; // Decrement 'bottom' if within the limit
      }
    }
    await saveValues(); // Save the updated values
  }
}
