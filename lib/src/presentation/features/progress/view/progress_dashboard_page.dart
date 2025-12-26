import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/skeleton/skeleton_list.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../../domain/entities/progress_dashboard_entity.dart';
import '../../../../domain/entities/weak_skill_entity.dart';
import '../../../core/router/routes.dart';
import '../riverpod/progress_provider.dart';
import '../widgets/progress_chart.dart';
import '../widgets/skill_card.dart';
import '../widgets/stat_card.dart';

class ProgressDashboardPage extends ConsumerStatefulWidget {
  const ProgressDashboardPage({super.key});

  @override
  ConsumerState<ProgressDashboardPage> createState() =>
      _ProgressDashboardPageState();
}

class _ProgressDashboardPageState
    extends ConsumerState<ProgressDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(progressDashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(progressDashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText('Tiến độ học tập'),
      ),
      body: dashboardState.when(
        data: (dashboard) {
          if (dashboard == null) {
            return _buildEmptyState(context);
          }
          return _buildContent(context, dashboard);
        },
        loading: () => const SkeletonList(itemCount: 5, itemHeight: 200),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, ProgressDashboardEntity dashboard) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(progressDashboardProvider.notifier).loadDashboard();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Card
            if (dashboard.streakDays > 0) ...[
              _buildStreakCard(context, dashboard.streakDays),
              Gap(context.spacing.s16),
            ],

            // Stats Cards
            _buildStatsSection(context, dashboard),
            Gap(context.spacing.s24),

            // Progress Chart
            Card(
              child: ProgressChart(
                progressData: dashboard.progressLast7Days,
              ),
            ),
            Gap(context.spacing.s24),

            // Skills Overview
            if (dashboard.skills.isNotEmpty) ...[
              HeadingSmallText('Tổng quan kỹ năng'),
              Gap(context.spacing.s12),
              ...dashboard.skills.take(5).map((skill) => Padding(
                    padding: EdgeInsets.only(bottom: context.spacing.s12),
                    child: SkillCard(
                      skill: skill,
                      onTap: () {
                        context.push(
                          '${Routes.progressSkillDetail}?skillId=${skill.skillId}',
                        );
                      },
                    ),
                  )),
              if (dashboard.skills.length > 5) ...[
                Gap(context.spacing.s8),
                TextButton(
                  onPressed: () {
                    // Navigate to full skills list
                  },
                  child: Text('Xem tất cả (${dashboard.skills.length})'),
                ),
              ],
              Gap(context.spacing.s24),
            ],

            // Weak Skills Section
            if (dashboard.weakSkills.isNotEmpty) ...[
              HeadingSmallText('Kỹ năng cần cải thiện'),
              Gap(context.spacing.s12),
              ...dashboard.weakSkills.map((weakSkill) => Padding(
                    padding: EdgeInsets.only(bottom: context.spacing.s12),
                    child: _buildWeakSkillCard(context, weakSkill),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, int streakDays) {
    return Card(
      color: const Color(0xFFFF9800),
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 32,
            ),
            Gap(context.spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streakDays ngày liên tiếp',
                    style: context.textStyle.headingSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Bạn đang duy trì chuỗi ngày học tập!',
                    style: context.textStyle.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha:0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(
      BuildContext context, ProgressDashboardEntity dashboard) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Tổng bài đã làm',
            value: '${dashboard.totalPractices}',
            icon: Icons.assignment,
            iconColor: const Color(0xFF2196F3),
          ),
        ),
        Gap(context.spacing.s12),
        Expanded(
          child: StatCard(
            title: 'Tỉ lệ đúng',
            value: '${dashboard.accuracyRate.toStringAsFixed(1)}%',
            icon: Icons.check_circle,
            iconColor: const Color(0xFF4CAF50),
          ),
        ),
        Gap(context.spacing.s12),
        Expanded(
          child: StatCard(
            title: 'Thời gian học',
            value: _formatTime(dashboard.totalTimeSec),
            icon: Icons.access_time,
            iconColor: const Color(0xFFFF9800),
          ),
        ),
      ],
    );
  }

  Widget _buildWeakSkillCard(BuildContext context, WeakSkillEntity weakSkill) {
    return Card(
      child: InkWell(
        onTap: () {
          context.push(
            '${Routes.progressSkillDetail}?skillId=${weakSkill.skillId}',
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(context.padding.p16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF44336).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    '${weakSkill.masteryLevel}%',
                    style: context.textStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF44336),
                    ),
                  ),
                ),
              ),
              Gap(context.spacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weakSkill.skillName,
                      style: context.textStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(context.spacing.s4),
                    Text(
                      weakSkill.skillCode,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                    Gap(context.spacing.s4),
                    Text(
                      '${weakSkill.questionCount} bài • ~${weakSkill.estimatedTimeMinutes} phút',
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.color.text.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Chưa có dữ liệu tiến độ',
      description: 'Hãy bắt đầu luyện tập để xem tiến độ của bạn',
      icon: Icons.trending_up,
      onAction: () {
        context.push(Routes.practiceQuestion);
      },
      actionButtonText: 'Bắt đầu luyện tập',
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    String errorMessage = _getUserFriendlyErrorMessage(context, error);
    String? description;

    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      description = context.locale.error_network_generic;
    }

    return ErrorStateWidget(
      title: 'Không thể tải tiến độ',
      description: description ?? errorMessage,
      onRetry: () {
        ref.read(progressDashboardProvider.notifier).loadDashboard();
      },
    );
  }

  String _getUserFriendlyErrorMessage(BuildContext context, Object error) {
    final errorString = error.toString();

    String message = errorString
        .replaceFirst('Exception: ', '')
        .replaceFirst('Error: ', '')
        .trim();

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

    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

