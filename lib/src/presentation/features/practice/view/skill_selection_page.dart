import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/weak_skill_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/skeleton/skeleton_list.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/weak_skills_provider.dart';
import '../widgets/skill_card.dart';

class SkillSelectionPage extends ConsumerStatefulWidget {
  const SkillSelectionPage({super.key});

  @override
  ConsumerState<SkillSelectionPage> createState() => _SkillSelectionPageState();
}

class _SkillSelectionPageState extends ConsumerState<SkillSelectionPage> {
  String? _selectedSkillId;
  String? _selectedSkillName;

  @override
  Widget build(BuildContext context) {
    final weakSkillsState = ref.watch(weakSkillsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText(context.locale.practice_SkillSelectionTitle),
      ),
      body: weakSkillsState.when(
        data: (weakSkills) {
          if (weakSkills.isEmpty) {
            return _buildEmptyState(context, context.locale.practice_SkillSelectionNoWeakSkills);
          }
          return _buildContent(context, weakSkills);
        },
        loading: () => const SkeletonList(itemCount: 3, itemHeight: 100),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildContent(BuildContext context, List<WeakSkillEntity> weakSkills) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.practice_SkillSelectionDescription,
            style: context.textStyle.body.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(context.spacing.s24),

          // Skill cards from API
          ...weakSkills.map((skill) => Padding(
                padding: EdgeInsets.only(bottom: context.spacing.s12),
                child: SkillCard(
                  skillName: skill.skillName,
                  masteryLevel: skill.masteryLevel,
                  status: skill.status == 'weak' 
                      ? context.locale.practice_SkillStatusWeak 
                      : context.locale.practice_SkillStatusUnstable,
                  questionCount: skill.questionCount,
                  estimatedTime: context.locale.learning_SkillEstimatedTime(skill.estimatedTimeMinutes),
                  isSelected: _selectedSkillId == skill.skillId,
                  isPriority: skill.isPriority,
                  onTap: () {
                    setState(() {
                      _selectedSkillId = skill.skillId;
                      _selectedSkillName = skill.skillName;
                    });
                  },
                ),
              )),

          Gap(context.spacing.s24),

          // Info card
          Card(
            color: const Color(0xFFE3F2FD),
            child: Padding(
              padding: EdgeInsets.all(context.padding.p16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                  Gap(context.spacing.s12),
                  Expanded(
                    child: Text(
                      context.locale.practice_SkillSelectionInfo,
                      style: context.textStyle.bodySmall.copyWith(
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomButton(BuildContext context) {
    return Container(
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
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _selectedSkillId != null
              ? () {
                  // Navigate to practice question with selected skill
                  context.push(
                    '${Routes.practiceQuestion}?skillId=$_selectedSkillId&skillName=$_selectedSkillName',
                  );
                }
              : null,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: context.padding.p12),
            minimumSize: const Size(0, 56),
          ),
          child: Text(context.locale.common_ButtonStartLearning),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return EmptyStateWidget(
      title: message,
      icon: Icons.check_circle_outline,
      iconColor: const Color(0xFF4CAF50),
      onAction: () => context.go(Routes.todayLearningPlan),
      actionButtonText: context.locale.practice_SkillSelectionBackToHome,
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
      title: context.locale.practice_SkillSelectionLoadError,
      description: description ?? errorMessage,
      onRetry: () {
        ref.read(weakSkillsProvider.notifier).refresh();
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

    // Return original message if no mapping found, but limit length
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }
}

