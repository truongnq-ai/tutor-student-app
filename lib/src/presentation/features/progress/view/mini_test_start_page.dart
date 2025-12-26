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
import '../../../../domain/entities/skill_detail_entity.dart';
import '../../../core/router/routes.dart';
import '../riverpod/mini_test_provider.dart';
import '../riverpod/progress_provider.dart';
import '../widgets/mastery_circle.dart';
import '../widgets/test_detail_card.dart';
import '../widgets/test_instructions_card.dart';
import '../widgets/unlock_celebration_card.dart';

class MiniTestStartPage extends ConsumerStatefulWidget {
  final String? skillId;

  const MiniTestStartPage({
    super.key,
    this.skillId,
  });

  @override
  ConsumerState<MiniTestStartPage> createState() =>
      _MiniTestStartPageState();
}

class _MiniTestStartPageState extends ConsumerState<MiniTestStartPage> {
  String? _skillId;
  bool _isStarting = false;

  @override
  void initState() {
    super.initState();
    _skillId = widget.skillId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_skillId != null) {
        _checkUnlockStatus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_skillId == null) {
      final uri = GoRouterState.of(context).uri;
      _skillId = uri.queryParameters['skillId'];
      if (_skillId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkUnlockStatus();
        });
      }
    }
  }

  void _checkUnlockStatus() {
    ref.read(miniTestUnlockProvider(_skillId!).notifier).refresh(_skillId!);
  }

  Future<void> _handleStartTest() async {
    if (_skillId == null || _isStarting) return;

    setState(() {
      _isStarting = true;
    });

    try {
      // Start test using provider
      final provider = ref.read(miniTestSessionProvider(null).notifier);
      await provider.startTest(skillId: _skillId!);

      // Wait a bit for state to update, then check
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Get the session from provider state
      final sessionState = ref.read(miniTestSessionProvider(null));
      final session = sessionState.valueOrNull;

      if (session != null && mounted) {
        context.push(
          '${Routes.miniTestQuestion}?sessionId=${session.sessionId}',
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể bắt đầu bài test. Vui lòng thử lại.'),
          ),
        );
        setState(() {
          _isStarting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isStarting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_skillId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const HeadingSmallText('Mini Test'),
        ),
        body: const Center(
          child: Text('Không tìm thấy skill ID'),
        ),
      );
    }

    final unlockState = ref.watch(miniTestUnlockProvider(_skillId!));
    final skillDetailState = ref.watch(skillDetailProvider(_skillId!));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Mini Test'),
      ),
      body: unlockState.when(
        data: (isUnlocked) {
          return skillDetailState.when(
            data: (skillDetail) {
              if (skillDetail == null) {
                return _buildEmptyState(context);
              }
              return _buildContent(context, isUnlocked, skillDetail);
            },
            loading: () => const Center(child: LoadingIndicator()),
            error: (error, stackTrace) => _buildErrorState(context, error),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isUnlocked,
    SkillDetailEntity skillDetail,
  ) {
    // Get skill info
    final skillName = skillDetail.skillName;
    final skillCode = skillDetail.skillCode;
    final masteryLevel = skillDetail.masteryLevel;
    final chapter = skillDetail.chapter;

    // Test constants
    const totalQuestions = 6;
    const timeLimitMinutes = 10;
    const passingScore = 70;
    const requiredPracticeCount = 10;

    // Skills to test (main skill + prerequisites if any)
    final skillsToTest = [
      skillName,
      if (skillDetail.prerequisites.isNotEmpty)
        ...skillDetail.prerequisites
            .map((p) => p.skillName)
            .take(2), // Limit to 2 prerequisites
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill Info Card
          _buildSkillInfoCard(context, skillName, skillCode, chapter, masteryLevel),
          Gap(context.spacing.s16),

          // Unlock Celebration (if just unlocked)
          if (isUnlocked) ...[
            UnlockCelebrationCard(
              practiceCount: requiredPracticeCount,
              requiredCount: requiredPracticeCount,
            ),
            Gap(context.spacing.s16),
          ],

          // Test Details Card
          TestDetailCard(
            totalQuestions: totalQuestions,
            timeLimitMinutes: timeLimitMinutes,
            passingScore: passingScore,
          ),
          Gap(context.spacing.s16),

          // Instructions Card
          TestInstructionsCard(
            skillsToTest: skillsToTest,
          ),
          Gap(context.spacing.s24),

          // Start Button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isUnlocked && !_isStarting ? _handleStartTest : null,
              icon: _isStarting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_isStarting ? 'Đang khởi tạo...' : 'Bắt đầu làm bài'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: context.padding.p16,
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
          ),

          // Unlock Message (if not unlocked)
          if (!isUnlocked) ...[
            Gap(context.spacing.s16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.padding.p16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF9800).withValues(alpha:0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lock,
                    color: const Color(0xFFFF9800),
                    size: 32,
                  ),
                  Gap(context.spacing.s8),
                  Text(
                    'Chưa mở khóa Mini Test',
                    style: context.textStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF9800),
                    ),
                  ),
                  Gap(context.spacing.s4),
                  Text(
                    'Bạn cần làm đủ $requiredPracticeCount bài luyện tập về kỹ năng này để mở khóa Mini Test',
                    style: context.textStyle.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Gap(context.spacing.s12),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.push(
                        '${Routes.practiceQuestion}?skillId=$_skillId',
                      );
                    },
                    icon: const Icon(Icons.assignment),
                    label: const Text('Luyện tập ngay'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9800),
                      side: const BorderSide(color: Color(0xFFFF9800)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillInfoCard(
    BuildContext context,
    String skillName,
    String skillCode,
    String chapter,
    int masteryLevel,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Row(
          children: [
            MasteryCircle(
              masteryLevel: masteryLevel,
              size: 80,
              strokeWidth: 8,
            ),
            Gap(context.spacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skillName,
                    style: context.textStyle.headingSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(context.spacing.s4),
                  Text(
                    skillCode,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                  if (chapter.isNotEmpty) ...[
                    Gap(context.spacing.s4),
                    Text(
                      chapter,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Không tìm thấy thông tin kỹ năng',
      description: 'Vui lòng thử lại sau',
      icon: Icons.info_outline,
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
      title: 'Không thể tải thông tin',
      description: description ?? errorMessage,
      onRetry: () {
        _checkUnlockStatus();
        if (_skillId != null) {
          ref
              .read(skillDetailProvider(_skillId!).notifier)
              .loadSkillDetail(skillId: _skillId!);
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
      return 'Không tìm thấy thông tin';
    }
    if (message.toLowerCase().contains('not unlocked') ||
        message.toLowerCase().contains('chưa mở khóa')) {
      return 'Mini Test chưa được mở khóa';
    }

    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }
}

