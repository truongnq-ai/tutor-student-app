import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

/// Question card for mini test
class TestQuestionCard extends StatelessWidget {
  final int questionNumber;
  final String questionText;
  final String? questionImageUrl;

  const TestQuestionCard({
    super.key,
    required this.questionNumber,
    required this.questionText,
    this.questionImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu $questionNumber',
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(context.spacing.s12),
            Text(
              questionText,
              style: context.textStyle.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (questionImageUrl != null) ...[
              Gap(context.spacing.s16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  questionImageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: context.color.text.secondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

