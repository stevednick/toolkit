import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  late SharedPreferences _prefs;
  String _currentLanguage = 'en';

  final Map<String, Map<String, String>> localizedValues = {
    'en': {
      'Cb' : 'C♭',
      'C' : 'C',
      'C#' : 'C#',
      'Db' : 'D♭',
      'D' : 'D',
      'Eb' : 'E♭',
      'E' : 'E',
      'F' : 'F',
      'F#' : 'F#',
      'Gb' : 'G♭',
      'G' : 'G',
      'Ab' : 'A♭',
      'A' : 'A',
      'Bb' : 'B♭',
      'B' : 'B',
      'Major' : 'major',
    },
    'de': {
      'Cb' : 'Ces',
      'C' : 'C',
      'C#' : 'Cis',
      'Db' : 'Des',
      'D' : 'D',
      'Eb' : 'Es',
      'E' : 'E',
      'F' : 'F',
      'F#' : 'Fis',
      'Gb' : 'Ges',
      'G' : 'G',
      'Ab' : 'As',
      'A' : 'A',
      'Bb' : 'Bes',
      'B' : 'B',
      'Major' : 'Dur',
    },
    'it': {
      'Cb' : 'Do♭',
      'C' : 'Do',
      'C#' : 'Do#',
      'Db' : 'Re♭',
      'D' : 'Re',
      'Eb' : 'Mi♭',
      'E' : 'Mi',
      'F' : 'Fa',
      'F#' : 'Fa#',
      'Gb' : 'Sol♭',
      'G' : 'Sol',
      'Ab' : 'La♭',
      'A' : 'La',
      'Bb' : 'Si♭',
      'B' : 'Si',
      'Major' : 'maggiore'
    },


    // Add more languages as needed
  };

  LocalizationProvider() {
    loadSavedLanguage();
  }

  String get currentLanguage => _currentLanguage;

  Future<void> loadSavedLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    changeLanguage(_prefs.getString(_languageKey) ?? 'en');
  }

  Future<String> getSavedLanguage() async {
    await loadSavedLanguage();
    return _currentLanguage;
  }

  void changeLanguage(String newLanguage) {
    if (localizedValues.containsKey(newLanguage)) {
      _currentLanguage = newLanguage;
      _prefs.setString(_languageKey, newLanguage);
      notifyListeners();
    }
  }

  String translate(String key) {
    return localizedValues[_currentLanguage]?[key] ?? key;
  }
}

