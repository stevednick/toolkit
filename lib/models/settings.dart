import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  late bool ghostNotesOn;
  String ghostNoteString = "ghost_notes_key";
  String tempoKey = "tempo_key";
  

  Future<bool> getGhostNotesOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ghostNoteString) ?? true;
  }

  Future<void> saveGhostNotesOn(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ghostNoteString, newValue);
  }

  Future<bool> getTempoOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tempoKey) ?? true;
  }

  Future<void> saveTempoOn(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tempoKey, newValue);
  }
}
