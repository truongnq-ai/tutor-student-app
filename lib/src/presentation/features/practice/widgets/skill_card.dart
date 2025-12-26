import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class SkillCard extends StatelessWidget {
  final String skillName;
  final int masteryLevel; // 0-100
  final String? status; // "Yếu", "Chưa vững", etc.
  final int? questionCount;
  final String? estimatedTime;
  final bool isSelected;
  final bool isPriority;
  final VoidCallback? onTap;

  const SkillCard({
    super.key,
    required this.skillName,
    required this.masteryLevel,
    this.status,
    this.questionCount,
    this.estimatedTime,
    this.isSelected = false,
    this.isPriority = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
          width: isSelected ? 2 : 1,
        ),
      ),
      color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(context.padding.p20),
          child: Row(
            children: [
              // Mastery Circle
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: masteryLevel / 100.0,
                        strokeWidth: 6,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getMasteryColor(masteryLevel),
                        ),
                      ),
                    ),
                    Text(
                      '$masteryLevel%',
                      style: context.textStyle.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(context.spacing.s16),
              // Skill Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            skillName,
                            style: context.textStyle.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        if (isPriority)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.padding.p8,
                              vertical: context.padding.p4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9800).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Color(0xFFFF9800),
                                ),
                                Gap(context.spacing.s4),
                                Text(
                                  'Ưu tiên',
                                  style: context.textStyle.bodySmall.copyWith(
                                    color: const Color(0xFFFF9800),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    Gap(context.spacing.s4),
                    if (status != null)
                      Text(
                        status!,
                        style: context.textStyle.bodySmall.copyWith(
                          color: _getStatusColor(status!),
                        ),
                      ),
                    Gap(context.spacing.s4),
                    Row(
                      children: [
                        if (questionCount != null) ...[
                          Text(
                            '$questionCount ${context.locale.onboarding_trial_expiry_achievement_exercises}',
                            style: context.textStyle.bodySmall,
                          ),
                          if (estimatedTime != null) ...[
                            Text(
                              ' • ',
                              style: context.textStyle.bodySmall,
                            ),
                            Text(
                              estimatedTime!,
                              style: context.textStyle.bodySmall,
                            ),
                          ],
                        ] else if (estimatedTime != null)
                          Text(
                            estimatedTime!,
                            style: context.textStyle.bodySmall,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMasteryColor(int mastery) {
    if (mastery >= 90) {
      return const Color(0xFF4CAF50); // Green
    } else if (mastery >= 70) {
      return const Color(0xFF2196F3); // Blue
    } else if (mastery >= 40) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'yếu':
        return const Color(0xFFF44336);
      case 'chưa vững':
        return const Color(0xFFFF9800);
      case 'đang cải thiện':
        return const Color(0xFF2196F3);
      case 'thành thạo':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF757575);
    }
  }
}

