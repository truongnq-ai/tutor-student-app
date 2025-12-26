import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

/// Instructions and rules card for mini test
class TestInstructionsCard extends StatelessWidget {
  final List<String> skillsToTest;
  final List<String>? customRules;

  const TestInstructionsCard({
    super.key,
    required this.skillsToTest,
    this.customRules,
  });

  @override
  Widget build(BuildContext context) {
    final defaultRules = [
      'Không được quay lại câu trước',
      'Phải hoàn thành trong thời gian quy định',
      'Điểm ≥ 70% để pass',
    ];

    final rules = customRules ?? defaultRules;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmallText('Hướng dẫn'),
            Gap(context.spacing.s12),
            Text(
              'Bài test này sẽ kiểm tra kiến thức của bạn về:',
              style: context.textStyle.bodyMedium,
            ),
            Gap(context.spacing.s8),
            ...skillsToTest.map((skill) => Padding(
                  padding: EdgeInsets.only(bottom: context.spacing.s4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 6,
                        color: context.color.primary,
                      ),
                      Gap(context.spacing.s8),
                      Expanded(
                        child: Text(
                          skill,
                          style: context.textStyle.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
            Gap(context.spacing.s16),
            Container(
              padding: EdgeInsets.all(context.padding.p12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.color.text.secondary.withValues(alpha:0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quy tắc:',
                    style: context.textStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(context.spacing.s8),
                  ...rules.map((rule) => Padding(
                        padding: EdgeInsets.only(bottom: context.spacing.s4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✓',
                              style: context.textStyle.bodyMedium.copyWith(
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(context.spacing.s8),
                            Expanded(
                              child: Text(
                                rule,
                                style: context.textStyle.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

