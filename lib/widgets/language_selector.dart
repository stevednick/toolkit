import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/providers/language_provider.dart';
import 'package:toolkit/widgets/nice_button.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);  // Now listens for changes

    return NiceButton(
      text: _getLanguageName(currentLanguage),
      onPressed: () => _showLanguageMenu(context, ref),
    );
  }

  void _showLanguageMenu(BuildContext context, WidgetRef ref) {
  final overlay = Overlay.of(context);
  final renderButton = context.findRenderObject() as RenderBox?;
  final overlayBox = overlay.context.findRenderObject() as RenderBox?;

  if (renderButton == null || overlayBox == null) {
    return; // Prevent errors if either is null
  }

  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      renderButton.localToGlobal(Offset.zero, ancestor: overlayBox),
      renderButton.localToGlobal(renderButton.size.bottomRight(Offset.zero), ancestor: overlayBox),
    ),
    Offset.zero & overlayBox.size,
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
      ref.read(languageProvider.notifier).changeLanguage(selectedLanguage);
    }
  });
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
