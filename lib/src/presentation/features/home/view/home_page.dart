import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/utils/error_message_mapper.dart';
import '../../../../domain/entities/learning_entity.dart';
import '../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/skeleton/skeleton_list.dart';
import '../../../core/widgets/text/typography.dart';
import '../../learning/riverpod/learning_plan_provider.dart';
import '../../learning/widgets/chapter_learning_card.dart';
import '../../learning/widgets/progress_indicator.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Load learning plan when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(learningPlanProvider.notifier).loadTodayPlan();
    });
    
    ref.listenManual(logoutProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value == true:
          context.pushReplacementNamed(Routes.login);
        case AsyncError(:final error):
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh learning plan when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      ref.read(learningPlanProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final learningPlanState = ref.watch(learningPlanProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
