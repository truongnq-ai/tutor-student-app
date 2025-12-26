import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../../domain/entities/progress_dashboard_entity.dart';

/// Progress chart showing last 7 days of practice
class ProgressChart extends StatelessWidget {
  final List<ProgressDayData> progressData;
  final double height;

  const ProgressChart({
    super.key,
    required this.progressData,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (progressData.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Chưa có dữ liệu',
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ),
      );
    }

    final maxPractices = progressData
            .map((d) => d.practicesCount)
            .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final maxValue = maxPractices > 0 ? maxPractices : 10.0;

    return Container(
      height: height,
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến bộ 7 ngày qua',
            style: context.textStyle.headingSmall,
          ),
          Gap(context.spacing.s16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: progressData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final barHeight = (data.practicesCount / maxValue * (height - 80))
                    .clamp(0.0, height - 80);

                // Get day name (Mon, Tue, etc.)
                final dateParts = data.date.split('-');
                if (dateParts.length != 3) {
                  return const SizedBox.shrink();
                }
                final day = int.tryParse(dateParts[2]) ?? 0;
                final dayName = _getDayName(index);

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: context.spacing.s4,
                        ),
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: barHeight > 20
                            ? Center(
                                child: Text(
                                  '${data.practicesCount}',
                                  style: context.textStyle.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      Gap(context.spacing.s8),
                      Text(
                        dayName,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '$day',
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int index) {
    final now = DateTime.now();
    final targetDate = now.subtract(Duration(days: 6 - index));
    final weekdays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return weekdays[targetDate.weekday % 7];
  }
}

