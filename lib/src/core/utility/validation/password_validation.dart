import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extensions/app_localization.dart';
import 'validation.dart';

class PasswordValidation extends Validation<String> {
  PasswordValidation({
    this.minLength = 6,
    this.number = false,
    this.lowerCase = false,
    this.upperCase = false,
    this.specialChar = false,
  });

  final int minLength;
  final bool number;
  final bool lowerCase;
  final bool upperCase;
  final bool specialChar;

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null) return null;

    if (value.length < minLength) {
      final localizedNumber = NumberFormat.decimalPattern(
        Localizations.localeOf(context).languageCode,
      ).format(minLength);

      return context.locale.validation_password_min_length(localizedNumber);
    }

    if (number && !value.contains(RegExp(r'\d'))) {
      return context.locale.validation_password_number;
    }

    if (lowerCase && !value.contains(RegExp(r'[a-z]'))) {
      return context.locale.validation_password_lowercase;
    }

    if (upperCase && !value.contains(RegExp(r'[A-Z]'))) {
      return context.locale.validation_password_uppercase;
    }

    if (specialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return context.locale.validation_password_special_char;
    }

    return null;
  }
}
