import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

/// Test details card showing test information
class TestDetailCard extends StatelessWidget {
  final int totalQuestions;
  final int timeLimitMinutes;
  final int passingScore;

  const TestDetailCard({
    super.key,
    required this.totalQuestions,
    required this.timeLimitMinutes,
    this.passingScore = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmallText('Thông tin bài test'),
            Gap(context.spacing.s16),
            _buildDetailRow(
              context,
              Icons.quiz,
              'Số câu hỏi',
              '$totalQuestions câu',
            ),
            Gap(context.spacing.s12),
            _buildDetailRow(
              context,
              Icons.access_time,
              'Thời gian',
              '$timeLimitMinutes phút',
            ),
            Gap(context.spacing.s12),
            _buildDetailRow(
              context,
              Icons.star,
              'Điểm đạt',
              '≥ $passingScore%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(context.padding.p8),
          decoration: BoxDecoration(
            color: context.color.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: context.color.primary,
            size: 24,
          ),
        ),
        Gap(context.spacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Gap(context.spacing.s2),
              Text(
                value,
                style: context.textStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

