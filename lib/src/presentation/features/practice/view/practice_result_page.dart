import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/practice_provider.dart';
import '../riverpod/question_provider.dart';
import '../widgets/adaptive_notification.dart';
import '../widgets/mastery_progress_bar.dart';
import '../widgets/result_indicator.dart';

class PracticeResultPage extends ConsumerStatefulWidget {
  final String questionId;
  final bool isCorrect;
  final int? questionNumber;
  final int? totalQuestions;
  final String? sessionId;

  const PracticeResultPage({
    super.key,
    required this.questionId,
    required this.isCorrect,
    this.questionNumber,
    this.totalQuestions,
    this.sessionId,
  });

  @override
  ConsumerState<PracticeResultPage> createState() => _PracticeResultPageState();
}

class _PracticeResultPageState extends ConsumerState<PracticeResultPage> {
  int? _previousMastery;
  int? _currentMastery;
  int _streakCorrect = 0;
  int _streakWrong = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestionData();
  }

  Future<void> _loadQuestionData() async {
    // Load question to get mastery info
    final question = ref.read(currentQuestionProvider).valueOrNull;
    // TODO: Get mastery from practice submission response
    // For now, simulate mastery change
    _previousMastery = 45;
    _currentMastery = widget.isCorrect ? 52 : 40;

    // Calculate streaks (this would come from practice history)
    if (widget.isCorrect) {
      _streakCorrect = 1; // Would be calculated from session
      _streakWrong = 0;
    } else {
      _streakCorrect = 0;
      _streakWrong = 1; // Would be calculated from session
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = ref.read(currentQuestionProvider).valueOrNull;
    final practiceResponse = ref.read(practiceSubmissionProvider).valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeadingSmallText(context.locale.practice_result_title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result Indicator
            ResultIndicator(
              isCorrect: widget.isCorrect,
              message: widget.isCorrect
                  ? context.locale.practice_result_correct
                  : context.locale.practice_result_incorrect,
              encouragement: widget.isCorrect
                  ? context.locale.practice_result_encouragement_correct
                  : context.locale.practice_result_encouragement_incorrect,
            ),

            Gap(context.spacing.s24),

            // Correct Answer Display
            if (!widget.isCorrect && question?.finalAnswer != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.padding.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.practice_result_correct_answer(question!.finalAnswer!),
                        style: context.textStyle.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (question.problemText != null) ...[
                        Gap(context.spacing.s8),
                        Text(
                          context.locale.practice_result_explanation_label(
                            _getExplanation(context, question.problemText!, question.finalAnswer!),
                          ),
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.text.secondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Gap(context.spacing.s24),
            ],

            // Mastery Update
            if (_previousMastery != null && _currentMastery != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.padding.p16),
                  child: MasteryProgressBar(
                    currentMastery: _currentMastery!,
                    previousMastery: _previousMastery,
                  ),
                ),
              ),
              Gap(context.spacing.s24),
            ],

            // Adaptive Difficulty Notification
            if (_streakCorrect >= 5) ...[
              AdaptiveNotification(
                isDifficultyIncrease: true,
                message: context.locale.practice_result_difficulty_increase_notification,
              ),
              Gap(context.spacing.s24),
            ] else if (_streakWrong >= 2) ...[
              AdaptiveNotification(
                isDifficultyIncrease: false,
                message: context.locale.practice_result_difficulty_decrease_notification,
              ),
              Gap(context.spacing.s24),
            ],

            // Common Mistakes (if wrong)
            if (!widget.isCorrect) ...[
              Card(
                color: const Color(0xFFFFF9E6),
                child: Padding(
                  padding: EdgeInsets.all(context.padding.p16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFFF9800),
                      ),
                      Gap(context.spacing.s12),
                      Expanded(
                        child: Text(
                          context.locale.practice_result_warning_check_steps,
                          style: context.textStyle.bodySmall.copyWith(
                            color: const Color(0xFFFF9800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(context.spacing.s24),
            ],

            // Session Progress
            Card(
              child: Padding(
                padding: EdgeInsets.all(context.padding.p16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.locale.practice_result_progress_done(
                        widget.questionNumber ?? 1,
                        widget.totalQuestions ?? 8,
                      ),
                      style: context.textStyle.body,
                    ),
                    Text(
                      context.locale.practice_result_progress_percentage(
                        ((widget.questionNumber ?? 1) / (widget.totalQuestions ?? 8) * 100).toStringAsFixed(1),
                      ),
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Gap(context.spacing.s24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Check if this is the last question
                  final questionNumber = widget.questionNumber ?? 1;
                  final totalQuestions = widget.totalQuestions ?? 8;
                  
                  if (questionNumber >= totalQuestions) {
                    // Navigate to session complete
                    // Calculate session stats from all questions in session
                    // TODO: Get session questions from provider when available
                    final correctCount = widget.isCorrect ? 1 : 0;
                    final wrongCount = widget.isCorrect ? 0 : 1;
                    
                    context.pushReplacement(
                      '${Routes.practiceSessionComplete}?'
                      'totalQuestions=$totalQuestions&'
                      'correctCount=$correctCount&'
                      'wrongCount=$wrongCount&'
                      'previousMastery=${_previousMastery ?? 0}&'
                      'currentMastery=${_currentMastery ?? 0}&'
                      'skillName=${Uri.encodeComponent(question?.skillName ?? "")}&'
                      'skillId=${question?.skillId ?? ""}',
                    );
                  } else {
                    // Navigate to next question
                    final nextQuestionNumber = questionNumber + 1;
                    context.pushReplacement(
                      '${Routes.practiceQuestion}?'
                      'questionNumber=$nextQuestionNumber&'
                      'totalQuestions=$totalQuestions&'
                      'skillId=${question?.skillId ?? ""}',
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                  minimumSize: const Size(0, 56),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.locale.practice_result_action_next_question),
                    const Gap(8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),

            Gap(context.spacing.s12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Pause session
                      context.push(Routes.sessionResume);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                      minimumSize: const Size(0, 48),
                    ),
                    child: Text(context.locale.practice_result_action_pause),
                  ),
                ),
                if (!widget.isCorrect) ...[
                  Gap(context.spacing.s12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Show explanation
                        _showExplanationDialog(context, question);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                        minimumSize: const Size(0, 48),
                      ),
                      child: Text(context.locale.practice_result_action_review_explanation),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getExplanation(BuildContext context, String problemText, String answer) {
    // Simple explanation - in real app, this would come from question data
    if (problemText.contains('Rút gọn')) {
      return 'Tìm ƯCLN của tử và mẫu, sau đó chia cả tử và mẫu cho ƯCLN đó.';
    }
    return context.locale.practice_result_explanation_generic;
  }

  void _showExplanationDialog(BuildContext context, question) {
    if (question == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.locale.practice_result_explanation_dialog_title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (question.problemText != null)
                Text(
                  question.problemText!,
                  style: context.textStyle.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Gap(context.spacing.s12),
              if (question.finalAnswer != null)
                Text(
                  context.locale.practice_result_explanation_dialog_answer_label(question.finalAnswer!),
                  style: context.textStyle.body,
                ),
              Gap(context.spacing.s12),
              Text(
                _getExplanation(context, question.problemText ?? '', question.finalAnswer ?? ''),
                style: context.textStyle.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.locale.common_button_close),
          ),
        ],
      ),
    );
  }
}

