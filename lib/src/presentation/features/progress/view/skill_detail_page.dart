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
import '../../../../domain/entities/skill_detail_entity.dart';
import '../../../core/router/routes.dart';
import '../riverpod/progress_provider.dart';
import '../widgets/mastery_circle.dart';
import '../widgets/mastery_timeline.dart';
import '../widgets/skill_detail_prerequisite_card.dart';
import '../widgets/recent_practice_item.dart' as recent_practice;

class SkillDetailPage extends ConsumerStatefulWidget {
  final String? skillId;

  const SkillDetailPage({
    super.key,
    this.skillId,
  });

  @override
  ConsumerState<SkillDetailPage> createState() => _SkillDetailPageState();
}

class _SkillDetailPageState extends ConsumerState<SkillDetailPage> {
  String? _skillId;

  @override
  void initState() {
    super.initState();
    _skillId = widget.skillId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_skillId != null) {
        ref.read(skillDetailProvider(_skillId!).notifier).loadSkillDetail(
              skillId: _skillId!,
            );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get skillId from route parameters if not provided
    if (_skillId == null) {
      final uri = GoRouterState.of(context).uri;
      _skillId = uri.queryParameters['skillId'];
      if (_skillId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(skillDetailProvider(_skillId!).notifier).loadSkillDetail(
                skillId: _skillId!,
              );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_skillId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const HeadingSmallText('Chi tiết kỹ năng'),
        ),
        body: const Center(
          child: Text('Không tìm thấy skill ID'),
        ),
      );
    }

    final skillDetailState = ref.watch(skillDetailProvider(_skillId!));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Chi tiết kỹ năng'),
      ),
      body: skillDetailState.when(
        data: (skillDetail) {
          if (skillDetail == null) {
            return _buildEmptyState(context);
          }
          return _buildContent(context, skillDetail);
        },
        loading: () => const SkeletonList(itemCount: 5, itemHeight: 200),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SkillDetailEntity skillDetail) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(skillDetailProvider(_skillId!).notifier)
            .loadSkillDetail(skillId: _skillId!);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skill Header
            _buildSkillHeader(context, skillDetail),
            Gap(context.spacing.s24),

            // Mastery Display
            _buildMasteryDisplay(context, skillDetail),
            Gap(context.spacing.s24),

            // Progress Timeline
            Card(
              child: MasteryTimeline(
                timelineData: skillDetail.masteryTimeline,
              ),
            ),
            Gap(context.spacing.s24),

            // Recent Practices
            if (skillDetail.recentPractices.isNotEmpty) ...[
              HeadingSmallText('Bài tập gần đây'),
              Gap(context.spacing.s12),
              ...skillDetail.recentPractices.map((practice) {
                return recent_practice.RecentPracticeItemWidget(
                  practice: practice,
                  onTap: () {
                    // TODO: Navigate to practice review if needed
                  },
                );
              }),
              Gap(context.spacing.s24),
            ],

            // Prerequisites Section
            if (skillDetail.prerequisites.isNotEmpty) ...[
              HeadingSmallText('Kỹ năng cần có'),
              Gap(context.spacing.s8),
              Text(
                'Hãy học các kỹ năng này trước để hiểu rõ hơn về kỹ năng hiện tại',
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Gap(context.spacing.s12),
              ...skillDetail.prerequisites.map((prereq) {
                return Padding(
                  padding: EdgeInsets.only(bottom: context.spacing.s12),
                  child: SkillDetailPrerequisiteCard(prerequisite: prereq),
                );
              }),
              Gap(context.spacing.s24),
            ],

            // Action Buttons
            _buildActionButtons(context, skillDetail),
            Gap(context.spacing.s16),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillHeader(BuildContext context, SkillDetailEntity skillDetail) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              skillDetail.skillName,
              style: context.textStyle.headingMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(context.spacing.s4),
            Text(
              skillDetail.skillCode,
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.secondary,
              ),
            ),
            Gap(context.spacing.s8),
            Row(
              children: [
                Icon(
                  Icons.book,
                  size: 16,
                  color: context.color.text.secondary,
                ),
                Gap(context.spacing.s4),
                Text(
                  skillDetail.chapter,
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
                Gap(context.spacing.s16),
                Icon(
                  Icons.school,
                  size: 16,
                  color: context.color.text.secondary,
                ),
                Gap(context.spacing.s4),
                Text(
                  'Lớp ${skillDetail.grade}',
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryDisplay(
      BuildContext context, SkillDetailEntity skillDetail) {
    final statusText = _getStatusText(skillDetail.status);
    final statusColor = _getStatusColor(skillDetail.status);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          children: [
            // Mastery Circle
            MasteryCircle(
              masteryLevel: skillDetail.masteryLevel,
              size: 120,
              strokeWidth: 12,
            ),
            Gap(context.spacing.s16),

            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.padding.p12,
                vertical: context.padding.p4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: statusColor.withValues(alpha:0.3),
                  width: 1.5,
                ),
              ),
              child: Text(
                statusText,
                style: context.textStyle.bodyLarge.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(context.spacing.s12),

            // Description
            Text(
              'Bạn đã làm ${skillDetail.totalPractices} bài về kỹ năng này',
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, SkillDetailEntity skillDetail) {
    return Column(
      children: [
        // Practice More Button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              context.push(
                '${Routes.practiceQuestion}?skillId=${skillDetail.skillId}',
              );
            },
            icon: const Icon(Icons.assignment),
            label: const Text('Luyện tập thêm'),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: context.padding.p16,
              ),
            ),
          ),
        ),
        Gap(context.spacing.s12),

        // Mini Test Button (only if mastery >= 70%)
        if (skillDetail.canTakeMiniTest) ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.push(
                  '${Routes.miniTestStart}?skillId=${skillDetail.skillId}',
                );
              },
              icon: const Icon(Icons.quiz),
              label: const Text('Làm Mini Test'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: context.padding.p16,
                ),
                side: BorderSide(
                  color: context.color.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.padding.p16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.color.text.secondary.withValues(alpha:0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 20,
                  color: context.color.text.secondary,
                ),
                Gap(context.spacing.s8),
                Text(
                  'Đạt 70% mastery để làm Mini Test',
                  style: context.textStyle.bodyMedium.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Không tìm thấy thông tin kỹ năng',
      description: 'Vui lòng thử lại sau',
      icon: Icons.info_outline,
      onAction: () {
        context.pop();
      },
      actionButtonText: 'Quay lại',
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
      title: 'Không thể tải thông tin kỹ năng',
      description: description ?? errorMessage,
      onRetry: () {
        ref.read(skillDetailProvider(_skillId!).notifier).loadSkillDetail(
              skillId: _skillId!,
            );
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
    if (message.toLowerCase().contains('not found') ||
        message.toLowerCase().contains('404')) {
      return 'Không tìm thấy kỹ năng này';
    }

    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'weak':
        return 'Yếu';
      case 'improving':
        return 'Đang cải thiện';
      case 'mastered':
        return 'Thành thạo';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'weak':
        return const Color(0xFFF44336);
      case 'improving':
        return const Color(0xFFFF9800);
      case 'mastered':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

