import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
            const HeadingSmallText('Học hôm nay'),
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
                'Độ khó: ${_getDifficultyText(recommendedSkill!.difficultyLevel!)}',
                style: context.textStyle.bodySmall,
              ),
              Gap(context.spacing.s8),
            ],
            if (recommendedSkill!.recommendationReason != null) ...[
              Text(
                recommendedSkill!.recommendationReason!,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.textSecondary,
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
                child: const Text('Bắt đầu học'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Dễ';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Khá';
      case 4:
        return 'Khó';
      case 5:
        return 'Rất khó';
      default:
        return 'Trung bình';
    }
  }
}

