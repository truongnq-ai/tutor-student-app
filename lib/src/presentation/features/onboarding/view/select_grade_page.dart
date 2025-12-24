import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';

class SelectGradePage extends ConsumerStatefulWidget {
  const SelectGradePage({super.key});

  @override
  ConsumerState<SelectGradePage> createState() => _SelectGradePageState();
}

class _SelectGradePageState extends ConsumerState<SelectGradePage> {
  int? _selectedGrade;
  bool _isLoading = false;

  Future<void> _onContinue() async {
    if (_selectedGrade == null) return;

    setState(() => _isLoading = true);

    // Mock: Save grade selection (local storage)
    // In real implementation, this would call the API
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isLoading = false);
    context.go(Routes.selectLearningGoal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Chọn lớp học'),
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
                      'Bạn đang học lớp mấy?',
                      style: context.textStyle.headingLarge.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.33, // 32px / 24px
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Gap(context.spacing.s32),
                    // Grade selection cards
                    _GradeCard(
                      grade: 6,
                      title: 'Lớp 6',
                      description: 'Chương trình Toán lớp 6',
                      icon: Icons.school,
                      isSelected: _selectedGrade == 6,
                      onTap: () {
                        setState(() => _selectedGrade = 6);
                      },
                    ),
                    Gap(context.spacing.s16),
                    _GradeCard(
                      grade: 7,
                      title: 'Lớp 7',
                      description: 'Chương trình Toán lớp 7',
                      icon: Icons.school,
                      isSelected: _selectedGrade == 7,
                      onTap: () {
                        setState(() => _selectedGrade = 7);
                      },
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
                  onPressed: _selectedGrade != null && !_isLoading
                      ? _onContinue
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _selectedGrade != null
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
                          'Tiếp tục',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: context.textStyle.headingMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.4, // 28px / 20px
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
              // Selected indicator
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

