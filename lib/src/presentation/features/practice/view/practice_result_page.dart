import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

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

  const PracticeResultPage({
    super.key,
    required this.questionId,
    required this.isCorrect,
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
        title: const HeadingSmallText('Kết quả'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result Indicator
            ResultIndicator(
              isCorrect: widget.isCorrect,
              message: widget.isCorrect ? 'Chính xác!' : 'Chưa đúng',
              encouragement: widget.isCorrect
                  ? 'Tuyệt vời!'
                  : 'Không sao, bạn đã học được điều gì đó!',
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
                        'Đáp án đúng: ${question!.finalAnswer}',
                        style: context.textStyle.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (question.problemText != null) ...[
                        Gap(context.spacing.s8),
                        Text(
                          'Giải thích: ${_getExplanation(question.problemText!, question.finalAnswer!)}',
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.textSecondary,
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
                message: '🎉 Độ khó sẽ tăng ở câu tiếp theo!',
              ),
              Gap(context.spacing.s24),
            ] else if (_streakWrong >= 2) ...[
              AdaptiveNotification(
                isDifficultyIncrease: false,
                message: '💡 Độ khó sẽ giảm để bạn dễ hiểu hơn',
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
                          '⚠️ Lưu ý: Hãy kiểm tra lại các bước giải của bạn',
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
                      'Đã làm: $completedQuestions/$totalQuestions bài',
                      style: context.textStyle.body,
                    ),
                    Text(
                      'Tiến độ: ${(progress * 100).toStringAsFixed(1)}%',
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.textSecondary,
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
                    final sessionQuestions = ref.read(questionSessionProvider(sessionId: widget.sessionId ?? '').notifier).state.value ?? [];
                    final correctCount = sessionQuestions.where((q) => q.isCorrect == true).length;
                    final wrongCount = sessionQuestions.length - correctCount;
                    
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Câu tiếp theo'),
                    Gap(8),
                    Icon(Icons.arrow_forward, size: 20),
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
                    child: const Text('Tạm dừng'),
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
                      child: const Text('Xem lại giải thích'),
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

  String _getExplanation(String problemText, String answer) {
    // Simple explanation - in real app, this would come from question data
    if (problemText.contains('Rút gọn')) {
      return 'Tìm ƯCLN của tử và mẫu, sau đó chia cả tử và mẫu cho ƯCLN đó.';
    }
    return 'Hãy xem lại các bước giải trong phần giải thích.';
  }

  void _showExplanationDialog(BuildContext context, question) {
    if (question == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Giải thích'),
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
                  'Đáp án: ${question.finalAnswer}',
                  style: context.textStyle.body,
                ),
              Gap(context.spacing.s12),
              Text(
                _getExplanation(question.problemText ?? '', question.finalAnswer ?? ''),
                style: context.textStyle.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}

