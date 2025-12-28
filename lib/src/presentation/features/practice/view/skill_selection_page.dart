import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/weak_skill_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when 80% scrolled
      if (!_isLoadingMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    try {
      await ref.read(weakSkillsProvider.notifier).loadMore();
    } catch (e) {
      // Handle error silently or show snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể tải thêm kỹ năng. Vui lòng thử lại.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final weakSkillsState = ref.watch(weakSkillsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText(context.locale.practice_skill_selection_title),
      ),
      body: weakSkillsState.when(
        data: (weakSkills) {
          if (weakSkills.isEmpty) {
            return _buildNewUserOnboarding(context);
          }
          return _buildContent(context, weakSkills);
        },
        loading: () => const SkeletonList(itemCount: 3, itemHeight: 100),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<WeakSkillEntity> weakSkills) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.practice_skill_selection_description,
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
                  description: skill.description,
                  chapterName: skill.chapterName,
                  masteryLevel: skill.masteryLevel,
                  status: skill.status == 'weak' 
                      ? context.locale.practice_skill_status_weak 
                      : context.locale.practice_skill_status_unstable,
                  questionCount: skill.questionCount,
                  estimatedTime: context.locale.learning_skill_estimated_time(skill.estimatedTimeMinutes),
                  isSelected: false,
                  isPriority: skill.isPriority,
                  onTap: () {
                    // Navigate directly to practice question page
                    context.push(
                      '${Routes.practiceQuestion}?skillId=${skill.skillId}&skillName=${skill.skillName}',
                    );
                  },
                ),
              )),

          // Loading indicator for load more
          if (_isLoadingMore)
            Padding(
              padding: EdgeInsets.all(context.padding.p16),
              child: const Center(child: CircularProgressIndicator()),
            ),

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
                      context.locale.practice_skill_selection_info,
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

  /// Build onboarding state for new users who haven't practiced yet
  Widget _buildNewUserOnboarding(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(context.spacing.s48),
          
          // Icon với background circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: context.color.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.school_outlined,
              size: 64,
              color: context.color.primary,
            ),
          ),
          
          Gap(context.spacing.s24),
          
          // Title
          HeadingLargeText(
            context.locale.practice_skill_selection_welcome_title,
            textAlign: TextAlign.center,
          ),
          
          Gap(context.spacing.s12),
          
          // Description
          Text(
            context.locale.practice_skill_selection_welcome_description,
            style: context.textStyle.body.copyWith(
              color: context.color.text.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          Gap(context.spacing.s32),
          
          // Primary CTA button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                context.push(Routes.todayLearningPlan);
              },
              icon: const Icon(Icons.arrow_forward),
              label: Text(context.locale.practice_skill_selection_welcome_cta),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: context.padding.p16),
                minimumSize: const Size(0, 56),
              ),
            ),
          ),
          
          Gap(context.spacing.s24),
          
          // Info card với tip
          Card(
            color: const Color(0xFFE3F2FD),
            child: Padding(
              padding: EdgeInsets.all(context.padding.p16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Color(0xFF2196F3)),
                  Gap(context.spacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.locale.practice_skill_selection_welcome_tip_title,
                          style: context.textStyle.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2196F3),
                          ),
                        ),
                        Gap(context.spacing.s4),
                        Text(
                          context.locale.practice_skill_selection_welcome_tip_description,
                          style: context.textStyle.bodySmall.copyWith(
                            color: const Color(0xFF2196F3),
                          ),
                        ),
                      ],
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
      description = context.locale.error_network_generic;
    }

    return ErrorStateWidget(
      title: context.locale.practice_skill_selection_load_error,
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

    // Return original message if no mapping found, but limit length
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }
}

