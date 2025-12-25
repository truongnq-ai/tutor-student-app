import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/link_text.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/trial_provider.dart';

class TrialStartPage extends ConsumerStatefulWidget {
  const TrialStartPage({super.key});

  @override
  ConsumerState<TrialStartPage> createState() => _TrialStartPageState();
}

class _TrialStartPageState extends ConsumerState<TrialStartPage> {
  @override
  void initState() {
    super.initState();
    // Listen to trial provider state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(trialProvider, (previous, next) {
        next.when(
          data: (trialStatus) {
            if (trialStatus != null && mounted) {
              // Navigate to select grade on success
              context.go(Routes.selectGrade);
            }
          },
          loading: () {},
          error: (error, stackTrace) {
            // Error handling is done in the UI
          },
        );
      });
    });
  }

  Future<void> _onStartTrial() async {
    await ref.read(trialProvider.notifier).startTrial();
  }

  @override
  Widget build(BuildContext context) {
    final trialState = ref.watch(trialProvider);
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 7));
    final isLoading = trialState.isLoading;
    final error = trialState.hasError ? trialState.error : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Bắt đầu dùng thử'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.padding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error message
            if (error != null) ...[
              Gap(context.spacing.s16),
              Container(
                padding: EdgeInsets.all(context.padding.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFF44336).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFF44336),
                      size: 20,
                    ),
                    Gap(context.spacing.s8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            error.toString().replaceFirst('Exception: ', ''),
                            style: context.textStyle.bodyMedium.copyWith(
                              fontSize: 14,
                              color: const Color(0xFF212121),
                            ),
                          ),
                          Gap(context.spacing.s8),
                          TextButton(
                            onPressed: _onStartTrial,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Thử lại',
                              style: context.textStyle.bodyMedium.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF44336),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Gap(context.spacing.s32),
            // Illustration
            Center(
              child: Semantics(
                label: 'Học sinh bắt đầu dùng thử ứng dụng',
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.celebration,
                    size: 80,
                    color: Color(0xFFFF9800),
                  ),
                ),
              ),
            ),
            Gap(context.spacing.s32),
            // Title
            Text(
              'Bắt đầu dùng thử miễn phí!',
              textAlign: TextAlign.center,
              style: context.textStyle.headingLarge.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.33, // 32px / 24px
                color: const Color(0xFF212121),
              ),
            ),
            Gap(context.spacing.s16),
            // Description
            Text(
              'Bạn có 7 ngày để trải nghiệm đầy đủ tính năng của Tutor',
              textAlign: TextAlign.center,
              style: context.textStyle.bodyLarge.copyWith(
                fontSize: 16,
                height: 1.5, // 24px / 16px
                color: const Color(0xFF757575),
              ),
            ),
            Gap(context.spacing.s32),
            // Features list
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
                  _FeatureItem(
                    icon: '✅',
                    text: 'Giải bài Toán không giới hạn (3-5 lượt/ngày)',
                  ),
                  Gap(context.spacing.s12),
                  _FeatureItem(
                    icon: '✅',
                    text: 'Lộ trình học hằng ngày',
                  ),
                  Gap(context.spacing.s12),
                  _FeatureItem(
                    icon: '✅',
                    text: 'Luyện tập cá nhân hoá',
                  ),
                  Gap(context.spacing.s12),
                  _FeatureItem(
                    icon: '✅',
                    text: 'Mini test kiểm tra kiến thức',
                  ),
                ],
              ),
            ),
            Gap(context.spacing.s24),
            // Trial info card
            Container(
              padding: EdgeInsets.all(context.padding.p20),
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
                    'Thông tin dùng thử',
                    style: context.textStyle.headingMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.33, // 24px / 18px
                      color: const Color(0xFF212121),
                    ),
                  ),
                  Gap(context.spacing.s16),
                  _InfoRow(
                    label: 'Thời gian:',
                    value: '7 ngày',
                  ),
                  Gap(context.spacing.s8),
                  _InfoRow(
                    label: 'Bắt đầu:',
                    value: '${now.day}/${now.month}/${now.year}',
                  ),
                  Gap(context.spacing.s8),
                  _InfoRow(
                    label: 'Kết thúc:',
                    value: '${endDate.day}/${endDate.month}/${endDate.year}',
                  ),
                ],
              ),
            ),
            Gap(context.spacing.s16),
            // Note
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                  Gap(context.spacing.s8),
                  Expanded(
                    child: Text(
                      'Dữ liệu học tập sẽ được lưu lại khi bạn liên kết với phụ huynh',
                      style: context.textStyle.bodyMedium.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF212121),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(context.spacing.s32),
            // Button "Bắt đầu"
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: isLoading ? null : _onStartTrial,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? const LoadingIndicator()
                    : Text(
                        'Bắt đầu',
                        style: context.textStyle.bodyLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Gap(context.spacing.s16),
            // Link "Đã có tài khoản? Đăng nhập"
            Center(
              child: LinkText(
                text: 'Đã có tài khoản? ',
                linkText: 'Đăng nhập',
                onTap: () {
                  context.go(Routes.authEntry);
                },
              ),
            ),
            Gap(context.spacing.s32),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 20),
        ),
        Gap(context.spacing.s8),
        Expanded(
          child: Text(
            text,
            style: context.textStyle.bodyMedium.copyWith(
              fontSize: 14,
              color: const Color(0xFF212121),
            ),
          ),
        ),
      ],
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
            color: const Color(0xFF757575),
          ),
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

