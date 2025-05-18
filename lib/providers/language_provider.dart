import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/tools/shared_prefs_manager.dart';

class LanguageProvider extends StateNotifier<String> {
  static const String _languageKey = 'selected_language';


  String get currentLanguage => _languageKey;

  final Map<String, Map<String, String>> localizedValues = {
    'en': {
      'C Alto': 'C Alto',
      'Bb Alto': 'B♭ Alto',
      'A Alto': 'A Alto',
      'B Basso': 'B Basso',
      'Bb Basso': 'B♭ Basso',
      'A Basso': 'A Basso',
      'Ab Basso': 'A♭ Basso',
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
      'C Alto': 'C Alto',
      'Bb Alto': 'Bes Alto',
      'A Alto': 'A Alto',
      'B Basso': 'B Basso',
      'Bb Basso': 'Bes Basso',
      'A Basso': 'A Basso',
      'Ab Basso': 'As Basso',
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
      'C Alto': 'Do Alto',
      'Bb Alto': 'Si♭ Alto',
      'A Alto': 'La Alto',
      'B Basso': 'Si Basso',
      'Bb Basso': 'Si♭ Basso',
      'A Basso': 'La Basso',
      'Ab Basso': 'La♭ Basso',
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
    final savedLanguage = await SharedPrefsManager.load<String>(_languageKey) ?? 'en';
    state = savedLanguage; // Triggers UI rebuild
  }

  Future<void> changeLanguage(String newLanguage) async {
    if (localizedValues.containsKey(newLanguage)) {
      print('Changing language to $newLanguage');
      state = newLanguage; // This updates the UI
      await SharedPrefsManager.save<String>(_languageKey, newLanguage);
    }
  }

  String translate(String key) {
    return localizedValues[state]?[key] ?? key;
  }
}

final languageProvider = StateNotifierProvider<LanguageProvider, String>(
  (ref) => LanguageProvider(),
);

