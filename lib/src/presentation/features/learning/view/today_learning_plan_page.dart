import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/learning_entity.dart';
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
            HeadingSmallText(context.locale.learning_plan_today_title),
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

  Widget _buildContent(
      BuildContext context, LearningPlanEntity learningPlan) {
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

  Widget _buildProgressSummaryCard(
      BuildContext context, ProgressSummaryEntity progressSummary) {
    final overallMastery = progressSummary.overallMastery;
    final totalSkills = progressSummary.totalSkills;
    final masteredSkills = progressSummary.masteredSkills;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmallText(context.locale.learning_plan_progress_overview_title),
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
                      _buildStatRow(
                        context,
                        context.locale.learning_plan_stat_total_skills,
                        totalSkills.toString(),
                      ),
                      Gap(context.spacing.s4),
                      _buildStatRow(
                        context,
                        context.locale.learning_plan_stat_mastered_skills,
                        masteredSkills.toString(),
                      ),
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
            HeadingSmallText(context.locale.learning_plan_week_progress_title),
            Gap(context.spacing.s12),
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Color(0xFFFF9800)),
                Gap(context.spacing.s8),
                Text(
                  context.locale.learning_plan_week_streak(5),
                  style: context.textStyle.body,
                ),
              ],
            ),
            Gap(context.spacing.s8),
            Text(
              context.locale.learning_plan_week_exercises_done(42),
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
      title: context.locale.learning_plan_empty_title,
      description: context.locale.learning_plan_empty_description,
      icon: Icons.school_outlined,
      onAction: () {
        ref.read(learningPlanProvider.notifier).loadTodayPlan();
      },
      actionButtonText: context.locale.common_button_start_learning,
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    // Extract user-friendly error message
    String errorMessage = _getUserFriendlyErrorMessage(context, error);
    String? description;

    // Check if it's a network error
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      description = context.locale.error_network_generic;
    }

    return ErrorStateWidget(
      title: context.locale.learning_plan_error_load_failed,
      description: description ?? errorMessage,
      onRetry: () {
        ref.read(learningPlanProvider.notifier).loadTodayPlan();
      },
    );
  }

  String _getUserFriendlyErrorMessage(BuildContext context, Object error) {
    final errorString = error.toString();
    
    // Remove technical prefixes
    String message = errorString
        .replaceFirst('Exception: ', '')
        .replaceFirst('Error: ', '')
        .trim();

    // Map common error patterns to user-friendly messages
    if (message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('connection')) {
      return context.locale.error_network_connection;
    }
    if (message.toLowerCase().contains('timeout')) {
      return context.locale.error_network_timeout;
    }
    if (message.toLowerCase().contains('401') ||
        message.toLowerCase().contains('unauthorized')) {
      return context.locale.error_auth_unauthorized;
    }
    if (message.toLowerCase().contains('500') ||
        message.toLowerCase().contains('internal')) {
      return context.locale.error_system_internal;
    }

    // Return original message if no mapping found, but limit length
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }

}

