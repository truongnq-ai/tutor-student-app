import 'package:flutter/material.dart';

class Dimensions extends ThemeExtension<Dimensions> {
  const Dimensions();

  ThemeSpacing get spacing => ThemeSpacing.instance;
  ThemePadding get padding => ThemePadding.instance;
  ThemeMargin get margin => ThemeMargin.instance;
  ThemeRadius get radius => ThemeRadius.instance;

  /// Source of truth
  static const double _v1 = 1;
  static const double _v1_25 = 1.25;
  static const double _v2 = 2;
  static const double _v4 = 4;
  static const double _v6 = 6;
  static const double _v8 = 8;
  static const double _v12 = 12;
  static const double _v16 = 16;
  static const double _v20 = 20;
  static const double _v24 = 24;
  static const double _v30 = 30;
  static const double _v32 = 32;
  static const double _v44 = 44;
  static const double _v48 = 48;
  static const double _v66 = 66;
  static const double _v80 = 80;
  static const double _v100 = 100;
  static const double _v200 = 200;
  static const double _v210 = 210;

  @override
  ThemeExtension<Dimensions> lerp(
    covariant ThemeExtension<Dimensions>? other,
    double t,
  ) {
    if (other is! Dimensions) {
      return this;
    }
    // Constants don't really lerp, but we return 'this' (or other if t >= 0.5)
    // as per previous behavior. If we wanted to lerp, we'd need to lerp the
    // fields, but these are just buckets of constants.
    return t < 0.5 ? this : other;
  }

  @override
  ThemeExtension<Dimensions> copyWith() {
    return const Dimensions();
  }
}

/// Public spacing class for theme dimensions
class ThemeSpacing {
  const ThemeSpacing._();

  static const ThemeSpacing instance = ThemeSpacing._();

  double get s1 => Dimensions._v1;
  double get s1_25 => Dimensions._v1_25;
  double get s2 => Dimensions._v2;
  double get s4 => Dimensions._v4;
  double get s6 => Dimensions._v6;
  double get s8 => Dimensions._v8;
  double get s12 => Dimensions._v12;
  double get s16 => Dimensions._v16;
  double get s24 => Dimensions._v24;
  double get s30 => Dimensions._v30;
  double get s32 => Dimensions._v32;
  double get s44 => Dimensions._v44;
  double get s48 => Dimensions._v48;
  double get s66 => Dimensions._v66;
  double get s80 => Dimensions._v80;
  double get s100 => Dimensions._v100;
  double get s200 => Dimensions._v200;
  double get s210 => Dimensions._v210;
}

/// Public padding class for theme dimensions
class ThemePadding {
  const ThemePadding._();

  static const ThemePadding instance = ThemePadding._();

  double get p4 => Dimensions._v4;
  double get p8 => Dimensions._v8;
  double get p16 => Dimensions._v16;
  double get p20 => Dimensions._v20;
  double get p24 => Dimensions._v24;
}

/// Public margin class for theme dimensions
class ThemeMargin {
  const ThemeMargin._();

  static const ThemeMargin instance = ThemeMargin._();

  double get m6 => Dimensions._v6;
}

/// Public radius class for theme dimensions
class ThemeRadius {
  const ThemeRadius._();

  static const ThemeRadius instance = ThemeRadius._();

  double get r4 => Dimensions._v4;
  double get r6 => Dimensions._v6;
}
