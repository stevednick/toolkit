import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/providers/language_provider.dart';

class KeySignatureSelectorData {
  String getLocalizedName(WidgetRef ref, String name) {
    final localization = ref.read(languageProvider.notifier);
    return "${localization.translate(name)} ${localization.translate('Major')}";
  }
}
