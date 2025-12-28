import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/mini_test_config.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/chapter_progress_entity.dart';
import '../../../../domain/entities/skill_detail_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/mini_test_provider.dart';
import '../riverpod/progress_provider.dart';
import '../widgets/mastery_circle.dart';
import '../widgets/test_detail_card.dart';
import '../widgets/test_instructions_card.dart';
import '../widgets/unlock_celebration_card.dart';

class MiniTestStartPage extends ConsumerStatefulWidget {
  final String? chapterId;

  const MiniTestStartPage({
    super.key,
    this.chapterId,
  });

  @override
  ConsumerState<MiniTestStartPage> createState() =>
      _MiniTestStartPageState();
}

class _MiniTestStartPageState extends ConsumerState<MiniTestStartPage> {
  String? _chapterId;
  bool _isStarting = false;

  @override
  void initState() {
    super.initState();
    _chapterId = widget.chapterId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chapterId != null) {
        _checkUnlockStatus();
        _loadChapterProgress();
      }
    });
  }
  
  void _loadChapterProgress() {
    if (_chapterId != null) {
      ref.read(chapterProgressProvider(_chapterId!).notifier).refresh(_chapterId!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_chapterId == null) {
      final uri = GoRouterState.of(context).uri;
      _chapterId = uri.queryParameters['chapterId'];
      if (_chapterId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkUnlockStatus();
          _loadChapterProgress();
        });
      }
    }
  }

  void _checkUnlockStatus() {
    if (_chapterId == null || _chapterId!.isEmpty) {
      // Invalid chapterId, show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chapter ID không hợp lệ. Vui lòng thử lại.'),
          ),
        );
      }
      return;
    }
    
    try {
      ref.read(miniTestUnlockProvider(_chapterId!).notifier).refresh(_chapterId!);
    } catch (e) {
      // Error handling is done in the provider, but we can log here
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể kiểm tra trạng thái mở khóa: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _handleStartTest() async {
    if (_chapterId == null || _isStarting) return;

    setState(() {
      _isStarting = true;
    });

    try {
      // Start test using provider - get session directly
      final provider = ref.read(miniTestSessionProvider(null).notifier);
      final session = await provider.startTest(chapterId: _chapterId!);

      // Navigate to question page with session
      if (mounted && session.sessionId.isNotEmpty) {
        context.push(
          '${Routes.miniTestQuestion}?sessionId=${session.sessionId}',
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể bắt đầu bài test. Vui lòng thử lại.'),
          ),
        );
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
    if (_chapterId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const HeadingSmallText('Mini Test'),
        ),
        body: const Center(
          child: Text('Không tìm thấy chapter ID'),
        ),
      );
    }

    final unlockState = ref.watch(miniTestUnlockProvider(_chapterId!));
    final chapterProgressState = ref.watch(chapterProgressProvider(_chapterId!));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Mini Test'),
      ),
      body: unlockState.when(
        data: (isUnlocked) {
          return chapterProgressState.when(
            data: (chapterProgress) {
              // Get chapter name from chapter progress
              final chapterName = chapterProgress?.chapterName ?? _chapterId;
              return _buildContent(
                context, 
                isUnlocked, 
                null, // No skill detail for chapter-based test
                chapterName,
                chapterProgress,
              );
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
    SkillDetailEntity? skillDetail,
    String? chapterName,
    ChapterProgressEntity? chapterProgress,
  ) {
    // Get chapter info (primary display)
    final chapter = chapterName ?? '-';
    
    // Get skill info (optional, for display only)
    final skillName = skillDetail?.skillName;
    final skillCode = skillDetail?.skillCode ?? '';
    final masteryLevel = skillDetail?.masteryLevel ?? 0;

    // Get test config from chapter progress, fallback to defaults
    final totalQuestions = chapterProgress?.miniTestTotalQuestions ?? MiniTestConfig.defaultTotalQuestions;
    final timeLimitSec = chapterProgress?.miniTestTimeLimitSec ?? MiniTestConfig.defaultTimeLimitSec;
    final timeLimitMinutes = (timeLimitSec / 60).round();
    final passingScore = chapterProgress?.miniTestPassingScore ?? MiniTestConfig.defaultPassingScore;
    final requiredPracticeCount = chapterProgress?.miniTestRequiredPracticeCount ?? MiniTestConfig.defaultRequiredPracticeCount;

    // Skills to test (for chapter-based test, show skills only, not chapter name)
    final skillsToTest = <String>[];
    if (skillDetail != null && skillDetail.prerequisites.isNotEmpty) {
      skillsToTest.addAll(
        skillDetail.prerequisites
            .map((p) => p.skillName)
            .take(2), // Limit to 2 prerequisites
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter Info Card
          _buildChapterInfoCard(context, chapter, skillName, skillCode, masteryLevel),
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
                      // Navigate to practice for chapter (use first skill if needed)
                      // For now, just show message that practice should be started from chapter page
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng bắt đầu luyện tập từ trang chương học.'),
                          ),
                        );
                      }
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

  Widget _buildChapterInfoCard(
    BuildContext context,
    String chapterName,
    String? skillName,
    String? skillCode,
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
                    chapterName,
                    style: context.textStyle.headingSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (skillName != null && skillName.isNotEmpty) ...[
                    Gap(context.spacing.s4),
                    Text(
                      skillName,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                  if (skillCode != null && skillCode.isNotEmpty) ...[
                    Gap(context.spacing.s4),
                    Text(
                      skillCode,
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
        _loadChapterProgress();
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

