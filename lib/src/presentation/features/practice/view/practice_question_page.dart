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

class PracticeQuestionPage extends ConsumerStatefulWidget {
  final String? questionId;
  final String? skillId;
  final int? questionNumber;
  final int? totalQuestions;
  final String? sessionId;

  const PracticeQuestionPage({
    super.key,
    this.questionId,
    this.skillId,
    this.questionNumber,
    this.totalQuestions,
    this.sessionId,
  });

  @override
  ConsumerState<PracticeQuestionPage> createState() => _PracticeQuestionPageState();
}

class _PracticeQuestionPageState extends ConsumerState<PracticeQuestionPage> {
  String? _selectedAnswer;
  final TextEditingController _answerController = TextEditingController();
  bool _isMultipleChoice = false;
  DateTime? _startTime;
  int _wrongStreak = 0; // Track wrong streak for hint display

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    
    if (widget.questionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(currentQuestionProvider.notifier).loadQuestion(widget.questionId!);
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionState = ref.watch(currentQuestionProvider);
    final question = questionState.valueOrNull;

    // Determine if multiple choice based on answerOptions
    if (question != null && question.answerOptions != null && question.answerOptions!.isNotEmpty) {
      _isMultipleChoice = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.questionNumber != null && widget.totalQuestions != null)
              Text(
                'Câu ${widget.questionNumber}/${widget.totalQuestions}',
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.textSecondary,
                ),
              ),
          ],
        ),
      ),
      body: questionState.when(
        data: (question) {
          if (question == null) {
            return _buildEmptyState(context);
          }
          return _buildContent(context, question);
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, question) {
    final questionNumber = widget.questionNumber ?? question.questionNumber ?? 1;
    final totalQuestions = widget.totalQuestions ?? question.totalQuestions ?? 8;
    final progress = questionNumber / totalQuestions;
    final difficultyLevel = question.difficultyLevel ?? 3;
    final showHint = _wrongStreak >= 2 && question.hints != null && question.hints!.isNotEmpty;

    return Column(
      children: [
        // Progress Bar
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.padding.p16,
            vertical: context.padding.p8,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$questionNumber/$totalQuestions bài đã làm',
                    style: context.textStyle.bodySmall,
                  ),
                  _buildDifficultyBadge(context, difficultyLevel),
                ],
              ),
              Gap(context.spacing.s8),
              LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            ],
          ),
        ),

        // Question Card
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.padding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(context.padding.p20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (question.problemText != null)
                          Text(
                            question.problemText!,
                            style: context.textStyle.body.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (question.problemImageUrl != null) ...[
                          Gap(context.spacing.s16),
                          Image.network(
                            question.problemImageUrl!,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                Gap(context.spacing.s24),

                // Answer Section
                if (_isMultipleChoice && question.answerOptions != null)
                  _buildMultipleChoiceOptions(context, question.answerOptions!)
                else
                  _buildTextInput(context),

                Gap(context.spacing.s16),

                // Hint Button
                if (showHint)
                  OutlinedButton.icon(
                    onPressed: () {
                      _showHintDialog(context, question.hints!.first);
                    },
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('💡 Gợi ý'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Bottom Section
        Container(
          padding: EdgeInsets.all(context.padding.p16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              if (question.skillName != null)
                Text(
                  'Skill: ${question.skillName}',
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.textSecondary,
                  ),
                ),
              Gap(context.spacing.s8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedAnswer != null || _answerController.text.isNotEmpty
                      ? () => _onSubmitAnswer(context, question)
                      : null,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                    minimumSize: const Size(0, 56),
                  ),
                  child: ref.watch(practiceSubmissionProvider).isLoading
                      ? const LoadingIndicator()
                      : const Text('Kiểm tra'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyBadge(BuildContext context, int difficulty) {
    final (text, color) = _getDifficultyInfo(difficulty);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.padding.p12,
        vertical: context.padding.p8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        'Độ khó: $text',
        style: context.textStyle.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (String, Color) _getDifficultyInfo(int difficulty) {
    switch (difficulty) {
      case 1:
        return ('Dễ', const Color(0xFF4CAF50));
      case 2:
        return ('Trung bình', const Color(0xFF2196F3));
      case 3:
        return ('Trung bình', const Color(0xFFFF9800));
      case 4:
        return ('Khó', const Color(0xFFFF9800));
      case 5:
        return ('Rất khó', const Color(0xFFF44336));
      default:
        return ('Trung bình', const Color(0xFFFF9800));
    }
  }

  Widget _buildMultipleChoiceOptions(BuildContext context, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn đáp án:',
          style: context.textStyle.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(context.spacing.s12),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final letter = String.fromCharCode(65 + index); // A, B, C, D
          final isSelected = _selectedAnswer == option;

          return Padding(
            padding: EdgeInsets.only(bottom: context.spacing.s8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedAnswer = option;
                });
              },
              child: Container(
                padding: EdgeInsets.all(context.padding.p16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: context.textStyle.body.copyWith(
                            color: isSelected ? Colors.white : const Color(0xFF212121),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Gap(context.spacing.s12),
                    Expanded(
                      child: Text(
                        option,
                        style: context.textStyle.body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTextInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhập đáp án:',
          style: context.textStyle.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(context.spacing.s12),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            hintText: 'Nhập đáp án của bạn',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.all(context.padding.p12),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }

  Future<void> _onSubmitAnswer(BuildContext context, question) async {
    final answer = _selectedAnswer ?? _answerController.text.trim();
    if (answer.isEmpty) return;

    final duration = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : null;

    final success = await ref.read(practiceSubmissionProvider.notifier).submitPractice(
          skillId: question.skillId ?? widget.skillId ?? '',
          answer: answer,
          durationSec: duration,
          questionId: question.id,
        );

    if (success && mounted) {
      // Check if answer is correct
      final submittedQuestion = ref.read(practiceSubmissionProvider).value;
      final isCorrect = submittedQuestion?.isCorrect ?? false;

      if (!isCorrect) {
        _wrongStreak++;
      } else {
        _wrongStreak = 0;
      }

      // Navigate to result screen
      context.push(
        '${Routes.practiceResult}?questionId=${question.id}&isCorrect=$isCorrect',
      );
    } else if (mounted) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(practiceSubmissionProvider).error?.toString() ?? 'Có lỗi xảy ra',
          ),
        ),
      );
    }
  }

  void _showHintDialog(BuildContext context, String hint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💡 Gợi ý'),
        content: Text(hint),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.help_outline, size: 64, color: Color(0xFFBDBDBD)),
            Gap(context.spacing.s16),
            Text(
              'Không tìm thấy câu hỏi',
              style: context.textStyle.headingSmall,
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s24),
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Quay lại'),
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
              'Không thể tải câu hỏi',
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
                if (widget.questionId != null) {
                  ref.read(currentQuestionProvider.notifier).loadQuestion(widget.questionId!);
                }
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

