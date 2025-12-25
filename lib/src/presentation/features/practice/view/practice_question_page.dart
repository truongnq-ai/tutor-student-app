import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/skeleton/skeleton_question.dart';
import '../../../core/widgets/text/typography.dart';
import '../../learning/widgets/progress_indicator.dart';
import '../riverpod/practice_provider.dart';
import '../riverpod/question_provider.dart';
import '../widgets/difficulty_badge.dart';

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
                context.locale.practice_question_counter(widget.questionNumber!, widget.totalQuestions!),
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
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
        loading: () => const SkeletonQuestion(),
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
                    context.locale.practice_QuestionCounter(questionNumber, totalQuestions),
                    style: context.textStyle.bodySmall,
                  ),
                  DifficultyBadge(difficulty: difficultyLevel),
                ],
              ),
              Gap(context.spacing.s8),
              LinearProgressWithLabel(
                progress: progress,
                height: 4,
                label: context.locale.practice_QuestionProgress(questionNumber, totalQuestions),
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
                    label: Text(context.locale.practice_QuestionHint),
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
                  context.locale.practice_QuestionSkillLabel(question.skillName ?? ''),
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              Gap(context.spacing.s8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (ref.watch(practiceSubmissionProvider).isLoading ||
                          (_selectedAnswer == null && _answerController.text.isEmpty))
                      ? null
                      : () => _onSubmitAnswer(context, question),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                    minimumSize: const Size(0, 56),
                  ),
                  child: ref.watch(practiceSubmissionProvider).isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(context.locale.practice_QuestionCheck),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildMultipleChoiceOptions(BuildContext context, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.practice_QuestionSelectAnswer,
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
          context.locale.practice_QuestionEnterAnswer,
          style: context.textStyle.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(context.spacing.s12),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            hintText: context.locale.practice_QuestionAnswerHint,
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
            ref.read(practiceSubmissionProvider).error?.toString() ?? context.locale.error_Generic,
          ),
        ),
      );
    }
  }

  void _showHintDialog(BuildContext context, String hint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.locale.practice_QuestionHint),
        content: Text(hint),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.locale.common_ButtonClose),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: context.locale.practice_QuestionNotFound,
      icon: Icons.help_outline,
      onAction: () => context.pop(),
      actionButtonText: context.locale.common_ButtonBack,
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    // Extract user-friendly error message
    String errorMessage = _getUserFriendlyErrorMessage(error);
    String? description;

    // Check if it's a network error
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      description = context.locale.error_NetworkGeneric;
    }

    return ErrorStateWidget(
      title: context.locale.practice_QuestionLoadError,
      description: description ?? errorMessage,
      onRetry: () {
        if (widget.questionId != null) {
          ref.read(currentQuestionProvider.notifier).loadQuestion(widget.questionId!);
        } else if (widget.skillId != null) {
          // Try to reload from skill
          // This would need to be implemented in the provider
        }
      },
    );
  }

  String _getUserFriendlyErrorMessage(Object error) {
    final errorString = error.toString();
    
    // Remove technical prefixes
    String message = errorString
        .replaceFirst('Exception: ', '')
        .replaceFirst('Error: ', '')
        .trim();

    // Map common error patterns to user-friendly messages
    if (message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('connection')) {
      return context.locale.error_NetworkConnection;
    }
    if (message.toLowerCase().contains('timeout')) {
      return context.locale.error_NetworkTimeout;
    }
    if (message.toLowerCase().contains('401') ||
        message.toLowerCase().contains('unauthorized')) {
      return context.locale.error_AuthUnauthorized;
    }
    if (message.toLowerCase().contains('500') ||
        message.toLowerCase().contains('internal')) {
      return context.locale.error_SystemInternal;
    }
    if (message.toLowerCase().contains('not found') ||
        message.toLowerCase().contains('404')) {
      return context.locale.practice_QuestionNotFound;
    }

    // Return original message if no mapping found, but limit length
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }
}

