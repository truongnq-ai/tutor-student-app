import 'package:flutter/material.dart';

class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension();

  TextStyle get headingLarge {
    return const TextStyle(
      height: 1.33,
      fontSize: 24,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get headingMedium {
    return const TextStyle(
      height: 1.40,
      fontSize: 20,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get headingSmall {
    return const TextStyle(
      height: 1.33,
      fontSize: 18,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get bodyLarge {
    return const TextStyle(
      height: 1.50,
      fontSize: 16,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  /// Default body text style (16px).
  /// Alias for [bodyLarge] to match design standards.
  /// Use this for default text, paragraphs, and descriptions.
  TextStyle get body => bodyLarge;

  TextStyle get bodyMedium {
    return const TextStyle(
      height: 1.42,
      fontSize: 14,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get bodySmall {
    return const TextStyle(
      height: 1.43,
      fontSize: 14,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get labelMedium {
    return const TextStyle(
      height: 1.15,
      fontSize: 14,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    );
  }

  @override
  ThemeExtension<TextStyleExtension> copyWith() => const TextStyleExtension();

  @override
  ThemeExtension<TextStyleExtension> lerp(other, t) =>
      const TextStyleExtension();
}
