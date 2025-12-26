import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

/// Result header card for mini test result
class ResultHeaderCard extends StatelessWidget {
  final bool passed;
  final int score;

  const ResultHeaderCard({
    super.key,
    required this.passed,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = passed
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFF9E6);
    final iconColor = passed
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF9800);
    final icon = passed
        ? Icons.check_circle
        : Icons.cancel;
    final title = passed
        ? 'Hoàn thành!'
        : 'Chưa đạt';

    return Semantics(
      label: '$title với điểm $score%',
      child: Card(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(context.padding.p24),
          child: Column(
            children: [
              Icon(
                icon,
                size: 64,
                color: iconColor,
              ),
              Gap(context.spacing.s16),
              Text(
                title,
                style: context.textStyle.headingSmall.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(context.spacing.s8),
              Text(
                '$score%',
                style: context.textStyle.headingLarge.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

