import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../../onboarding/riverpod/trial_provider.dart';
import '../riverpod/tutor_provider.dart';

class TutorModeEntryPage extends ConsumerStatefulWidget {
  const TutorModeEntryPage({super.key});

  @override
  ConsumerState<TutorModeEntryPage> createState() => _TutorModeEntryPageState();
}

class _TutorModeEntryPageState extends ConsumerState<TutorModeEntryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load trial status for rate limit
      ref.read(trialProvider.notifier).getTrialStatus();
      // Load recent problems
      ref.read(recentProblemsProvider.notifier).loadRecentProblems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trialState = ref.watch(trialProvider);
    final recentProblemsState = ref.watch(recentProblemsProvider);
    final trialStatus = trialState.valueOrNull;

    // Calculate rate limit info
    final solvesToday = trialStatus?.solvesToday ?? 0;
    final maxSolvesPerDay = trialStatus?.maxSolvesPerDay ?? 5;
    final remainingSolves = maxSolvesPerDay - solvesToday;
    final isRateLimitExceeded = remainingSolves <= 0;
    final showWarning = remainingSolves <= 1 && remainingSolves > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmallText('Giải bài Toán'),
            Text(
              'Chụp ảnh hoặc nhập đề bài',
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rate limit indicator
            if (trialStatus != null) _buildRateLimitIndicator(
              context,
              solvesToday,
              maxSolvesPerDay,
              remainingSolves,
              showWarning,
            ),
            Gap(context.spacing.s24),

            // Input method selection cards
            _buildInputMethodCards(context, isRateLimitExceeded),
            Gap(context.spacing.s24),

            // Recent problems section
            _buildRecentProblemsSection(context, recentProblemsState),
          ],
        ),
      ),
    );
  }

  Widget _buildRateLimitIndicator(
    BuildContext context,
    int solvesToday,
    int maxSolvesPerDay,
    int remainingSolves,
    bool showWarning,
  ) {
    final progress = solvesToday / maxSolvesPerDay;

    return Semantics(
      label: 'Số lượt giải hôm nay: $solvesToday/$maxSolvesPerDay',
      child: Container(
        padding: EdgeInsets.all(context.padding.p16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Số lượt giải hôm nay: $solvesToday/$maxSolvesPerDay',
                  style: context.textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (remainingSolves > 0)
                  Text(
                    'Còn $remainingSolves lượt',
                    style: context.textStyle.bodySmall.copyWith(
                      color: const Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            Gap(context.spacing.s12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 0.8
                      ? const Color(0xFFFF9800)
                      : const Color(0xFF4CAF50),
                ),
              ),
            ),
            if (showWarning) ...[
              Gap(context.spacing.s12),
              Container(
                padding: EdgeInsets.all(context.padding.p12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFF9800),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFFF9800),
                      size: 20,
                    ),
                    Gap(context.spacing.s8),
                    Expanded(
                      child: Text(
                        '⚠️ Còn $remainingSolves lượt. Hãy liên kết với phụ huynh để tiếp tục!',
                        style: context.textStyle.bodySmall.copyWith(
                          color: const Color(0xFFFF9800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputMethodCards(
    BuildContext context,
    bool isRateLimitExceeded,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Camera card
        Semantics(
          label: 'Chụp ảnh đề bài',
          child: _InputMethodCard(
            icon: Icons.camera_alt,
            iconColor: const Color(0xFF2196F3),
            title: '📷 Chụp ảnh',
            description: 'Chụp đề bài từ sách vở',
            buttonText: 'Chụp ảnh',
            onTap: isRateLimitExceeded
                ? null
                : () {
                    context.push(Routes.tutorCameraCapture);
                  },
          ),
        ),
        Gap(context.spacing.s16),
        // Text input card
        Semantics(
          label: 'Nhập văn bản đề bài',
          child: _InputMethodCard(
            icon: Icons.keyboard,
            iconColor: const Color(0xFF4CAF50),
            title: '✏️ Nhập văn bản',
            description: 'Gõ đề bài trực tiếp',
            buttonText: 'Nhập đề bài',
            onTap: isRateLimitExceeded
                ? null
                : () {
                    context.push(Routes.tutorTextInput);
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentProblemsSection(
    BuildContext context,
    AsyncValue<Map<String, dynamic>?> recentProblemsState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đề bài gần đây',
          style: context.textStyle.headingMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(context.spacing.s16),
        recentProblemsState.when(
          data: (data) {
            if (data == null || data['content'] == null) {
              return _buildEmptyRecentProblems(context);
            }

            final content = data['content'] as List<dynamic>?;
            if (content == null || content.isEmpty) {
              return _buildEmptyRecentProblems(context);
            }

            return Column(
              children: content.take(5).map((problem) {
                return _RecentProblemCard(
                  problem: problem as Map<String, dynamic>,
                  onTap: () {
                    // Navigate to solution view
                    final problemId = problem['id'] as String?;
                    if (problemId != null) {
                      // TODO: Navigate to solution step-by-step screen
                      // context.push('${Routes.tutorSolution}?problemId=$problemId');
                    }
                  },
                );
              }).toList(),
            );
          },
          loading: () => const LoadingIndicator(),
          error: (error, stackTrace) => _buildEmptyRecentProblems(context),
        ),
      ],
    );
  }

  Widget _buildEmptyRecentProblems(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.padding.p24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Bạn chưa giải bài nào',
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
      ),
    );
  }
}

class _InputMethodCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onTap;

  const _InputMethodCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(context.padding.p20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: isDisabled ? Colors.grey : iconColor,
                  ),
                ),
                Gap(context.spacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: context.textStyle.headingSmall.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? Colors.grey : null,
                        ),
                      ),
                      Gap(context.spacing.s4),
                      Text(
                        description,
                        style: context.textStyle.bodyMedium.copyWith(
                          fontSize: 14,
                          color: isDisabled
                              ? Colors.grey
                              : context.color.text.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDisabled ? Colors.grey : iconColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentProblemCard extends StatelessWidget {
  final Map<String, dynamic> problem;
  final VoidCallback onTap;

  const _RecentProblemCard({
    required this.problem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final problemText = problem['problemText'] as String? ?? '';
    final finalAnswer = problem['finalAnswer'] as String?;
    final solvedAt = problem['solvedAt'] as String?;

    return Semantics(
      label: 'Đề bài: $problemText',
      child: Container(
        margin: EdgeInsets.only(bottom: context.spacing.s12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(context.padding.p16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problemText.length > 50
                              ? '${problemText.substring(0, 50)}...'
                              : problemText,
                          style: context.textStyle.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (finalAnswer != null) ...[
                          Gap(context.spacing.s4),
                          Text(
                            'Đáp án: $finalAnswer',
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                          ),
                        ],
                        if (solvedAt != null) ...[
                          Gap(context.spacing.s4),
                          Text(
                            solvedAt,
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF757575),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

