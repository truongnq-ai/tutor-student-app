import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../../domain/entities/mini_test_result_entity.dart';
import '../../../core/router/routes.dart';
import '../riverpod/mini_test_provider.dart';
import '../widgets/result_header_card.dart';
import '../widgets/result_stat_card.dart';
import '../widgets/skill_breakdown_item.dart';

class MiniTestResultPage extends ConsumerStatefulWidget {
  final String? resultId;
  final String? sessionId;

  const MiniTestResultPage({
    super.key,
    this.resultId,
    this.sessionId,
  });

  @override
  ConsumerState<MiniTestResultPage> createState() =>
      _MiniTestResultPageState();
}

class _MiniTestResultPageState extends ConsumerState<MiniTestResultPage> {
  String? _resultId;
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _resultId = widget.resultId;
    _sessionId = widget.sessionId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resultId == null && _sessionId == null) {
      final uri = GoRouterState.of(context).uri;
      _resultId = uri.queryParameters['resultId'];
      _sessionId = uri.queryParameters['sessionId'];
    }

    // If we have sessionId but no resultId, submit test to get result
    if (_sessionId != null && _resultId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _submitTestAndGetResult();
      });
    }
  }

  Future<void> _submitTestAndGetResult() async {
    try {
      await ref.read(miniTestResultProvider.notifier).submitTest(_sessionId!);
      final resultState = ref.read(miniTestResultProvider);
      final result = resultState.valueOrNull;
      if (result != null) {
        setState(() {
          _resultId = result.resultId;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi lấy kết quả: ${e.toString()}'),
          ),
        );
      }
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return '$minutes phút $secs giây';
    }
    return '$secs giây';
  }

  @override
  Widget build(BuildContext context) {
    final resultState = ref.watch(miniTestResultProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Kết quả Mini Test'),
        automaticallyImplyLeading: false, // Disable back button
      ),
      body: resultState.when(
        data: (result) {
          if (result == null) {
            return _buildEmptyState(context);
          }
          return _buildContent(context, result);
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MiniTestResultEntity result) {
    final passed = result.passed;
    final score = result.score;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Result Header
          ResultHeaderCard(
            passed: passed,
            score: score,
          ),
          Gap(context.spacing.s16),

          // Summary Stats
          ResultStatCard(
            icon: Icons.quiz,
            label: 'Đúng',
            value: '${result.correctAnswers}/${result.totalQuestions} câu',
            iconColor: const Color(0xFF4CAF50),
          ),
          Gap(context.spacing.s12),
          ResultStatCard(
            icon: Icons.access_time,
            label: 'Thời gian',
            value: _formatTime(result.timeTakenSec),
            iconColor: const Color(0xFF2196F3),
          ),
          Gap(context.spacing.s12),
          ResultStatCard(
            icon: Icons.trending_up,
            label: 'Mastery',
            value: '${result.previousMasteryLevel}% → ${result.newMasteryLevel}%',
            iconColor: const Color(0xFFFF9800),
          ),
          Gap(context.spacing.s24),

          // Skills Breakdown
          if (result.skillBreakdown.isNotEmpty) ...[
            HeadingSmallText('Kỹ năng đã làm:'),
            Gap(context.spacing.s12),
            ...result.skillBreakdown.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: context.spacing.s12),
                  child: SkillBreakdownItemWidget(item: item),
                )),
            Gap(context.spacing.s24),
          ],

          // Recommendations
          if (result.recommendation.isNotEmpty) ...[
            Card(
              color: passed
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFF9E6),
              child: Padding(
                padding: EdgeInsets.all(context.padding.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          passed ? Icons.lightbulb : Icons.warning_amber,
                          color: passed
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFFF9800),
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          'Gợi ý',
                          style: context.textStyle.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(context.spacing.s8),
                    Text(
                      result.recommendation,
                      style: context.textStyle.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Gap(context.spacing.s24),
          ],

          // Actions
          if (passed) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  // Navigate to next skill or progress dashboard
                  context.push(Routes.progressDashboard);
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Học skill tiếp theo'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: context.padding.p16,
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ),
            Gap(context.spacing.s12),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  // Navigate to practice for this skill
                  context.push(
                    '${Routes.practiceQuestion}?skillId=${result.skillId}',
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Luyện tập lại'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: context.padding.p16,
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ),
            Gap(context.spacing.s12),
          ],

          OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to review screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tính năng xem lại bài làm đang được phát triển'),
                ),
              );
            },
            icon: const Icon(Icons.visibility),
            label: const Text('Xem lại bài làm'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: context.padding.p12,
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          Gap(context.spacing.s12),

          TextButton.icon(
            onPressed: () {
              context.push(Routes.home);
            },
            icon: const Icon(Icons.home),
            label: const Text('Về trang chủ'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: context.padding.p12,
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Không tìm thấy kết quả',
      description: 'Vui lòng thử lại sau',
      icon: Icons.quiz_outlined,
      onAction: () {
        context.push(Routes.progressDashboard);
      },
      actionButtonText: 'Về trang chủ',
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
      title: 'Không thể tải kết quả',
      description: description ?? errorMessage,
      onRetry: () {
        if (_sessionId != null) {
          _submitTestAndGetResult();
        } else if (_resultId != null) {
          ref.read(miniTestResultProvider.notifier).reset();
          // TODO: Load result by ID if needed
        }
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
      return 'Không tìm thấy kết quả';
    }

    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }
}

