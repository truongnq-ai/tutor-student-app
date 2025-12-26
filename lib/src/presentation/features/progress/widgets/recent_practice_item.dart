import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import '../../../../domain/entities/skill_detail_entity.dart';

/// Recent practice item card
class RecentPracticeItemWidget extends StatelessWidget {
  final RecentPracticeItem practice;
  final VoidCallback? onTap;

  const RecentPracticeItemWidget({
    super.key,
    required this.practice,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'vi');
    final isToday = _isToday(practice.practicedAt);
    final dateText = isToday
        ? 'Hôm nay ${DateFormat('HH:mm', 'vi').format(practice.practicedAt)}'
        : dateFormat.format(practice.practicedAt);

    return Card(
      margin: EdgeInsets.only(bottom: context.spacing.s8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(context.padding.p12),
          child: Row(
            children: [
              // Result icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: practice.isCorrect
                      ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                      : const Color(0xFFF44336).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  practice.isCorrect ? Icons.check_circle : Icons.cancel,
                  color: practice.isCorrect
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336),
                  size: 24,
                ),
              ),
              Gap(context.spacing.s12),
              // Question preview and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      practice.questionPreview,
                      style: context.textStyle.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(context.spacing.s4),
                    Text(
                      dateText,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.padding.p8,
                  vertical: context.padding.p4,
                ),
                decoration: BoxDecoration(
                  color: practice.isCorrect
                      ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                      : const Color(0xFFF44336).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  practice.isCorrect ? 'Đúng' : 'Sai',
                  style: context.textStyle.bodySmall.copyWith(
                    color: practice.isCorrect
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF44336),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

