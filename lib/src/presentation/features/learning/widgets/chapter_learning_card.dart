import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/utils/error_message_mapper.dart';
import '../../../../domain/entities/learning_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../utils/learning_plan_utils.dart';

class ChapterLearningCard extends ConsumerStatefulWidget {
  final RecommendedChapterEntity recommendedChapter;

  const ChapterLearningCard({
    super.key,
    required this.recommendedChapter,
  });

  @override
  ConsumerState<ChapterLearningCard> createState() => _ChapterLearningCardState();
}

class _ChapterLearningCardState extends ConsumerState<ChapterLearningCard> {
  bool _isStartingLearning = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.padding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmallText(context.locale.learning_today_title),
            Gap(context.spacing.s16),
            if (widget.recommendedChapter.chapterName != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.book,
                    color: context.color.primary,
                    size: 24,
                  ),
                  Gap(context.spacing.s8),
                  Expanded(
                    child: Text(
                      widget.recommendedChapter.chapterName!,
                      style: context.textStyle.headingSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(context.spacing.s8),
            ],
            if (widget.recommendedChapter.difficultyLevel != null) ...[
              Text(
                context.locale.learning_difficulty_label(
                  _getDifficultyText(context, widget.recommendedChapter.difficultyLevel!),
                ),
                style: context.textStyle.bodySmall,
              ),
              Gap(context.spacing.s8),
            ],
            if (widget.recommendedChapter.recommendationReason != null) ...[
              Text(
                widget.recommendedChapter.recommendationReason!,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Gap(context.spacing.s12),
            ],
            // Skills to focus on
            if (widget.recommendedChapter.skills.isNotEmpty) ...[
              Text(
                context.locale.learning_plan_focus_on_skills,
                style: context.textStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(context.spacing.s8),
              ...widget.recommendedChapter.skills.map((skill) {
                return Padding(
                  padding: EdgeInsets.only(bottom: context.spacing.s4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: context.color.primary,
                      ),
                      Gap(context.spacing.s4),
                      Text(
                        skill.skillName ?? skill.skillCode ?? '',
                        style: context.textStyle.bodySmall,
                      ),
                    ],
                  ),
                );
              }),
              Gap(context.spacing.s16),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isStartingLearning
                    ? null
                    : () => _handleStartLearning(context, widget.recommendedChapter),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                  minimumSize: const Size(0, 48),
                ),
                child: _isStartingLearning
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(context.locale.common_button_start_learning),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyText(BuildContext context, int difficulty) {
    switch (difficulty) {
      case 1:
        return context.locale.difficulty_easy;
      case 2:
        return context.locale.difficulty_medium;
      case 3:
        return context.locale.difficulty_fair;
      case 4:
        return context.locale.difficulty_hard;
      case 5:
        return context.locale.difficulty_very_hard;
      default:
        return context.locale.difficulty_medium;
    }
  }

  Future<void> _handleStartLearning(
    BuildContext context,
    RecommendedChapterEntity recommendedChapter,
  ) async {
    // Use first skill in chapter for practice, or navigate to mini test if activity type is mini_test
    if (recommendedChapter.activityType == 'mini_test' && recommendedChapter.chapterId != null) {
      // Navigate to mini test
      context.push(
        '${Routes.miniTestStart}?chapterId=${recommendedChapter.chapterId}',
      );
      return;
    }

    // Default: start practice with first skill
    if (recommendedChapter.skills.isEmpty) {
      // Show error dialog instead of silent return
      if (context.mounted) {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.locale.learning_plan_error_load_failed),
            content: const Text('Chưa có bài tập cho chương này. Vui lòng thử lại sau.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.locale.common_button_ok),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Check if first skill has valid skillId
    final firstSkill = recommendedChapter.skills.first;
    if (firstSkill.skillId == null) {
      // Show error dialog for null skillId
      if (context.mounted) {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.locale.learning_plan_error_load_failed),
            content: const Text('Thông tin kỹ năng không hợp lệ. Vui lòng thử lại sau.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.locale.common_button_ok),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Calculate totalQuestions based on difficultyLevel
    final totalQuestions = LearningPlanUtils.calculateTotalQuestionsForLearningPlan(
      recommendedChapter.difficultyLevel ?? 2,
    );

    // Set loading state
    setState(() {
      _isStartingLearning = true;
    });

    try {
      // Create PracticeSession using repository directly
      final sessionRepository = ref.read(practiceSessionRepositoryProvider);
      final response = await sessionRepository.createSession(
        skillId: firstSkill.skillId!,
        totalQuestions: totalQuestions,
      );

      // Check if session creation was successful
      if (response.isSuccess && response.data != null) {
        final session = response.data!;
        final sessionId = session.sessionId;
        
        // Navigate to PracticeQuestionPage with sessionId
        if (context.mounted && sessionId.isNotEmpty) {
          context.push(
            '${Routes.practiceQuestion}?sessionId=$sessionId',
          );
        } else {
          // Session creation succeeded but no session ID
          if (context.mounted) {
            _showErrorDialog(
              context,
              context.locale.error_system_internal,
            );
          }
        }
      } else {
        // Session creation failed
        final errorMessage = response.getErrorMessage();
        if (context.mounted) {
          _showErrorDialog(
            context,
            errorMessage.isNotEmpty
                ? errorMessage
                : context.locale.error_system_internal,
          );
        }
      }
    } catch (e) {
      // Show error dialog (strict error handling)
      if (context.mounted) {
        _showErrorDialog(
          context,
          ErrorMessageMapper.getUserFriendlyMessage(context, e),
        );
      }
    } finally {
      // Reset loading state
      if (mounted) {
        setState(() {
          _isStartingLearning = false;
        });
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.locale.learning_plan_error_load_failed),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.locale.common_button_ok),
          ),
        ],
      ),
    );
  }
}

