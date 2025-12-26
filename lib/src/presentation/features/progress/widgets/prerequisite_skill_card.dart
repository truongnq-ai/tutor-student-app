import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../../domain/entities/recommendation_entity.dart';
import '../../../core/router/routes.dart';
import 'mastery_circle.dart';

/// Prerequisite skill card
class PrerequisiteSkillCard extends StatelessWidget {
  final PrerequisiteSkillItem prerequisite;
  final VoidCallback? onTap;

  const PrerequisiteSkillCard({
    super.key,
    required this.prerequisite,
    this.onTap,
  });

  Color _getMasteryColor(int level) {
    if (level < 40) {
      return const Color(0xFFF44336);
    } else if (level < 70) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFF4CAF50);
    }
  }

  String _getStatusText(int level) {
    if (level < 40) {
      return 'Yếu';
    } else if (level < 70) {
      return 'Đang cải thiện';
    } else {
      return 'Thành thạo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getMasteryColor(prerequisite.masteryLevel);

    return Card(
      child: InkWell(
        onTap: onTap ?? () {
          context.push(
            '${Routes.progressSkillDetail}?skillId=${prerequisite.skillId}',
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(context.padding.p16),
          child: Row(
            children: [
              MasteryCircle(
                masteryLevel: prerequisite.masteryLevel,
                size: 60,
                strokeWidth: 6,
              ),
              Gap(context.spacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prerequisite.skillName,
                      style: context.textStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(context.spacing.s4),
                    Text(
                      prerequisite.skillCode,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                    Gap(context.spacing.s8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.padding.p8,
                        vertical: context.padding.p4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getStatusText(prerequisite.masteryLevel),
                        style: context.textStyle.bodySmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.color.text.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

