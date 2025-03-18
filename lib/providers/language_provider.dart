import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends StateNotifier<String> {
  static const String _languageKey = 'selected_language';
  late SharedPreferences _prefs;

  String get currentLanguage => _languageKey;

  final Map<String, Map<String, String>> localizedValues = {
    'en': {
      'Cb': 'C♭',
      'C': 'C',
      'C#': 'C#',
      'Db': 'D♭',
      'D': 'D',
      'Eb': 'E♭',
      'E': 'E',
      'F': 'F',
      'F#': 'F#',
      'Gb': 'G♭',
      'G': 'G',
      'Ab': 'A♭',
      'A': 'A',
      'Bb': 'B♭',
      'B': 'B',
      'Major': 'major',
    },
    'de': {
      'Cb': 'Ces',
      'C': 'C',
      'C#': 'Cis',
      'Db': 'Des',
      'D': 'D',
      'Eb': 'Es',
      'E': 'E',
      'F': 'F',
      'F#': 'Fis',
      'Gb': 'Ges',
      'G': 'G',
      'Ab': 'As',
      'A': 'A',
      'Bb': 'Bes',
      'B': 'B',
      'Major': 'Dur',
    },
    'it': {
      'Cb': 'Do♭',
      'C': 'Do',
      'C#': 'Do#',
      'Db': 'Re♭',
      'D': 'Re',
      'Eb': 'Mi♭',
      'E': 'Mi',
      'F': 'Fa',
      'F#': 'Fa#',
      'Gb': 'Sol♭',
      'G': 'Sol',
      'Ab': 'La♭',
      'A': 'La',
      'Bb': 'Si♭',
      'B': 'Si',
      'Major': 'maggiore'
    },
  };

  LanguageProvider() : super('en') {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLanguage = _prefs.getString(_languageKey) ?? 'en';
    state = savedLanguage; // Triggers UI rebuild
  }

  void changeLanguage(String newLanguage) {
    if (localizedValues.containsKey(newLanguage)) {
      print('Changing language to $newLanguage');
      state = newLanguage; // This updates the UI
      _prefs.setString(_languageKey, newLanguage);
    }
  }

  String translate(String key) {
    return localizedValues[state]?[key] ?? key;
  }
}


final languageProvider = StateNotifierProvider<LanguageProvider, String>(
  (ref) => LanguageProvider(),
);

