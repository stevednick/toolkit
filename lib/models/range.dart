import 'package:shared_preferences/shared_preferences.dart';

class Range {
  late int top;
  late int bottom;

  final String topKey;
  final String bottomKey;

  Range({this.topKey = 'topKey', this.bottomKey = 'bottomKey'}) {
    _loadValues();
  }

  Future<void> _loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    top = prefs.getInt(topKey) ?? 8;       // Load 'top' from SharedPreferences, or default to 8
    bottom = prefs.getInt(bottomKey) ?? 0; // Load 'bottom' from SharedPreferences, or default to 0
    print("Values Loaded");
    print('$top, $bottom');
  }

  Future<List<int>> getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    top = prefs.getInt(topKey) ?? 8;       // Load 'top' from SharedPreferences, or default to 8
    bottom = prefs.getInt(bottomKey) ?? 0; // Load 'bottom' from SharedPreferences, or default to 0
    print("Values Loaded");
    print('$top, $bottom');
    return [top, bottom];
  }


  Future<void> saveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(topKey, top);       // Save 'top' to SharedPreferences
    await prefs.setInt(bottomKey, bottom); // Save 'bottom' to SharedPreferences
  }

  void increment(bool isTop, bool incrementUp) async {
    if (isTop) {
      if (incrementUp) {
        if (top < 100) top++;  // Increment 'top' if within the limit
      } else {
        if (top > bottom + 1) top--;  // Decrement 'top' if it won't cross 'bottom'
      }
    } else {
      if (incrementUp) {
        if (bottom < top - 1) bottom++;  // Increment 'bottom' if it won't cross 'top'
      } else {
        if (bottom > -100) bottom--;    // Decrement 'bottom' if within the limit
      }
    }
    await saveValues();  // Save the updated values
  }
}
