import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/utils/error_message_mapper.dart';
import '../../../../domain/entities/learning_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/skeleton/skeleton_list.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/learning_plan_provider.dart';
import '../widgets/chapter_learning_card.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when navigating back to this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(learningPlanProvider);
      if (currentState.hasValue) {
        ref.read(learningPlanProvider.notifier).refresh();
      }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.home);
            }
          },
        ),
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
    final recommendedChapter = learningPlan.recommendedChapter;
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
          if (recommendedChapter != null) ...[
            ChapterLearningCard(recommendedChapter: recommendedChapter),
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
    final masteryPercent = overallMastery.round();

    // Positive message based on mastery level
    String message;
    if (masteryPercent >= 80) {
      message = 'Tuyệt vời! Bạn đang tiến bộ rất tốt! 🎉';
    } else if (masteryPercent >= 60) {
      message = 'Tốt lắm! Tiếp tục cố gắng nhé! 💪';
    } else if (masteryPercent >= 40) {
      message = 'Đang tiến bộ! Hãy tiếp tục luyện tập! 📚';
    } else {
      message = 'Hãy bắt đầu học để cải thiện nhé! 🌱';
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmallText(context.locale.learning_plan_progress_overview_title),
            Gap(context.spacing.s12),
            // Circular Progress with positive message
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
                      Text(
                        message,
                        style: context.textStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(context.spacing.s4),
                      Text(
                        'Mức độ thành thạo: $masteryPercent%',
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
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
    // Use ErrorMessageMapper for consistent error messages
    final errorMessage = ErrorMessageMapper.getUserFriendlyMessage(context, error);
    final description = ErrorMessageMapper.getErrorDescription(context, error);

    return ErrorStateWidget(
      title: context.locale.learning_plan_error_load_failed,
      description: description ?? errorMessage,
      onRetry: () {
        ref.read(learningPlanProvider.notifier).loadTodayPlan();
      },
    );
  }
}
