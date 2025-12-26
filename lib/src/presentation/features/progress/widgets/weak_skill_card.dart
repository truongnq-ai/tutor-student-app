import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/weak_skill_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import 'mastery_circle.dart';

/// Weak skill card for recommendations
class WeakSkillCard extends StatelessWidget {
  final WeakSkillEntity skill;

  const WeakSkillCard({
    super.key,
    required this.skill,
  });

  String _getStatusText(String status) {
    switch (status) {
      case 'weak':
        return 'Yếu';
      case 'needs_practice':
        return 'Cần luyện tập';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'weak':
        return const Color(0xFFF44336);
      case 'needs_practice':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(skill.status);
    final recommendation = 'Làm thêm ${skill.questionCount} bài để đạt 70%';

    return Semantics(
      label: '${skill.skillName}: ${skill.masteryLevel}% - ${_getStatusText(skill.status)} - $recommendation',
      child: Card(
        child: InkWell(
          onTap: () {
            context.push(
              '${Routes.progressSkillDetail}?skillId=${skill.skillId}',
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(context.padding.p16),
            child: Row(
              children: [
                MasteryCircle(
                  masteryLevel: skill.masteryLevel,
                  size: 60,
                  strokeWidth: 6,
                ),
                Gap(context.spacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.skillName,
                        style: context.textStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(context.spacing.s4),
                      Row(
                        children: [
                          Text(
                            '${skill.masteryLevel}%',
                            style: context.textStyle.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(context.spacing.s8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.padding.p4,
                              vertical: context.padding.p4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
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
                      Gap(context.spacing.s4),
                      Text(
                        recommendation,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
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
      ),
    );
  }
}

