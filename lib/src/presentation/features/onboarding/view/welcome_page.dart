import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/link_text.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE3F2FD), // Light blue
                Color(0xFFFFFFFF), // White
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.padding.p24),
            child: Column(
              children: [
                const Gap(40),
                // Hero section with illustration/icon
                Semantics(
                  label: 'Học sinh đang học Toán với AI tutor',
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 100,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
                Gap(context.spacing.s32),
                // Title
                Text(
                  context.locale.onboarding_welcome_title,
                  textAlign: TextAlign.center,
                  style: context.textStyle.headingLarge.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.33, // 32px / 24px
                    color: const Color(0xFF212121),
                  ),
                ),
                Gap(context.spacing.s16),
                // Subtitle
                Text(
                  context.locale.onboarding_welcome_subtitle,
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodyLarge.copyWith(
                    fontSize: 16,
                    height: 1.5, // 24px / 16px
                    color: const Color(0xFF757575),
                  ),
                ),
                Gap(context.spacing.s24),
                // Trial badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.padding.p16,
                    vertical: context.padding.p8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFF9800),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '🎁',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Gap(8),
                      Text(
                        context.locale.onboarding_welcome_trial_badge,
                        style: context.textStyle.bodyMedium.copyWith(
                          fontSize: 14,
                          color: const Color(0xFFFF9800),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(context.spacing.s48),
                // Primary CTA: "Dùng thử ngay"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      context.go(Routes.trialStart);
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
                      context.locale.onboarding_welcome_button_try_now,
                      style: context.textStyle.bodyLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Gap(context.spacing.s16),
                // Secondary CTA: "Tìm hiểu thêm"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to info screen or skip
                      context.go(Routes.trialStart);
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
                      context.locale.onboarding_welcome_button_learn_more,
                      style: context.textStyle.bodyLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ),
                Gap(context.spacing.s32),
                // Footer link
                LinkText(
                  text: context.locale.onboarding_welcome_already_have_account,
                  linkText: context.locale.onboarding_welcome_login_link,
                  onTap: () {
                    context.go(Routes.authEntry);
                  },
                ),
                Gap(context.spacing.s32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

