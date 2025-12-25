import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class ResultIndicator extends StatelessWidget {
  final bool isCorrect;
  final String? message;
  final String? encouragement;

  const ResultIndicator({
    super.key,
    required this.isCorrect,
    this.message,
    this.encouragement,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isCorrect
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    final iconColor = isCorrect
        ? const Color(0xFF4CAF50)
        : const Color(0xFFF44336);
    final icon = isCorrect
        ? Icons.check_circle
        : Icons.cancel;

    return Container(
      padding: EdgeInsets.all(context.padding.p24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: iconColor,
          ),
          Gap(context.spacing.s12),
          Text(
            message ??
                (isCorrect ? 'Chính xác!' : 'Chưa đúng'),
            style: context.textStyle.headingSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          if (encouragement != null) ...[
            Gap(context.spacing.s8),
            Text(
              encouragement!,
              style: context.textStyle.body.copyWith(
                fontStyle: FontStyle.italic,
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

