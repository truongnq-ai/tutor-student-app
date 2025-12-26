import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/tutor_provider.dart';
import '../widgets/solution_step_card.dart';

class SolutionStepByStepPage extends ConsumerStatefulWidget {
  const SolutionStepByStepPage({super.key});

  @override
  ConsumerState<SolutionStepByStepPage> createState() => _SolutionStepByStepPageState();
}

class _SolutionStepByStepPageState extends ConsumerState<SolutionStepByStepPage> {
  int _currentStepIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final solveState = ref.watch(solveProblemProvider);
    final solution = solveState.valueOrNull;

    if (solveState.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const HeadingSmallText('Lời giải'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (solveState.hasError || solution == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const HeadingSmallText('Lời giải'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFF44336),
              ),
              Gap(context.spacing.s16),
              Text(
                'Không thể tải lời giải',
                style: context.textStyle.headingSmall,
              ),
              Gap(context.spacing.s8),
              Text(
                solveState.error?.toString() ?? 'Đã xảy ra lỗi',
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(context.spacing.s24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      );
    }

    final steps = solution.solution.steps;
    final totalSteps = steps.length;
    final isLastStep = _currentStepIndex == totalSteps - 1;
    final currentStep = steps[_currentStepIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmallText('Lời giải'),
            Text(
              'Bước ${_currentStepIndex + 1}/$totalSteps',
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(context.padding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Problem display
                  Container(
                    padding: EdgeInsets.all(context.padding.p16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đề bài:',
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.text.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          solution.problemText,
                          style: context.textStyle.bodyLarge.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(context.spacing.s16),

                  // Progress dots
                  _buildProgressDots(context, totalSteps, _currentStepIndex),
                  Gap(context.spacing.s24),

                  // Current step card with animation
                  Semantics(
                    label: 'Bước ${_currentStepIndex + 1}: ${currentStep.description}',
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            )),
                            child: child,
                          ),
                        );
                      },
                      child: SolutionStepCard(
                        key: ValueKey<int>(_currentStepIndex),
                        step: currentStep,
                        stepNumber: _currentStepIndex + 1,
                      ),
                    ),
                  ),
                  Gap(context.spacing.s24),

                  // Final answer (only on last step)
                  if (isLastStep) ...[
                    _buildFinalAnswer(context, solution.solution.finalAnswer),
                    Gap(context.spacing.s24),

                    // Common mistakes
                    if (solution.solution.commonMistakes.isNotEmpty)
                      _buildCommonMistakes(
                        context,
                        solution.solution.commonMistakes,
                      ),
                    Gap(context.spacing.s24),

                    // Related skills
                    if (solution.relatedSkills.isNotEmpty)
                      _buildRelatedSkills(
                        context,
                        solution.relatedSkills,
                      ),
                  ],
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(context.padding.p16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: isLastStep
                  ? _buildFinalStepActions(context)
                  : _buildStepNavigation(context, totalSteps),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDots(BuildContext context, int totalSteps, int currentIndex) {
    return Semantics(
      label: 'Bước ${currentIndex + 1} trong tổng số $totalSteps bước',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentIndex;
          final isCompleted = index < currentIndex;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing.s4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF4CAF50)
                  : isCompleted
                      ? const Color(0xFF4CAF50).withOpacity(0.5)
                      : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFinalAnswer(BuildContext context, String finalAnswer) {
    return Container(
      padding: EdgeInsets.all(context.padding.p20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đáp án:',
            style: context.textStyle.bodyMedium.copyWith(
              color: const Color(0xFF4CAF50),
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(context.spacing.s8),
          Text(
            finalAnswer,
            style: context.textStyle.headingLarge.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonMistakes(
    BuildContext context,
    List<String> commonMistakes,
  ) {
    return Container(
      padding: EdgeInsets.all(context.padding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFFF9800),
              ),
              Gap(context.spacing.s8),
              Text(
                'Lưu ý: Lỗi sai thường gặp',
                style: context.textStyle.headingSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Gap(context.spacing.s12),
          ...commonMistakes.map((mistake) {
            return Padding(
              padding: EdgeInsets.only(bottom: context.spacing.s8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Color(0xFFFF9800))),
                  Expanded(
                    child: Text(
                      mistake,
                      style: context.textStyle.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRelatedSkills(BuildContext context, List<String> relatedSkills) {
    return Container(
      padding: EdgeInsets.all(context.padding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kỹ năng liên quan:',
            style: context.textStyle.headingSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(context.spacing.s12),
          Wrap(
            spacing: context.spacing.s8,
            runSpacing: context.spacing.s8,
            children: relatedSkills.map((skill) {
              return Semantics(
                label: 'Kỹ năng: $skill',
                button: true,
                child: InkWell(
                  onTap: () {
                    // TODO: Navigate to skill detail or practice
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kỹ năng: $skill'),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.padding.p12,
                      vertical: context.padding.p8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF2196F3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      skill,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: const Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNavigation(BuildContext context, int totalSteps) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _currentStepIndex == 0
                ? null
                : () {
                    setState(() {
                      _currentStepIndex--;
                    });
                    // Smooth scroll to top after step change animation
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollToTop();
                    });
                  },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Bước trước'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Gap(context.spacing.s12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (_currentStepIndex < totalSteps - 1) {
                setState(() {
                  _currentStepIndex++;
                });
                // Smooth scroll to top after step change animation
                Future.delayed(const Duration(milliseconds: 100), () {
                  _scrollToTop();
                });
              }
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Bước tiếp theo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalStepActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to skill practice
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tính năng luyện tập kỹ năng sẽ được thêm sau'),
                ),
              );
            },
            icon: const Icon(Icons.school),
            label: const Text('Luyện tập kỹ năng này'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Gap(context.spacing.s12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.pushReplacement(Routes.tutorModeEntry);
                },
                icon: const Icon(Icons.add),
                label: const Text('Giải bài khác'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Gap(context.spacing.s12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push(Routes.tutorRecentProblems);
                },
                icon: const Icon(Icons.history),
                label: const Text('Lịch sử'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

