import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class AdaptiveNotification extends StatelessWidget {
  final bool isDifficultyIncrease; // true if increasing, false if decreasing
  final String message;

  const AdaptiveNotification({
    super.key,
    required this.isDifficultyIncrease,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDifficultyIncrease
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFF9E6);
    final iconColor = isDifficultyIncrease
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF9800);
    final icon = isDifficultyIncrease
        ? Icons.trending_up
        : Icons.trending_down;

    return Container(
      padding: EdgeInsets.all(context.padding.p16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          Gap(context.spacing.s12),
          Expanded(
            child: Text(
              message,
              style: context.textStyle.body.copyWith(
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

