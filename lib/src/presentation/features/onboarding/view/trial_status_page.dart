import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';

class TrialStatusPage extends ConsumerStatefulWidget {
  const TrialStatusPage({super.key});

  @override
  ConsumerState<TrialStatusPage> createState() => _TrialStatusPageState();
}

class _TrialStatusPageState extends ConsumerState<TrialStatusPage> {
  bool _isLoading = false;

  // Mock data
  final int _daysRemaining = 5;
  final int _daysUsed = 2;
  final int _totalDays = 7;
  final int _solvesToday = 3;
  final int _maxSolvesPerDay = 5;
  final int _totalExercises = 45;
  final int _skillsLearned = 8;
  final bool _isLinked = false;

  String get _statusBadge {
    if (_daysRemaining >= 3) {
      return 'Đang dùng thử';
    } else if (_daysRemaining >= 1) {
      return 'Sắp hết hạn';
    } else {
      return 'Đã hết hạn';
    }
  }

  Color get _statusColor {
    if (_daysRemaining >= 3) {
      return const Color(0xFF4CAF50); // Green
    } else if (_daysRemaining >= 1) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Trạng thái dùng thử'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.padding.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(context.spacing.s24),
                  // Trial status card
                  Container(
                    padding: EdgeInsets.all(context.padding.p24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        // Status badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.padding.p16,
                            vertical: context.padding.p8,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _statusColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _statusBadge,
                            style: context.textStyle.bodyMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.43, // 20px / 14px
                              color: _statusColor,
                            ),
                          ),
                        ),
                        Gap(context.spacing.s24),
                        // Days remaining
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$_daysRemaining',
                              style: context.textStyle.headingLarge.copyWith(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                height: 1.33, // 64px / 48px (proportional)
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                            Gap(context.spacing.s8),
                            Text(
                              'ngày còn lại',
                              style: context.textStyle.bodyLarge.copyWith(
                                fontSize: 16,
                                height: 1.5, // 24px / 16px
                                color: const Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                        Gap(context.spacing.s16),
                        // Start and end dates
                        _InfoRow(
                          label: 'Bắt đầu:',
                          value: '10/12/2025',
                        ),
                        Gap(context.spacing.s8),
                        _InfoRow(
                          label: 'Kết thúc:',
                          value: '17/12/2025',
                        ),
                        Gap(context.spacing.s16),
                        // Progress bar
                        Semantics(
                          label: 'Tiến độ: $_daysUsed/$_totalDays ngày',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Đã dùng: $_daysUsed/$_totalDays ngày',
                                    style:
                                        context.textStyle.bodyMedium.copyWith(
                                      fontSize: 14,
                                      height: 1.43, // 20px / 14px
                                      color: const Color(0xFF757575),
                                    ),
                                  ),
                                  Text(
                                    '${((_daysUsed / _totalDays) * 100).toInt()}%',
                                    style:
                                        context.textStyle.bodyMedium.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.43, // 20px / 14px
                                      color: const Color(0xFF212121),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(context.spacing.s8),
                              LinearProgressIndicator(
                                value: _daysUsed / _totalDays,
                                minHeight: 8,
                                backgroundColor: const Color(0xFFE0E0E0),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4CAF50),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(context.spacing.s24),
                  // Usage stats
                  Container(
                    padding: EdgeInsets.all(context.padding.p24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                          'Thống kê sử dụng',
                          style: context.textStyle.headingMedium.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.33, // 24px / 18px
                            color: const Color(0xFF212121),
                          ),
                        ),
                        Gap(context.spacing.s16),
                        _StatRow(
                          icon: '📚',
                          label: 'Số lượt giải bài hôm nay:',
                          value: '$_solvesToday/$_maxSolvesPerDay',
                        ),
                        Gap(context.spacing.s12),
                        _StatRow(
                          icon: '📝',
                          label: 'Tổng bài đã làm:',
                          value: '$_totalExercises bài',
                        ),
                        Gap(context.spacing.s12),
                        _StatRow(
                          icon: '🎯',
                          label: 'Số skill đã học:',
                          value: '$_skillsLearned skill',
                        ),
                      ],
                    ),
                  ),
                  Gap(context.spacing.s24),
                  // Features reminder
                  Container(
                    padding: EdgeInsets.all(context.padding.p16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bạn đang có quyền truy cập:',
                          style: context.textStyle.bodyMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.43, // 20px / 14px
                            color: const Color(0xFF212121),
                          ),
                        ),
                        Gap(context.spacing.s8),
                        _FeatureItem(text: 'Giải bài Toán (3-5 lượt/ngày)'),
                        Gap(context.spacing.s4),
                        _FeatureItem(text: 'Lộ trình học hằng ngày'),
                        Gap(context.spacing.s4),
                        _FeatureItem(text: 'Luyện tập cá nhân hoá'),
                        Gap(context.spacing.s4),
                        _FeatureItem(text: 'Mini test'),
                      ],
                    ),
                  ),
                  // Warning card (if < 2 days)
                  if (_daysRemaining < 2) ...[
                    Gap(context.spacing.s24),
                    Container(
                      padding: EdgeInsets.all(context.padding.p16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF9800).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFFF9800),
                            size: 24,
                          ),
                          Gap(context.spacing.s8),
                          Expanded(
                            child: Text(
                              'Còn $_daysRemaining ngày. Hãy liên kết với phụ huynh để tiếp tục học!',
                              style: context.textStyle.bodyMedium.copyWith(
                                fontSize: 14,
                                height: 1.43, // 20px / 14px
                                color: const Color(0xFF212121),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Gap(context.spacing.s32),
                  // Buttons
                  if (!_isLinked)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () {
                          context.go(Routes.trialExpiry);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Liên kết với phụ huynh',
                          style: context.textStyle.bodyLarge.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (!_isLinked) Gap(context.spacing.s16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        context.go(Routes.home);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4CAF50),
                        side: const BorderSide(
                          color: Color(0xFF4CAF50),
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Tiếp tục học',
                        style: context.textStyle.bodyLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ),
                  Gap(context.spacing.s32),
                ],
              ),
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyle.bodyMedium.copyWith(
            fontSize: 14,
            height: 1.43, // 20px / 14px
            color: const Color(0xFF757575),
          ),
        ),
        Text(
          value,
          style: context.textStyle.bodyMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.43, // 20px / 14px
            color: const Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 20),
            ),
            Gap(context.spacing.s8),
            Text(
              label,
              style: context.textStyle.bodyMedium.copyWith(
                fontSize: 14,
                height: 1.43, // 20px / 14px
                color: const Color(0xFF757575),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: context.textStyle.bodyMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '✅',
          style: TextStyle(fontSize: 16),
        ),
        Gap(context.spacing.s8),
        Text(
          text,
          style: context.textStyle.bodyMedium.copyWith(
            fontSize: 14,
            color: const Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}

