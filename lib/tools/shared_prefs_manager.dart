import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static Future<T?> load<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();

    if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == bool) {
      return prefs.getBool(key) as T?;
    } else if (T == double) {
      return prefs.getDouble(key) as T?;
    } else {
      throw UnsupportedError("Type $T is not supported");
    }
  }

  static Future<void> save<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else {
      throw UnsupportedError("Type ${value.runtimeType} is not supported");
    }
  }
}