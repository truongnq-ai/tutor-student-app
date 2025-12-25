import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/skeleton/skeleton_list.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/learning_plan_provider.dart';
import '../widgets/learning_card.dart';
import '../widgets/progress_indicator.dart';

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
                color: context.color.text.secondary,
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
        loading: () => const SkeletonList(itemCount: 3, itemHeight: 200),
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
            LearningCard(
              recommendedSkill: recommendedSkill,
              onStartLearning: () {
                if (recommendedSkill.skillId != null) {
                  context.push(
                    '${Routes.practiceQuestion}?skillId=${recommendedSkill.skillId}',
                  );
                }
              },
            ),
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
                CircularProgressWithLabel(
                  progress: overallMastery / 100,
                  size: 80,
                  strokeWidth: 8,
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
                color: context.color.text.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Chưa có lộ trình hôm nay',
      description: 'Hãy bắt đầu học để xem lộ trình của bạn!',
      icon: Icons.school_outlined,
      onAction: () {
        ref.read(learningPlanProvider.notifier).loadTodayPlan();
      },
      actionButtonText: 'Bắt đầu học',
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    // Extract user-friendly error message
    String errorMessage = _getUserFriendlyErrorMessage(error);
    String? description;

    // Check if it's a network error
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      description = 'Vui lòng kiểm tra kết nối internet và thử lại.';
    }

    return ErrorStateWidget(
      title: 'Không thể tải lộ trình học tập',
      description: description ?? errorMessage,
      onRetry: () {
        ref.read(learningPlanProvider.notifier).loadTodayPlan();
      },
    );
  }

  String _getUserFriendlyErrorMessage(Object error) {
    final errorString = error.toString();
    
    // Remove technical prefixes
    String message = errorString
        .replaceFirst('Exception: ', '')
        .replaceFirst('Error: ', '')
        .trim();

    // Map common error patterns to user-friendly messages
    if (message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('connection')) {
      return 'Không thể kết nối. Vui lòng kiểm tra internet.';
    }
    if (message.toLowerCase().contains('timeout')) {
      return 'Kết nối quá lâu. Vui lòng thử lại.';
    }
    if (message.toLowerCase().contains('401') ||
        message.toLowerCase().contains('unauthorized')) {
      return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
    }
    if (message.toLowerCase().contains('500') ||
        message.toLowerCase().contains('internal')) {
      return 'Lỗi hệ thống. Vui lòng thử lại sau.';
    }

    // Return original message if no mapping found, but limit length
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }

}

