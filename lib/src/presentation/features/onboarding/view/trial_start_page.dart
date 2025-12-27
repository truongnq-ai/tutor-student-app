import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
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
  Future<void> _onStartTrial() async {
    // Navigate to login page - status check will happen after login
    if (mounted) {
      context.go(Routes.authEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 7));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText(context.locale.onboarding_trial_start_title),
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
              context.locale.onboarding_trial_start_header,
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
              context.locale.onboarding_trial_start_description,
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
                    text: context.locale.onboarding_trial_feature_unlimited_math,
                  ),
                  Gap(context.spacing.s12),
                  _FeatureItem(
                    icon: '✅',
                    text: context.locale.onboarding_trial_feature_daily_plan,
                  ),
                  Gap(context.spacing.s12),
                  _FeatureItem(
                    icon: '✅',
                    text: context.locale.onboarding_trial_feature_personalized_practice,
                  ),
                  Gap(context.spacing.s12),
                  _FeatureItem(
                    icon: '✅',
                    text: context.locale.onboarding_trial_feature_mini_test,
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
                    context.locale.onboarding_trial_info_title,
                    style: context.textStyle.headingMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.33, // 24px / 18px
                      color: const Color(0xFF212121),
                    ),
                  ),
                  Gap(context.spacing.s16),
                  _InfoRow(
                    label: context.locale.onboarding_trial_info_duration_label,
                    value: context.locale.onboarding_trial_info_duration_value,
                  ),
                  Gap(context.spacing.s8),
                  _InfoRow(
                    label: context.locale.onboarding_trial_info_start_label,
                    value: '${now.day}/${now.month}/${now.year}',
                  ),
                  Gap(context.spacing.s8),
                  _InfoRow(
                    label: context.locale.onboarding_trial_info_end_label,
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
                      context.locale.onboarding_trial_info_note,
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
                onPressed: _onStartTrial,
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
                  context.locale.onboarding_trial_start_button,
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
                text: context.locale.onboarding_trial_start_already_have_account,
                linkText: context.locale.onboarding_trial_start_login_link,
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

