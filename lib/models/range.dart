import 'package:toolkit/tools/shared_prefs_manager.dart';

class Range {
  late int top;
  late int bottom;

  final String topKey;
  final String bottomKey;

  Range({this.topKey = 'topKey', this.bottomKey = 'bottomKey'}) {
    loadValues();
  }

  Future<void> loadValues() async {
    top = await SharedPrefsManager.load<int>(topKey) ?? 15;
    bottom = await SharedPrefsManager.load<int>(bottomKey) ?? 0;
  }

  Future<List<int>> getValues() async {
    await loadValues();
    return [top, bottom];
  }


  Future<void> saveValues() async {
    await SharedPrefsManager.save<int>(topKey, top);
    await SharedPrefsManager.save<int>(bottomKey, bottom);
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
