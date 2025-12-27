import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../../core/di/dependency_injection.dart';
import '../riverpod/grade_provider.dart';
import '../riverpod/learning_goal_provider.dart';

class SelectGradeAndGoalsPage extends ConsumerStatefulWidget {
  const SelectGradeAndGoalsPage({super.key});

  @override
  ConsumerState<SelectGradeAndGoalsPage> createState() =>
      _SelectGradeAndGoalsPageState();
}

class _SelectGradeAndGoalsPageState
    extends ConsumerState<SelectGradeAndGoalsPage> {
  final Set<String> _selectedGoals = {};
  int? _selectedGrade; // Local state cho grade
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load existing grade and learning goals from providers (nếu có) - chỉ để hiển thị
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gradeState = ref.read(gradeSelectionProvider);
      if (gradeState.value != null) {
        setState(() {
          _selectedGrade = gradeState.value;
        });
      }
      
      final goalsState = ref.read(learningGoalsProvider);
      if (goalsState.value != null && goalsState.value!.isNotEmpty) {
        setState(() {
          _selectedGoals.addAll(goalsState.value!);
        });
      }
    });
  }

  Future<void> _onCreateTrial() async {
    if (_selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng chọn lớp học'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng chọn ít nhất một mục tiêu học tập'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Gọi API create trial với cả grade và learningGoals
      final repository = ref.read(trialRepositoryProvider);
      final response = await repository.createTrial(
        grade: _selectedGrade!,
        learningGoals: _selectedGoals.toList(),
      );

      if (!response.isSuccess) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorDetail ?? 'Không thể tạo trial. Vui lòng thử lại.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      // Navigate to home on success
      if (mounted) {
        context.go(Routes.home);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _toggleGoal(String goalId) {
    setState(() {
      if (_selectedGoals.contains(goalId)) {
        _selectedGoals.remove(goalId);
      } else {
        _selectedGoals.add(goalId);
      }
    });
  }

  void _selectGrade(int grade) {
    setState(() {
      _selectedGrade = grade;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Không cần watch providers nữa, chỉ dùng local state

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText('Chọn lớp và mục tiêu học tập'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.padding.p24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(context.spacing.s32),
                    // Header
                    Text(
                      'Chọn lớp học của bạn',
                      style: context.textStyle.headingLarge.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.33,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Gap(context.spacing.s16),
                    // Grade selection cards
                    _GradeCard(
                      grade: 6,
                      title: context.locale.onboarding_grade_6_title,
                      description: context.locale.onboarding_grade_6_description,
                      icon: Icons.school,
                      isSelected: _selectedGrade == 6,
                      onTap: () => _selectGrade(6),
                    ),
                    Gap(context.spacing.s16),
                    _GradeCard(
                      grade: 7,
                      title: context.locale.onboarding_grade_7_title,
                      description: context.locale.onboarding_grade_7_description,
                      icon: Icons.school,
                      isSelected: _selectedGrade == 7,
                      onTap: () => _selectGrade(7),
                    ),
                    Gap(context.spacing.s32),
                    // Learning goals section
                    Text(
                      'Chọn mục tiêu học tập',
                      style: context.textStyle.headingLarge.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.33,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Gap(context.spacing.s16),
                    // Learning goal cards
                    _LearningGoalCard(
                      goalId: 'follow_curriculum',
                      title: context.locale.onboarding_goal_follow_curriculum_title,
                      description: context.locale.onboarding_goal_follow_curriculum_description,
                      icon: Icons.menu_book,
                      isSelected: _selectedGoals.contains('follow_curriculum'),
                      onTap: () => _toggleGoal('follow_curriculum'),
                    ),
                    Gap(context.spacing.s12),
                    _LearningGoalCard(
                      goalId: 'strengthen_weakness',
                      title: context.locale.onboarding_goal_strengthen_weakness_title,
                      description: context.locale.onboarding_goal_strengthen_weakness_description,
                      icon: Icons.track_changes,
                      isSelected: _selectedGoals.contains('strengthen_weakness'),
                      onTap: () => _toggleGoal('strengthen_weakness'),
                    ),
                    Gap(context.spacing.s12),
                    _LearningGoalCard(
                      goalId: 'exam_preparation',
                      title: context.locale.onboarding_goal_exam_preparation_title,
                      description: context.locale.onboarding_goal_exam_preparation_description,
                      icon: Icons.calendar_today,
                      isSelected: _selectedGoals.contains('exam_preparation'),
                      onTap: () => _toggleGoal('exam_preparation'),
                    ),
                    Gap(context.spacing.s32),
                  ],
                ),
              ),
            ),
            // Fixed bottom button
            Container(
              padding: EdgeInsets.all(context.padding.p24),
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
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _selectedGrade != null &&
                          _selectedGoals.isNotEmpty &&
                          !_isLoading
                      ? _onCreateTrial
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _selectedGrade != null &&
                            _selectedGoals.isNotEmpty
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFBDBDBD),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const LoadingIndicator()
                      : Text(
                          'Bắt đầu học tập',
                          style: context.textStyle.bodyLarge.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({
    required this.grade,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final int grade;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title - $description',
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(context.padding.p24),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE8F5E9)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE0E0E0),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : const Color(0xFFE0E0E0).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF757575),
                ),
              ),
              Gap(context.spacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: context.textStyle.headingMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Gap(context.spacing.s4),
                    Text(
                      description,
                      style: context.textStyle.bodyMedium.copyWith(
                        fontSize: 14,
                        height: 1.43,
                        color: const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningGoalCard extends StatelessWidget {
  const _LearningGoalCard({
    required this.goalId,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String goalId;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title - $description',
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(context.padding.p24),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE8F5E9)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE0E0E0),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4CAF50).withOpacity(0.1)
                          : const Color(0xFFE0E0E0).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF757575),
                    ),
                  ),
                  Gap(context.spacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textStyle.headingMedium.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                            color: const Color(0xFF212121),
                          ),
                        ),
                        Gap(context.spacing.s4),
                        Text(
                          description,
                          style: context.textStyle.bodyMedium.copyWith(
                            fontSize: 14,
                            height: 1.43,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF757575),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

