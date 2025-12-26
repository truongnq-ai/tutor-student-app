import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../../domain/entities/skill_detail_entity.dart';

/// Mastery timeline showing progress over last 7 days
class MasteryTimeline extends StatelessWidget {
  final List<MasteryTimelineItem> timelineData;
  final double height;

  const MasteryTimeline({
    super.key,
    required this.timelineData,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    if (timelineData.isEmpty) {
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

    final maxMastery = timelineData
            .map((d) => d.masteryLevel)
            .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final minMastery = timelineData
            .map((d) => d.masteryLevel)
            .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final range = (maxMastery - minMastery).clamp(10.0, 100.0);
    final baseValue = (minMastery - 5).clamp(0.0, 100.0);

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
              children: timelineData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                
                // Calculate bar height relative to range
                final normalizedValue = (data.masteryLevel - baseValue) / range;
                final barHeight = (normalizedValue * (height - 80))
                    .clamp(20.0, height - 80);

                // Parse date
                final dateParts = data.date.split('-');
                if (dateParts.length != 3) {
                  return const SizedBox.shrink();
                }
                final day = int.tryParse(dateParts[2]) ?? 0;
                final dayName = _getDayName(index);

                // Get color based on mastery level
                final masteryColor = _getMasteryColor(data.masteryLevel);

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
                          color: masteryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: barHeight > 25
                            ? Center(
                                child: Text(
                                  '${data.masteryLevel}%',
                                  style: context.textStyle.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
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

  Color _getMasteryColor(int level) {
    if (level < 40) {
      return const Color(0xFFF44336); // Red
    } else if (level < 70) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFF4CAF50); // Green
    }
  }
}

