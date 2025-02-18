import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolkit/localization/localization_provider.dart';

class KeySignatureSelectorData {
  String getLocalizedName(BuildContext context, String name) {
    final localization =
        Provider.of<LocalizationProvider>(context, listen: false);
    return "${localization.translate(name)} ${localization.translate('Major')}";
  }
}
