import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class PracticeCard extends StatelessWidget {
  final String skillName;
  final DateTime createdAt;
  final int correctCount;
  final int totalCount;
  final int? masteryChange;
  final int? durationSec;
  final VoidCallback? onTap;

  const PracticeCard({
    super.key,
    required this.skillName,
    required this.createdAt,
    required this.correctCount,
    required this.totalCount,
    this.masteryChange,
    this.durationSec,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = totalCount > 0 ? (correctCount / totalCount * 100).toInt() : 0;
    final isSuccess = accuracy >= 70;
    final dateFormat = DateFormat('dd/MM/yyyy', 'vi');

    return Card(
      margin: EdgeInsets.only(bottom: context.spacing.s8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                width: 4,
              ),
            ),
          ),
          padding: EdgeInsets.all(context.padding.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormat.format(createdAt),
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.textSecondary,
                    ),
                  ),
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.warning,
                    color: isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                    size: 20,
                  ),
                ],
              ),
              Gap(context.spacing.s8),
              Text(
                skillName,
                style: context.textStyle.body.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(context.spacing.s8),
              Row(
                children: [
                  _buildStatChip(
                    context,
                    '$totalCount bài',
                    Icons.assignment,
                  ),
                  Gap(context.spacing.s8),
                  _buildStatChip(
                    context,
                    'Đúng: $correctCount',
                    Icons.check,
                    color: const Color(0xFF4CAF50),
                  ),
                  Gap(context.spacing.s8),
                  _buildStatChip(
                    context,
                    'Sai: ${totalCount - correctCount}',
                    Icons.close,
                    color: const Color(0xFFF44336),
                  ),
                  Gap(context.spacing.s8),
                  _buildStatChip(
                    context,
                    '$accuracy%',
                    Icons.bar_chart,
                  ),
                ],
              ),
              if (masteryChange != null && masteryChange != 0) ...[
                Gap(context.spacing.s8),
                Text(
                  masteryChange! > 0
                      ? 'Mastery: +$masteryChange%'
                      : 'Mastery: $masteryChange%',
                  style: context.textStyle.bodySmall.copyWith(
                    color: masteryChange! > 0
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF44336),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (durationSec != null) ...[
                Gap(context.spacing.s4),
                Text(
                  'Thời gian: ${_formatDuration(durationSec!)}',
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    IconData icon, {
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.padding.p8,
        vertical: context.padding.p4,
      ),
      decoration: BoxDecoration(
        color: (color ?? context.color.textSecondary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? context.color.textSecondary,
          ),
          Gap(context.spacing.s4),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: color ?? context.color.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return remainingSeconds > 0
          ? '${minutes}p ${remainingSeconds}s'
          : '${minutes}p';
    }
  }
}

