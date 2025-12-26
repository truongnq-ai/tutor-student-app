import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/mini_test_result_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

/// Skill breakdown item for mini test result
class SkillBreakdownItemWidget extends StatelessWidget {
  final SkillBreakdownItem item;

  const SkillBreakdownItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final isPerfect = item.correctCount == item.totalCount;
    final percentage = (item.correctCount / item.totalCount * 100).round();

    return Semantics(
      label: '${item.skillName}: ${item.correctCount}/${item.totalCount} câu đúng',
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(context.padding.p16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.skillName,
                      style: context.textStyle.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(context.spacing.s4),
                    Text(
                      '${item.correctCount}/${item.totalCount} câu',
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(context.spacing.s12),
              if (isPerfect)
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF4CAF50),
                  size: 24,
                )
              else
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.padding.p8,
                    vertical: context.padding.p4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$percentage%',
                    style: context.textStyle.bodySmall.copyWith(
                      color: const Color(0xFFFF9800),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

