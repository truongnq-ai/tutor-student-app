import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../../domain/entities/learning_entity.dart';

class LearningCard extends StatelessWidget {
  final RecommendedSkillEntity? recommendedSkill;
  final VoidCallback? onStartLearning;

  const LearningCard({
    super.key,
    this.recommendedSkill,
    this.onStartLearning,
  });

  @override
  Widget build(BuildContext context) {
    if (recommendedSkill == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.padding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmallText(context.locale.learning_today_title),
            Gap(context.spacing.s16),
            if (recommendedSkill!.skillName != null) ...[
              Text(
                recommendedSkill!.skillName!,
                style: context.textStyle.headingSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(context.spacing.s8),
            ],
            if (recommendedSkill!.difficultyLevel != null) ...[
              Text(
                context.locale.learning_difficulty_label(
                  _getDifficultyText(context, recommendedSkill!.difficultyLevel!),
                ),
                style: context.textStyle.bodySmall,
              ),
              Gap(context.spacing.s8),
            ],
            if (recommendedSkill!.recommendationReason != null) ...[
              Text(
                recommendedSkill!.recommendationReason!,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Gap(context.spacing.s16),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onStartLearning,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                  minimumSize: const Size(0, 48),
                ),
                child: Text(context.locale.common_button_start_learning),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyText(BuildContext context, int difficulty) {
    switch (difficulty) {
      case 1:
        return context.locale.difficulty_easy;
      case 2:
        return context.locale.difficulty_medium;
      case 3:
        return context.locale.difficulty_fair;
      case 4:
        return context.locale.difficulty_hard;
      case 5:
        return context.locale.difficulty_very_hard;
      default:
        return context.locale.difficulty_medium;
    }
  }
}

