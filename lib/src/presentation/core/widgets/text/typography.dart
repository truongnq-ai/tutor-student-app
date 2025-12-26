import 'package:flutter/material.dart';

import '../../theme/theme.dart';

abstract class _Typography extends StatelessWidget {
  const _Typography(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.semanticsLabel,
    this.style,
  });

  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final String? semanticsLabel;
  final TextStyle? style;

  @override
  Widget build(BuildContext context);
}

class HeadingLargeText extends _Typography {
  const HeadingLargeText(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
    super.style,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = context.textStyle.headingLarge.copyWith(
      color: context.color.text.primary,
    );
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      semanticsLabel: semanticsLabel,
      style: style != null ? baseStyle.merge(style) : baseStyle,
    );
  }
}

class HeadingSmallText extends _Typography {
  const HeadingSmallText(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
    super.style,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = context.textStyle.headingSmall.copyWith(
      color: context.color.text.primary,
    );
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      semanticsLabel: semanticsLabel,
      style: style != null ? baseStyle.merge(style) : baseStyle,
    );
  }
}

class BodyLargeText extends _Typography {
  const BodyLargeText(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
    super.style,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = context.textStyle.bodyLarge.copyWith(
      color: context.color.text.primary,
    );
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      semanticsLabel: semanticsLabel,
      style: style != null ? baseStyle.merge(style) : baseStyle,
    );
  }
}

class BodySmallText extends _Typography {
  const BodySmallText(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
    super.style,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = context.textStyle.bodySmall.copyWith(
      color: context.color.text.primary,
    );
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      semanticsLabel: semanticsLabel,
      style: style != null ? baseStyle.merge(style) : baseStyle,
    );
  }
}

enum _BodyMediumTextVariant { primary, secondary }

class BodyMediumText extends _Typography {
  const BodyMediumText(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
    super.style,
  }) : _variant = _BodyMediumTextVariant.primary;

  const BodyMediumText.secondary(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
    super.style,
  }) : _variant = _BodyMediumTextVariant.secondary;

  final _BodyMediumTextVariant _variant;

  @override
  Widget build(BuildContext context) {
    final baseStyle = switch (_variant) {
      _BodyMediumTextVariant.primary => context.textStyle.bodyMedium,
      _BodyMediumTextVariant.secondary => context.textStyle.bodyMedium.copyWith(
        color: context.color.text.secondary,
        fontWeight: FontWeight.w500,
      ),
    };

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      semanticsLabel: semanticsLabel,
      style: style != null ? baseStyle.merge(style) : baseStyle,
    );
  }
}
