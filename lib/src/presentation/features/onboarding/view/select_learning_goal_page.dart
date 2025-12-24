import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';

class SelectLearningGoalPage extends ConsumerStatefulWidget {
  const SelectLearningGoalPage({super.key});

  @override
  ConsumerState<SelectLearningGoalPage> createState() =>
      _SelectLearningGoalPageState();
}

class _SelectLearningGoalPageState
    extends ConsumerState<SelectLearningGoalPage> {
  final Set<String> _selectedGoals = {};
  bool _isLoading = false;

  Future<void> _onStartLearning() async {
    if (_selectedGoals.isEmpty) return;

    setState(() => _isLoading = true);

    // Mock: Save learning goals (local storage)
    // In real implementation, this would call the API
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isLoading = false);
    context.go(Routes.home);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Mục tiêu học tập'),
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
                      'Mục tiêu học tập của bạn là gì?',
                      style: context.textStyle.headingLarge.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.33, // 32px / 24px
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Gap(context.spacing.s32),
                    // Learning goal cards
                    _LearningGoalCard(
                      goalId: 'follow_curriculum',
                      title: 'Học theo chương',
                      description: 'Học đúng tiến độ chương trình',
                      icon: Icons.menu_book,
                      isSelected: _selectedGoals.contains('follow_curriculum'),
                      onTap: () => _toggleGoal('follow_curriculum'),
                    ),
                    Gap(context.spacing.s12),
                    _LearningGoalCard(
                      goalId: 'strengthen_weakness',
                      title: 'Củng cố kiến thức còn yếu',
                      description: 'Tập trung vào phần bạn chưa vững',
                      icon: Icons.track_changes,
                      isSelected:
                          _selectedGoals.contains('strengthen_weakness'),
                      onTap: () => _toggleGoal('strengthen_weakness'),
                    ),
                    Gap(context.spacing.s12),
                    _LearningGoalCard(
                      goalId: 'exam_preparation',
                      title: 'Ôn tập cho bài kiểm tra',
                      description: 'Chuẩn bị cho kỳ thi sắp tới',
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
                  onPressed:
                      _selectedGoals.isNotEmpty && !_isLoading
                          ? _onStartLearning
                          : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _selectedGoals.isNotEmpty
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
                          'Bắt đầu học',
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
                  // Icon
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
                  // Title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textStyle.headingMedium.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.33, // 24px / 18px
                            color: const Color(0xFF212121),
                          ),
                        ),
                        Gap(context.spacing.s4),
                        Text(
                          description,
                          style: context.textStyle.bodyMedium.copyWith(
                            fontSize: 14,
                            height: 1.43, // 20px / 14px
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Checkbox at top right
              Positioned(
                top: 0,
                right: 0,
                child: Semantics(
                  label: isSelected ? 'Đã chọn' : 'Chưa chọn',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

