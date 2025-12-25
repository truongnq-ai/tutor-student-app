import 'package:flutter/material.dart';

import '../gen/l10n/app_localizations.dart';

extension AppLocalizationExtension on AppLocalizations {
  String getLanguageName(String languageCode) {
    return switch (languageCode) {
      'vi' => language_vietnamese,
      'en' => language_english,
      _ => languageCode,
    };
  }
}

extension BuildContextLocalizationExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}
