// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Localization State Model
// class LocalizationState {
//   final String language;
//   LocalizationState({required this.language});

//   LocalizationState copyWith({String? language}) {
//     return LocalizationState(language: language ?? this.language);
//   }
// }

// // Localization Notifier
// class LocalizationNotifier extends StateNotifier<LocalizationState> {
//   static const String _languageKey = 'selected_language';
//   late SharedPreferences _prefs;

//   final Map<String, Map<String, String>> localizedValues = {
//     'en': {
//       'Cb': 'C♭', 'C': 'C', 'C#': 'C#', 'Db': 'D♭', 'D': 'D', 'Eb': 'E♭', 
//       'E': 'E', 'F': 'F', 'F#': 'F#', 'Gb': 'G♭', 'G': 'G', 'Ab': 'A♭', 
//       'A': 'A', 'Bb': 'B♭', 'B': 'B', 'Major': 'major',
//     },
//     'de': {
//       'Cb': 'Ces', 'C': 'C', 'C#': 'Cis', 'Db': 'Des', 'D': 'D', 'Eb': 'Es', 
//       'E': 'E', 'F': 'F', 'F#': 'Fis', 'Gb': 'Ges', 'G': 'G', 'Ab': 'As', 
//       'A': 'A', 'Bb': 'Bes', 'B': 'B', 'Major': 'Dur',
//     },
//     'it': {
//       'Cb': 'Do♭', 'C': 'Do', 'C#': 'Do#', 'Db': 'Re♭', 'D': 'Re', 'Eb': 'Mi♭', 
//       'E': 'Mi', 'F': 'Fa', 'F#': 'Fa#', 'Gb': 'Sol♭', 'G': 'Sol', 'Ab': 'La♭', 
//       'A': 'La', 'Bb': 'Si♭', 'B': 'Si', 'Major': 'maggiore',
//     },
//   };

//   LocalizationNotifier() : super(LocalizationState(language: 'en')) {
//     _loadSavedLanguage();
//   }

//   Future<void> _loadSavedLanguage() async {
//     _prefs = await SharedPreferences.getInstance();
//     String savedLanguage = _prefs.getString(_languageKey) ?? 'en';
//     state = state.copyWith(language: savedLanguage);
//   }

//   void changeLanguage(String newLanguage) {
//     if (localizedValues.containsKey(newLanguage)) {
//       state = state.copyWith(language: newLanguage);
//       _prefs.setString(_languageKey, newLanguage);
//     }
//   }

//   String translate(String key) {
//     return localizedValues[state.language]?[key] ?? key;
//   }
// }

// class LocalizationProvider {
//   static const String _languageKey = 'selected_language';
//   late SharedPreferences _prefs;
//   String _currentLanguage = 'en';

//   final Map<String, Map<String, String>> localizedValues = {
//     'en': {
//       'Cb': 'C♭',
//       'C': 'C',
//       'C#': 'C#',
//       'Db': 'D♭',
//       'D': 'D',
//       'Eb': 'E♭',
//       'E': 'E',
//       'F': 'F',
//       'F#': 'F#',
//       'Gb': 'G♭',
//       'G': 'G',
//       'Ab': 'A♭',
//       'A': 'A',
//       'Bb': 'B♭',
//       'B': 'B',
//       'Major': 'major',
//     },
//     'de': {
//       'Cb': 'Ces',
//       'C': 'C',
//       'C#': 'Cis',
//       'Db': 'Des',
//       'D': 'D',
//       'Eb': 'Es',
//       'E': 'E',
//       'F': 'F',
//       'F#': 'Fis',
//       'Gb': 'Ges',
//       'G': 'G',
//       'Ab': 'As',
//       'A': 'A',
//       'Bb': 'Bes',
//       'B': 'B',
//       'Major': 'Dur',
//     },
//     'it': {
//       'Cb': 'Do♭',
//       'C': 'Do',
//       'C#': 'Do#',
//       'Db': 'Re♭',
//       'D': 'Re',
//       'Eb': 'Mi♭',
//       'E': 'Mi',
//       'F': 'Fa',
//       'F#': 'Fa#',
//       'Gb': 'Sol♭',
//       'G': 'Sol',
//       'Ab': 'La♭',
//       'A': 'La',
//       'Bb': 'Si♭',
//       'B': 'Si',
//       'Major': 'maggiore'
//     },
//   };

//   LocalizationProvider() {
//     _loadSavedLanguage();
//   }

//   String get currentLanguage => _currentLanguage;

//   Future<void> _loadSavedLanguage() async {
//     _prefs = await SharedPreferences.getInstance();
//     changeLanguage(_prefs.getString(_languageKey) ?? 'en');
//   }

//   void changeLanguage(String newLanguage) {
//     if (localizedValues.containsKey(newLanguage)) {
//       _currentLanguage = newLanguage;
//       _prefs.setString(_languageKey, newLanguage);
//     }
//   }

//   String translate(String key) {
//     return localizedValues[_currentLanguage]?[key] ?? key;
//   }
// }

// /// **Riverpod Provider for Localization**
// final localizationProvider = Provider<LocalizationProvider>((ref) {
//   return LocalizationProvider();
// });
