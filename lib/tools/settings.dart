import 'package:toolkit/tools/shared_prefs_manager.dart';

class Settings {

  static String ghostNoteString = "ghost_notes_key";
  static String tempoKey = "tempo_key";

  static Future<bool> getSetting(String key, {bool initialValue = true}) async {
    return await SharedPrefsManager.load<bool>(key) ?? initialValue;
  }

  static Future<void> saveSetting(String key, bool newValue) async {
    await SharedPrefsManager.save<bool>(key, newValue);
  }
}
