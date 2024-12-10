import 'package:shared_preferences/shared_preferences.dart';

class Settings {

  static String ghostNoteString = "ghost_notes_key";
  static String tempoKey = "tempo_key";

  static Future<bool> getSetting(String key, {bool initialValue = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? initialValue;
  }

  static Future<void> saveSetting(String key, bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, newValue);
  }
}
