import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

/// Celebration card shown when mini test is unlocked
class UnlockCelebrationCard extends StatelessWidget {
  final int practiceCount;
  final int requiredCount;

  const UnlockCelebrationCard({
    super.key,
    required this.practiceCount,
    required this.requiredCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF4CAF50),
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 32,
                ),
                Gap(context.spacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bạn đã làm đủ bài luyện tập!',
                        style: context.textStyle.headingSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Gap(context.spacing.s4),
                      Text(
                        'Sẵn sàng cho Mini Test',
                        style: context.textStyle.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha:0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(context.spacing.s12),
            Container(
              padding: EdgeInsets.all(context.padding.p12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã làm: ',
                    style: context.textStyle.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$practiceCount/$requiredCount bài luyện tập',
                    style: context.textStyle.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

