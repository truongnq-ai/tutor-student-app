import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/session_info_entity.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/error_state_widget.dart';
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
      return _buildErrorState(context, context.locale.practice_session_error_invalid_id);
    }

    final sessionInfoState = ref.watch(sessionInfoProvider(sessionId: sessionId));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText(context.locale.practice_session_resume_title),
      ),
      body: sessionInfoState.when(
        data: (sessionInfo) {
          if (sessionInfo == null) {
            return _buildErrorState(context, context.locale.practice_session_error_not_found);
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
                    context.locale.practice_session_progress_done(
                      sessionInfo.completedQuestions,
                      sessionInfo.totalQuestions,
                    ),
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
                          color: context.color.text.secondary,
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          context.locale.practice_session_started_at(
                            dateFormat.format(sessionInfo.startedAt!),
                          ),
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.text.secondary,
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
                          color: context.color.text.secondary,
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          context.locale.practice_session_last_activity(
                            dateFormat.format(sessionInfo.lastActivityAt!),
                          ),
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.text.secondary,
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
                      context.locale.practice_session_current_mastery,
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
                child: Text(
                  context.locale.practice_session_continue_from_question(nextQuestionNumber),
                ),
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
                label: Text(context.locale.practice_session_restart_from_beginning),
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
                  context.locale.practice_session_discard_session,
                  style: context.textStyle.bodySmall.copyWith(
                    color: const Color(0xFFF44336),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    // Extract user-friendly error message
    String errorMessage = _getUserFriendlyErrorMessage(context, error);
    String? description;

    // Check if it's a network error or session expired
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      description = context.locale.error_network_generic;
    } else if (errorString.contains('expired') ||
        errorString.contains('not found') ||
        errorString.contains('404')) {
      description = context.locale.practice_session_error_expired_message;
    }

    return ErrorStateWidget(
      title: context.locale.practice_session_error_load_failed,
      description: description ?? errorMessage,
      onRetry: () {
        final sessionId = widget.sessionId ?? '';
        if (sessionId.isNotEmpty) {
          ref.read(sessionInfoProvider(sessionId: sessionId).notifier).refresh();
        }
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
    if (message.toLowerCase().contains('expired') ||
        message.toLowerCase().contains('not found') ||
        message.toLowerCase().contains('404')) {
      return context.locale.practice_session_error_expired;
    }

    // Return original message if no mapping found, but limit length
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
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
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.locale.practice_session_restart_dialog_title),
        content: Text(
          context.locale.practice_session_restart_dialog_message,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.locale.common_button_cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Start new session
              context.push(
                '${Routes.practiceQuestion}?skillId=${sessionInfo.skillId}&questionNumber=1&totalQuestions=${sessionInfo.totalQuestions}',
              );
            },
            child: Text(context.locale.practice_session_restart_dialog_button),
          ),
        ],
      ),
    );
  }

  void _showDiscardConfirmation(BuildContext context, SessionInfoEntity sessionInfo) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.locale.practice_session_discard_dialog_title),
        content: Text(
          context.locale.practice_session_discard_dialog_message,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.locale.common_button_cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Cancel session from backend
              final success = await ref
                  .read(sessionInfoProvider(sessionId: sessionInfo.sessionId).notifier)
                  .cancelSession(sessionInfo.sessionId);
              if (mounted) {
                if (success) {
                  // Navigate back to home
                  context.go(Routes.todayLearningPlan);
                } else {
                  // Show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.locale.practice_session_error_cancel_failed),
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: Text(context.locale.practice_session_discard_dialog_button),
          ),
        ],
      ),
    );
  }
}

