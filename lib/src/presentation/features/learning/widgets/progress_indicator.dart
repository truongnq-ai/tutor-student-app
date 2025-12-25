import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Circular progress indicator with percentage display
class CircularProgressWithLabel extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final String? label;
  final TextStyle? labelStyle;

  const CircularProgressWithLabel({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 8,
    this.color,
    this.backgroundColor,
    this.label,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? const Color(0xFF4CAF50);
    final bgColor = backgroundColor ?? const Color(0xFFE0E0E0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          if (label != null)
            Text(
              label!,
              style: labelStyle ??
                  context.textStyle.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            )
          else
            Text(
              '${(progress * 100).toInt()}%',
              style: labelStyle ??
                  context.textStyle.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
        ],
      ),
    );
  }
}

/// Linear progress indicator with label
class LinearProgressWithLabel extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final String? label;
  final EdgeInsets? padding;

  const LinearProgressWithLabel({
    super.key,
    required this.progress,
    this.height = 4,
    this.color,
    this.backgroundColor,
    this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? const Color(0xFF4CAF50);
    final bgColor = backgroundColor ?? const Color(0xFFE0E0E0);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: context.textStyle.bodySmall,
            ),
            SizedBox(height: context.spacing.s8),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: height,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}

