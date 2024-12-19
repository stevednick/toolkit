import 'package:shared_preferences/shared_preferences.dart';

class ClefThreshold {
  late int trebleClefThreshold;
  late int bassClefThreshold;

  final String trebleKey;
  final String bassKey;

  ClefThreshold({this.trebleKey = 'trebleKey', this.bassKey = 'bassKey'}) {
    _loadValues();
  }
  Future<void> _loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trebleClefThreshold = prefs.getInt(trebleKey) ??
        -3; // Load 'top' from SharedPreferences, or default to 8
    bassClefThreshold = prefs.getInt(bassKey) ??
        3; // Load 'bottom' from SharedPreferences, or default to 0
    // print("Clef Thresholds Loaded");
    // print('$trebleClefThreshold, $bassClefThreshold');
  }

  Future<List<int>> getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trebleClefThreshold = prefs.getInt(trebleKey) ??
        -3; // Load 'top' from SharedPreferences, or default to 8
    bassClefThreshold = prefs.getInt(bassKey) ??
        3; // Load 'bottom' from SharedPreferences, or default to 0
    // print("Clef Thresholds Loaded");
    // print('$trebleClefThreshold, $bassClefThreshold');
    return [trebleClefThreshold, bassClefThreshold];
  }

  Future<void> saveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        trebleKey, trebleClefThreshold); // Save 'top' to SharedPreferences
    await prefs.setInt(
        bassKey, bassClefThreshold); // Save 'bottom' to SharedPreferences
    // print("Thresholds Saved");
    // print("$trebleClefThreshold: $bassClefThreshold");
  }

  void increment(bool isTreble, bool incrementUp) async {
    if (isTreble) {
      if (incrementUp) {
        if (trebleClefThreshold < bassClefThreshold)
          trebleClefThreshold++; // Increment 'top' if within the limit
      } else {
        trebleClefThreshold--; // Decrement 'top' if it won't cross 'bottom'
      }
    } else {
      if (incrementUp) {
        bassClefThreshold++; // Increment 'bottom' if it won't cross 'top'
      } else {
        if (bassClefThreshold > trebleClefThreshold)
          bassClefThreshold--; // Decrement 'bottom' if within the limit
      }
    }
    await saveValues(); // Save the updated values
  }
}
