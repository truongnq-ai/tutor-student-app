import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/learning_plan_provider.dart';

class TodayLearningPlanPage extends ConsumerStatefulWidget {
  const TodayLearningPlanPage({super.key});

  @override
  ConsumerState<TodayLearningPlanPage> createState() => _TodayLearningPlanPageState();
}

class _TodayLearningPlanPageState extends ConsumerState<TodayLearningPlanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(learningPlanProvider.notifier).loadTodayPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final learningPlanState = ref.watch(learningPlanProvider);
    final now = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy', 'vi');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmallText('Lộ trình hôm nay'),
            Text(
              dateFormat.format(now),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: learningPlanState.when(
        data: (learningPlan) {
          if (learningPlan == null) {
            return _buildEmptyState(context);
          }
          return _buildContent(context, learningPlan);
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, learningPlan) {
    final recommendedSkill = learningPlan.recommendedSkill;
    final progressSummary = learningPlan.progressSummary;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Summary Card
          _buildProgressSummaryCard(context, progressSummary),
          Gap(context.spacing.s24),

          // Main Learning Card
          if (recommendedSkill != null) ...[
            _buildLearningCard(context, recommendedSkill),
            Gap(context.spacing.s24),
          ],

          // Week Progress Section
          _buildWeekProgressSection(context),
        ],
      ),
    );
  }

  Widget _buildProgressSummaryCard(BuildContext context, progressSummary) {
    final overallMastery = progressSummary.overallMastery;
    final totalSkills = progressSummary.totalSkills;
    final masteredSkills = progressSummary.masteredSkills;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmallText('Tiến độ tổng quan'),
            Gap(context.spacing.s12),
            // Circular Progress
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: overallMastery / 100,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                      ),
                      Text(
                        '${overallMastery.toInt()}%',
                        style: context.textStyle.headingSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(context.spacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatRow(context, 'Tổng kỹ năng', totalSkills.toString()),
                      Gap(context.spacing.s4),
                      _buildStatRow(context, 'Đã thành thạo', masteredSkills.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyle.bodySmall,
        ),
        Text(
          value,
          style: context.textStyle.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLearningCard(BuildContext context, recommendedSkill) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.padding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmallText('Học hôm nay'),
            Gap(context.spacing.s16),
            if (recommendedSkill.skillName != null) ...[
              Text(
                recommendedSkill.skillName!,
                style: context.textStyle.headingSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(context.spacing.s8),
            ],
            // Mastery level (if available)
            if (recommendedSkill.difficultyLevel != null) ...[
              Text(
                'Độ khó: ${_getDifficultyText(recommendedSkill.difficultyLevel!)}',
                style: context.textStyle.bodySmall,
              ),
              Gap(context.spacing.s8),
            ],
            if (recommendedSkill.recommendationReason != null) ...[
              Text(
                recommendedSkill.recommendationReason!,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.textSecondary,
                ),
              ),
              Gap(context.spacing.s16),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Navigate to practice question screen
                  if (recommendedSkill.skillId != null) {
                    context.push(
                      '${Routes.practiceQuestion}?skillId=${recommendedSkill.skillId}',
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                  minimumSize: const Size(0, 48),
                ),
                child: const Text('Bắt đầu học'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekProgressSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmallText('Tiến độ tuần'),
            Gap(context.spacing.s12),
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Color(0xFFFF9800)),
                Gap(context.spacing.s8),
                Text(
                  '5 ngày liên tiếp',
                  style: context.textStyle.body,
                ),
              ],
            ),
            Gap(context.spacing.s8),
            Text(
              '42 bài đã làm',
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined, size: 64, color: Color(0xFFBDBDBD)),
            Gap(context.spacing.s16),
            Text(
              'Chưa có lộ trình hôm nay',
              style: context.textStyle.headingSmall,
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s8),
            Text(
              'Hãy bắt đầu học để xem lộ trình của bạn!',
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s24),
            FilledButton(
              onPressed: () {
                ref.read(learningPlanProvider.notifier).loadTodayPlan();
              },
              child: const Text('Bắt đầu học'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFF44336)),
            Gap(context.spacing.s16),
            Text(
              'Không thể tải lộ trình học tập',
              style: context.textStyle.headingSmall,
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s8),
            Text(
              error.toString(),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s24),
            FilledButton(
              onPressed: () {
                ref.read(learningPlanProvider.notifier).loadTodayPlan();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Dễ';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Khá';
      case 4:
        return 'Khó';
      case 5:
        return 'Rất khó';
      default:
        return 'Trung bình';
    }
  }
}

