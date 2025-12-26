import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

/// Stat card for displaying progress statistics
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = iconColor ?? context.color.primary;
    final defaultBgColor = backgroundColor ?? Colors.white;

    return Card(
      color: defaultBgColor,
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.padding.p8),
                  decoration: BoxDecoration(
                    color: defaultIconColor.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: defaultIconColor,
                    size: 24,
                  ),
                ),
              ],
            ),
            Gap(context.spacing.s12),
            Text(
              value,
              style: context.textStyle.headingMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(context.spacing.s4),
            Text(
              title,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

