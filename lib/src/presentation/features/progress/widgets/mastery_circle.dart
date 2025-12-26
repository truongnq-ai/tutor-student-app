import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Circular progress indicator for mastery level (120x120px)
class MasteryCircle extends StatelessWidget {
  final int masteryLevel; // 0-100
  final double size;
  final double strokeWidth;
  final String? label;
  final TextStyle? labelStyle;

  const MasteryCircle({
    super.key,
    required this.masteryLevel,
    this.size = 120,
    this.strokeWidth = 12,
    this.label,
    this.labelStyle,
  });

  Color _getMasteryColor(int level) {
    if (level < 40) {
      return const Color(0xFFF44336); // Red for weak
    } else if (level < 70) {
      return const Color(0xFFFF9800); // Orange for improving
    } else {
      return const Color(0xFF4CAF50); // Green for mastered
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (masteryLevel / 100).clamp(0.0, 1.0);
    final progressColor = _getMasteryColor(masteryLevel);
    final bgColor = const Color(0xFFE0E0E0);

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
              value: progress,
              strokeWidth: strokeWidth,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: labelStyle ??
                      context.textStyle.headingSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
                )
              else
                Text(
                  '$masteryLevel%',
                  style: labelStyle ??
                      context.textStyle.headingMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
                ),
              const SizedBox(height: 4),
              Text(
                'Mastery',
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

