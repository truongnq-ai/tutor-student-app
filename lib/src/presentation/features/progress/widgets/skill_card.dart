import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../../domain/entities/progress_dashboard_entity.dart';
import 'mastery_circle.dart';

/// Skill card with mastery level display
class SkillCard extends StatelessWidget {
  final SkillProgressItem skill;
  final VoidCallback? onTap;

  const SkillCard({
    super.key,
    required this.skill,
    this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'weak':
        return const Color(0xFFF44336);
      case 'improving':
        return const Color(0xFFFF9800);
      case 'mastered':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'weak':
        return 'Yếu';
      case 'improving':
        return 'Đang cải thiện';
      case 'mastered':
        return 'Thành thạo';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(skill.status);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(context.padding.p16),
          child: Row(
            children: [
              MasteryCircle(
                masteryLevel: skill.masteryLevel,
                size: 80,
                strokeWidth: 8,
              ),
              Gap(context.spacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.skillName,
                      style: context.textStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(context.spacing.s4),
                    Text(
                      skill.skillCode,
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
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getStatusText(skill.status),
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

