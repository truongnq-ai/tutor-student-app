import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/session_info_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../../learning/widgets/progress_indicator.dart';
import '../riverpod/session_provider.dart';

class SessionResumePage extends ConsumerStatefulWidget {
  final String? sessionId;
  final String? skillId;
  final String? skillName;

  const SessionResumePage({
    super.key,
    this.sessionId,
    this.skillId,
    this.skillName,
  });

  @override
  ConsumerState<SessionResumePage> createState() => _SessionResumePageState();
}

class _SessionResumePageState extends ConsumerState<SessionResumePage> {
  @override
  Widget build(BuildContext context) {
    final sessionId = widget.sessionId ?? '';
    if (sessionId.isEmpty) {
      return _buildErrorState(context, 'Session ID không hợp lệ');
    }

    final sessionInfoState = ref.watch(sessionInfoProvider(sessionId: sessionId));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Tiếp tục luyện tập'),
      ),
      body: sessionInfoState.when(
        data: (sessionInfo) {
          if (sessionInfo == null) {
            return _buildErrorState(context, 'Không tìm thấy session');
          }
          return _buildContent(context, sessionInfo);
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SessionInfoEntity sessionInfo) {
    final progress = sessionInfo.totalQuestions > 0
        ? sessionInfo.completedQuestions / sessionInfo.totalQuestions
        : 0.0;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'vi');
    final nextQuestionNumber = sessionInfo.currentQuestionIndex + 1;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Info Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(context.padding.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sessionInfo.skillName != null) ...[
                    Text(
                      sessionInfo.skillName!,
                      style: context.textStyle.headingSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(context.spacing.s16),
                  ],
                  Text(
                    'Đã làm: ${sessionInfo.completedQuestions}/${sessionInfo.totalQuestions} bài',
                    style: context.textStyle.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(context.spacing.s12),
                  LinearProgressWithLabel(
                    progress: progress,
                    height: 8,
                  ),
                  Gap(context.spacing.s16),
                  if (sessionInfo.startedAt != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 16,
                          color: context.color.textSecondary,
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          'Bắt đầu: ${dateFormat.format(sessionInfo.startedAt!)}',
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Gap(context.spacing.s8),
                  ],
                  if (sessionInfo.lastActivityAt != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: context.color.textSecondary,
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          'Lần cuối: ${dateFormat.format(sessionInfo.lastActivityAt!)}',
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          Gap(context.spacing.s24),

          // Current Mastery
          if (sessionInfo.currentMastery != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(context.padding.p16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mastery hiện tại:',
                      style: context.textStyle.body,
                    ),
                    Text(
                      '${sessionInfo.currentMastery}%',
                      style: context.textStyle.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getMasteryColor(sessionInfo.currentMastery!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(context.spacing.s24),

            // Resume Options
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Navigate to next question
                  context.push(
                    '${Routes.practiceQuestion}?skillId=${sessionInfo.skillId}&questionNumber=$nextQuestionNumber&totalQuestions=${sessionInfo.totalQuestions}&sessionId=${sessionInfo.sessionId}',
                  );
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                  minimumSize: const Size(0, 56),
                ),
                child: Text('Tiếp tục từ câu $nextQuestionNumber'),
              ),
            ),

            Gap(context.spacing.s12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showRestartConfirmation(context, sessionInfo);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Bắt đầu lại từ đầu'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                  minimumSize: const Size(0, 48),
                  foregroundColor: const Color(0xFFFF9800),
                ),
              ),
            ),

            Gap(context.spacing.s24),

            // Discard Option
            Center(
              child: TextButton(
                onPressed: () {
                  _showDiscardConfirmation(context, sessionInfo);
                },
                child: Text(
                  'Bỏ session này',
                  style: context.textStyle.bodySmall.copyWith(
                    color: const Color(0xFFF44336),
                  ),
                ),
              ),
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
              'Không thể tải thông tin session',
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
                final sessionId = widget.sessionId ?? '';
                if (sessionId.isNotEmpty) {
                  ref.read(sessionInfoProvider(sessionId: sessionId).notifier).refresh();
                }
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMasteryColor(int mastery) {
    if (mastery >= 90) {
      return const Color(0xFF4CAF50);
    } else if (mastery >= 70) {
      return const Color(0xFF2196F3);
    } else if (mastery >= 40) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFF44336);
    }
  }

  void _showRestartConfirmation(BuildContext context, SessionInfoEntity sessionInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bắt đầu lại'),
        content: const Text(
          'Bạn có chắc muốn bắt đầu lại từ đầu? Tiến độ hiện tại sẽ bị mất.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Start new session
              context.push(
                '${Routes.practiceQuestion}?skillId=${sessionInfo.skillId}&questionNumber=1&totalQuestions=${sessionInfo.totalQuestions}',
              );
            },
            child: const Text('Bắt đầu lại'),
          ),
        ],
      ),
    );
  }

  void _showDiscardConfirmation(BuildContext context, SessionInfoEntity sessionInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bỏ session'),
        content: const Text(
          'Bạn có chắc muốn bỏ session này? Tiến độ sẽ bị mất.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Delete session from backend
              // Navigate back to home
              context.go(Routes.todayLearningPlan);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text('Bỏ session'),
          ),
        ],
      ),
    );
  }
}

