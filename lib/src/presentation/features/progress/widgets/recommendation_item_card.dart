import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/recommendation_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';

/// Recommendation item card
class RecommendationItemCard extends StatelessWidget {
  final RecommendationItem item;

  const RecommendationItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final isHighPriority = item.priority == 'high';

    return Semantics(
      label: '${item.title}: ${item.description}',
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(context.padding.p20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  Gap(context.spacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: context.textStyle.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isHighPriority)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.padding.p8,
                                  vertical: context.padding.p4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9800),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Ưu tiên cao',
                                  style: context.textStyle.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          item.description,
                          style: context.textStyle.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(context.spacing.s16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (item.skillId != null) {
                      context.push(
                        '${Routes.practiceQuestion}?skillId=${item.skillId}',
                      );
                    } else {
                      // Navigate based on action type
                      if (item.action.contains('Luyện tập')) {
                        context.push(Routes.practiceQuestion);
                      } else if (item.action.contains('Học skill')) {
                        if (item.skillId != null) {
                          context.push(
                            '${Routes.progressSkillDetail}?skillId=${item.skillId}',
                          );
                        }
                      }
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(item.action),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: context.padding.p12,
                    ),
                    minimumSize: const Size(0, 48),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

