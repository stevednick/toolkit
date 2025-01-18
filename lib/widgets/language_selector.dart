import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolkit/localization/localization_provider.dart';
import 'package:toolkit/widgets/nice_button.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String? _currentLanguage;
  late NiceButton button;

  @override
  void initState() {
    super.initState();
    _currentLanguage = Provider.of<LocalizationProvider>(context, listen: false).currentLanguage;
    button = NiceButton(
      text: _getLanguageName(_currentLanguage!),
      onPressed: () {
        _showLanguageMenu(context);
      },
    );
  }
  void _showLanguageMenu(BuildContext context) {
    RenderBox renderButton = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderButton.localToGlobal(Offset.zero, ancestor: overlay),
        renderButton.localToGlobal(renderButton.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: ['en', 'de', 'it'].map((String language) {
        return PopupMenuItem<String>(
          value: language,
          child: Text(_getLanguageName(language)),
        );
      }).toList(),
    ).then((String? selectedLanguage) {
      if (selectedLanguage != null) {
        setState(() {
          _currentLanguage = selectedLanguage;
          Provider.of<LocalizationProvider>(context, listen: false).changeLanguage(selectedLanguage);
          button = NiceButton(
            text: _getLanguageName(selectedLanguage),
            onPressed: () {
              _showLanguageMenu(context);
            },
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return button;
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'C E♭ F#';
      case 'de':
        return 'C Es Fis';
      case 'it':
        return 'Do Mi♭ Fa#';
      default:
        return languageCode;
    }
  }
}


// class LanguageSelector extends StatefulWidget {
//   const LanguageSelector({super.key});

//   @override
//   _LanguageSelectorState createState() => _LanguageSelectorState();
// }

// class _LanguageSelectorState extends State<LanguageSelector> {
//   String? _currentLanguage;

//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentLanguage();
//   }

//   void _loadCurrentLanguage() async {
//     final localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);
//     final savedLanguage = await localizationProvider.getSavedLanguage();
//     setState(() {
//       _currentLanguage = savedLanguage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localizationProvider = Provider.of<LocalizationProvider>(context);

//     return DropdownButton<String>(
//       value: _currentLanguage,
//       items: localizationProvider.localizedValues.keys.map((String languageCode) {
//         return DropdownMenuItem<String>(
//           value: languageCode,
//           child: Text(_getLanguageName(languageCode)),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         if (newValue != null) {
//           setState(() {
//             _currentLanguage = newValue;
//           });
//           localizationProvider.changeLanguage(newValue);
//         }
//       },
//     );
//   }

//   
// }

