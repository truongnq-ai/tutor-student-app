import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/recommendation_entity.dart';
import '../../../../domain/entities/weak_skill_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../core/router/routes.dart';
import '../riverpod/progress_provider.dart';
import '../widgets/prerequisite_skill_card.dart';
import '../widgets/recommendation_item_card.dart';
import '../widgets/weak_skill_card.dart';

class RecommendationsPage extends ConsumerStatefulWidget {
  const RecommendationsPage({super.key});

  @override
  ConsumerState<RecommendationsPage> createState() =>
      _RecommendationsPageState();
}

class _RecommendationsPageState extends ConsumerState<RecommendationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recommendationsProvider.notifier).loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recommendationsState = ref.watch(recommendationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Gợi ý học tập'),
      ),
      body: recommendationsState.when(
        data: (recommendations) {
          if (recommendations == null) {
            return _buildEmptyState(context);
          }
          return _buildContent(context, recommendations);
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, RecommendationEntity recommendations) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(recommendationsProvider.notifier).loadRecommendations();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(context.padding.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dựa trên tiến độ học tập của bạn, chúng tôi gợi ý:',
                      style: context.textStyle.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Gap(context.spacing.s24),

            // Recommendations List
            if (recommendations.recommendations.isNotEmpty) ...[
              HeadingSmallText('Gợi ý'),
              Gap(context.spacing.s12),
              ...recommendations.recommendations.map((RecommendationItem item) => Padding(
                    padding: EdgeInsets.only(bottom: context.spacing.s12),
                    child: RecommendationItemCard(item: item),
                  )),
              Gap(context.spacing.s24),
            ],

            // Weak Skills Section
            if (recommendations.weakSkills.isNotEmpty) ...[
              HeadingSmallText('Kỹ năng cần cải thiện:'),
              Gap(context.spacing.s12),
              ...recommendations.weakSkills.map((WeakSkillEntity skill) => Padding(
                    padding: EdgeInsets.only(bottom: context.spacing.s12),
                    child: WeakSkillCard(skill: skill),
                  )),
              Gap(context.spacing.s24),
            ],

            // Prerequisites Section
            if (recommendations.prerequisites.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(context.padding.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber,
                          color: Color(0xFFFF9800),
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          'Bạn cần học kỹ năng cơ bản trước:',
                          style: context.textStyle.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF9800),
                          ),
                        ),
                      ],
                    ),
                    Gap(context.spacing.s12),
                    ...recommendations.prerequisites.map((PrerequisiteSkillItem prereq) => Padding(
                          padding: EdgeInsets.only(bottom: context.spacing.s8),
                          child: PrerequisiteSkillCard(
                            prerequisite: prereq,
                            onTap: () {
                              context.push(
                                '${Routes.progressSkillDetail}?skillId=${prereq.skillId}',
                              );
                            },
                          ),
                        )),
                  ],
                ),
              ),
              Gap(context.spacing.s24),
            ],

            // Next Steps
            if (recommendations.nextSteps.isNotEmpty) ...[
              HeadingSmallText('Bước tiếp theo:'),
              Gap(context.spacing.s12),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.padding.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...recommendations.nextSteps.asMap().entries.map((MapEntry<int, String> entry) {
                        final index = entry.key;
                        final step = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(bottom: context.spacing.s8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: context.color.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: context.textStyle.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Gap(context.spacing.s12),
                              Expanded(
                                child: Text(
                                  step,
                                  style: context.textStyle.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],

            // Empty state if no recommendations
            if (recommendations.recommendations.isEmpty &&
                recommendations.weakSkills.isEmpty &&
                recommendations.prerequisites.isEmpty &&
                recommendations.nextSteps.isEmpty) ...[
              Gap(context.spacing.s24),
              _buildEmptyRecommendationsState(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRecommendationsState(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          children: [
            Icon(
              Icons.celebration,
              size: 64,
              color: context.color.primary,
            ),
            Gap(context.spacing.s16),
            Text(
              'Không có gợi ý nào. Bạn đang học rất tốt!',
              style: context.textStyle.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.push(Routes.home);
                },
                icon: const Icon(Icons.home),
                label: const Text('Về trang chủ'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: context.padding.p12,
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Không tìm thấy gợi ý',
      description: 'Vui lòng thử lại sau',
      icon: Icons.lightbulb_outline,
      onAction: () {
        context.pop();
      },
      actionButtonText: 'Quay lại',
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    String errorMessage = _getUserFriendlyErrorMessage(context, error);
    String? description;

    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      description = context.locale.error_network_generic;
    }

    return ErrorStateWidget(
      title: 'Không thể tải gợi ý',
      description: description ?? errorMessage,
      onRetry: () {
        ref.read(recommendationsProvider.notifier).loadRecommendations();
      },
    );
  }

  String _getUserFriendlyErrorMessage(BuildContext context, Object error) {
    final errorString = error.toString();

    String message = errorString
        .replaceFirst('Exception: ', '')
        .replaceFirst('Error: ', '')
        .trim();

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
    if (message.toLowerCase().contains('not found') ||
        message.toLowerCase().contains('404')) {
      return 'Không tìm thấy gợi ý';
    }

    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }
}

