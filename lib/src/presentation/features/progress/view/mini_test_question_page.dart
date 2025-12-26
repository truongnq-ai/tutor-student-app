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
import '../../../../domain/entities/mini_test_session_entity.dart';
import '../../../core/router/routes.dart';
import '../riverpod/mini_test_provider.dart';
import '../widgets/test_answer_option.dart';
import '../widgets/test_question_card.dart';
import '../widgets/test_timer_widget.dart';

class MiniTestQuestionPage extends ConsumerStatefulWidget {
  final String? sessionId;

  const MiniTestQuestionPage({
    super.key,
    this.sessionId,
  });

  @override
  ConsumerState<MiniTestQuestionPage> createState() =>
      _MiniTestQuestionPageState();
}

class _MiniTestQuestionPageState
    extends ConsumerState<MiniTestQuestionPage> {
  String? _sessionId;
  String? _selectedAnswer;
  bool _hasNavigated = false; // Track if user has navigated to prevent going back
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _sessionId = widget.sessionId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sessionId == null) {
      final uri = GoRouterState.of(context).uri;
      _sessionId = uri.queryParameters['sessionId'];
    }
  }

  Future<void> _handleSubmitAnswer() async {
    if (_sessionId == null || _selectedAnswer == null || _isSubmitting) return;

    final sessionState = ref.read(miniTestSessionProvider(_sessionId));
    final session = sessionState.valueOrNull;
    if (session == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(miniTestSessionProvider(_sessionId).notifier).submitAnswer(
            sessionId: _sessionId!,
            questionIndex: session.currentQuestionIndex,
            answer: _selectedAnswer!,
          );

      // Refresh session to get updated state
      await ref.read(miniTestSessionProvider(_sessionId).notifier).refresh(_sessionId!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi nộp đáp án: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _selectedAnswer = null;
        });
      }
    }
  }

  Future<void> _handleNextQuestion() async {
    if (_sessionId == null || _isSubmitting) return;

    // Submit current answer if selected
    if (_selectedAnswer != null) {
      await _handleSubmitAnswer();
    }

    final sessionState = ref.read(miniTestSessionProvider(_sessionId));
    final session = sessionState.valueOrNull;
    if (session == null) return;

    // Move to next question (this is handled by backend when submitting answer)
    // Just refresh to get updated currentQuestionIndex
    await ref.read(miniTestSessionProvider(_sessionId).notifier).refresh(_sessionId!);
    
    setState(() {
      _selectedAnswer = null;
      _hasNavigated = true;
    });
  }

  Future<void> _handlePreviousQuestion() async {
    if (_sessionId == null || _isSubmitting) return;

    final sessionState = ref.read(miniTestSessionProvider(_sessionId));
    final session = sessionState.valueOrNull;
    if (session == null || session.currentQuestionIndex <= 0) return;

    // Note: Backend doesn't support going back, but we can show previous answer
    // For now, just refresh to show current question
    await ref.read(miniTestSessionProvider(_sessionId).notifier).refresh(_sessionId!);
    
    // Load previous answer if exists
    final prevAnswer = session.answers[session.currentQuestionIndex - 1];
    setState(() {
      _selectedAnswer = prevAnswer;
    });
  }

  Future<void> _handleSubmitTest() async {
    if (_sessionId == null || _isSubmitting) return;

    // Submit current answer if selected
    if (_selectedAnswer != null) {
      await _handleSubmitAnswer();
      // Wait a bit for answer to be saved
      await Future.delayed(const Duration(milliseconds: 300));
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(miniTestResultProvider.notifier).submitTest(_sessionId!);

      final resultState = ref.read(miniTestResultProvider);
      final result = resultState.valueOrNull;

      if (result != null && mounted) {
        context.push('${Routes.miniTestResult}?resultId=${result.resultId}');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể nộp bài. Vui lòng thử lại.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi nộp bài: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<bool> _handleBackButton() async {
    if (_hasNavigated) {
      // Show confirmation dialog
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text(
            'Bạn có chắc muốn thoát? Tiến độ sẽ bị mất.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Thoát'),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    }
    return true;
  }

  void _handleTimerExpired() {
    // Auto-submit test when timer expires
    _handleSubmitTest();
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const HeadingSmallText('Mini Test'),
        ),
        body: const Center(
          child: Text('Không tìm thấy session ID'),
        ),
      );
    }

    final sessionState = ref.watch(miniTestSessionProvider(_sessionId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final shouldPop = await _handleBackButton();
          if (shouldPop && mounted) {
            context.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: sessionState.when(
            data: (session) {
              if (session == null) return const HeadingSmallText('Mini Test');
              return HeadingSmallText(
                'Câu ${session.currentQuestionIndex + 1}/${session.totalQuestions}',
              );
            },
            loading: () => const HeadingSmallText('Mini Test'),
            error: (_, __) => const HeadingSmallText('Mini Test'),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await _handleBackButton();
              if (shouldPop && mounted) {
                context.pop();
              }
            },
          ),
        ),
        body: sessionState.when(
          data: (session) {
            if (session == null) {
              return _buildEmptyState(context);
            }
            return _buildContent(context, session);
          },
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, stackTrace) => _buildErrorState(context, error),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MiniTestSessionEntity session) {
    final questionNumber = session.currentQuestionIndex + 1;
    final totalQuestions = session.totalQuestions;
    final progress = questionNumber / totalQuestions;
    
    // Load current answer if exists
    final currentAnswer = session.answers[session.currentQuestionIndex];
    if (currentAnswer != null && _selectedAnswer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedAnswer = currentAnswer;
        });
      });
    }

    // Mock question data (in real app, this would come from API)
    // For now, we'll use a simple structure
    final questionText = 'Câu hỏi $questionNumber: Rút gọn phân số: 24/36';
    final answerOptions = ['2/3', '3/4', '4/5', '6/9'];
    final optionLabels = ['A', 'B', 'C', 'D'];

    final isFirstQuestion = session.currentQuestionIndex == 0;
    final isLastQuestion = session.currentQuestionIndex == totalQuestions - 1;

    return Column(
      children: [
        // Header with Timer and Progress
        Container(
          padding: EdgeInsets.all(context.padding.p16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Câu $questionNumber/$totalQuestions',
                    style: context.textStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TestTimerWidget(
                    remainingSeconds: session.timeRemainingSec,
                    onExpired: _handleTimerExpired,
                  ),
                ],
              ),
              Gap(context.spacing.s12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.color.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Question and Answers
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.padding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Card
                TestQuestionCard(
                  questionNumber: questionNumber,
                  questionText: questionText,
                ),
                Gap(context.spacing.s24),

                // Answer Options
                ...List.generate(
                  answerOptions.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: context.spacing.s12),
                    child: TestAnswerOption(
                      optionLabel: optionLabels[index],
                      optionText: answerOptions[index],
                      isSelected: _selectedAnswer == optionLabels[index],
                      onTap: () {
                        setState(() {
                          _selectedAnswer = optionLabels[index];
                        });
                      },
                    ),
                  ),
                ),

                // Note about navigation
                if (!_hasNavigated) ...[
                  Gap(context.spacing.s16),
                  Container(
                    padding: EdgeInsets.all(context.padding.p12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFF9800).withValues(alpha:0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFFFF9800),
                          size: 20,
                        ),
                        Gap(context.spacing.s8),
                        Expanded(
                          child: Text(
                            'Không thể quay lại sau khi chuyển câu',
                            style: context.textStyle.bodySmall.copyWith(
                              color: const Color(0xFFFF9800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Bottom Navigation
        Container(
          padding: EdgeInsets.all(context.padding.p16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Previous Button
              if (!isFirstQuestion)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _handlePreviousQuestion,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Câu trước'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: context.padding.p12,
                      ),
                      minimumSize: const Size(0, 56),
                    ),
                  ),
                ),
              if (!isFirstQuestion) Gap(context.spacing.s12),

              // Next/Submit Button
              Expanded(
                flex: isFirstQuestion ? 1 : 1,
                child: FilledButton.icon(
                  onPressed: _isSubmitting
                      ? null
                      : isLastQuestion
                          ? _handleSubmitTest
                          : _handleNextQuestion,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(isLastQuestion ? Icons.check : Icons.arrow_forward),
                  label: Text(
                    _isSubmitting
                        ? 'Đang xử lý...'
                        : isLastQuestion
                            ? 'Nộp bài'
                            : 'Câu tiếp theo',
                  ),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: context.padding.p12,
                    ),
                    minimumSize: const Size(0, 56),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Không tìm thấy bài test',
      description: 'Vui lòng thử lại sau',
      icon: Icons.quiz_outlined,
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
      title: 'Không thể tải bài test',
      description: description ?? errorMessage,
      onRetry: () {
        if (_sessionId != null) {
          ref.read(miniTestSessionProvider(_sessionId).notifier).refresh(_sessionId!);
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
      return 'Không tìm thấy bài test';
    }
    if (message.toLowerCase().contains('expired') ||
        message.toLowerCase().contains('hết hạn')) {
      return 'Bài test đã hết hạn';
    }

    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }
}

