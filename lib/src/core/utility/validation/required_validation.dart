import 'package:flutter/material.dart';

import '../../extensions/app_localization.dart';
import 'validation.dart';

class RequiredValidation<T> extends Validation<T> {
  @override
  String? validate(BuildContext context, T? value) {
    if (value == null) {
      return context.locale.validation_required;
    }

    if (value is String && (value as String).isEmpty) {
      return context.locale.validation_required;
    }

    return null;
  }
}
