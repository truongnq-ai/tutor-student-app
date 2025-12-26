import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/tutor_entity.dart';
import '../../../core/theme/theme.dart';

class SolutionStepCard extends StatelessWidget {
  final SolutionStepEntity step;
  final int stepNumber;

  const SolutionStepCard({
    super.key,
    required this.step,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.padding.p20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.padding.p12,
              vertical: context.padding.p8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF4CAF50),
                width: 1,
              ),
            ),
            child: Text(
              'Bước $stepNumber',
              style: context.textStyle.bodySmall.copyWith(
                color: const Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Gap(context.spacing.s16),

          // Step title/description
          if (step.description.isNotEmpty)
            Text(
              step.description,
              style: context.textStyle.headingSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          Gap(context.spacing.s12),

          // Step content (math expression)
          if (step.content.isNotEmpty)
            Container(
              padding: EdgeInsets.all(context.padding.p12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Semantics(
                label: 'Công thức: ${step.content}',
                child: Text(
                  step.content,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ),
          Gap(context.spacing.s12),

          // Step explanation
          if (step.explanation.isNotEmpty)
            Text(
              step.explanation,
              style: context.textStyle.bodyMedium.copyWith(
                height: 1.5,
              ),
            ),

          // Step hint (if available)
          if (step.hint != null && step.hint!.isNotEmpty) ...[
            Gap(context.spacing.s12),
            Container(
              padding: EdgeInsets.all(context.padding.p12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFF9800),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFFFF9800),
                    size: 20,
                  ),
                  Gap(context.spacing.s8),
                  Expanded(
                    child: Text(
                      step.hint!,
                      style: context.textStyle.bodySmall.copyWith(
                        color: const Color(0xFFFF9800),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

