import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/link_text.dart';
import '../../../core/widgets/text/typography.dart';
import '../oauth/widgets/oauth_button.dart';
import '../login/riverpod/oauth_provider.dart';

class AuthEntryPage extends ConsumerWidget {
  const AuthEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingProvider = ref.watch(oAuthLoadingProviderProvider);

    // Listen to OAuth login result
    ref.listenManual(oAuthLoginProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value != null:
          // Check if requiresSetCredential
          final requiresSetCredential =
              value['requiresSetCredential'] as bool? ?? false;

          if (requiresSetCredential) {
            // Navigate to set credential page
            final studentId = value['studentId'] as String? ?? '';
            if (studentId.isNotEmpty) {
              context.pushNamed(
                Routes.setCredential,
                queryParameters: {'studentId': studentId},
              );
            }
          } else {
            // Check if has trial, if not go to Trial Start
            // Mock: Assume no trial, go to Trial Start
            context.go(Routes.trialStart);
          }
        case AsyncError(:final error):
          // Don't show error for user cancellation (already handled in provider)
          // Error messages are already user-friendly from the provider
          final errorMessage = error.toString()
              .replaceFirst('Exception: ', '')
              .replaceFirst('Error: ', '');
          
          // Only show error if it's not a cancellation
          if (errorMessage.isNotEmpty && 
              !errorMessage.toLowerCase().contains('cancelled') &&
              !errorMessage.toLowerCase().contains('canceled')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 4),
              ),
            );
          }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText(context.locale.auth_entry_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.padding.p24),
          child: Column(
            children: [
              Gap(context.spacing.s80),
              // Logo
              const FlutterLogo(size: 100),
              Gap(context.spacing.s48),
              // Header
              Text(
                context.locale.auth_entry_title,
                textAlign: TextAlign.center,
                style: context.textStyle.headingLarge.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.33, // 32px / 24px
                  color: const Color(0xFF212121),
                ),
              ),
              Gap(context.spacing.s48),
              // OAuth buttons
              OAuthButton(
                provider: 'google',
                onPressed: loadingProvider != null
                    ? () {}
                    : () => ref.read(oAuthLoginProvider.notifier).loginWithOAuth('google'),
                isLoading: loadingProvider == 'google',
              ),
              Gap(context.spacing.s12),
              OAuthButton(
                provider: 'apple',
                onPressed: loadingProvider != null
                    ? () {}
                    : () => ref.read(oAuthLoginProvider.notifier).loginWithOAuth('apple'),
                isLoading: loadingProvider == 'apple',
              ),
              Gap(context.spacing.s24),
              // Divider
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.padding.p8),
                    child: Text(
                      context.locale.auth_entry_divider_or,
                      style: context.textStyle.bodySmall.copyWith(
                        fontSize: 14,
                        height: 1.43, // 20px / 14px
                        color: const Color(0xFF757575),
                      ),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              Gap(context.spacing.s24),
              // Manual button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: loadingProvider != null
                      ? null
                      : () {
                          context.pushNamed(Routes.registration);
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
                    context.locale.auth_entry_manual_button,
                    style: context.textStyle.bodyLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ),
              Gap(context.spacing.s32),
              // Footer
              LinkText(
                text: context.locale.auth_entry_no_account,
                linkText: context.locale.auth_entry_manual_signup,
                onTap: () {
                  context.pushNamed(Routes.registration);
                },
              ),
              Gap(context.spacing.s32),
            ],
          ),
        ),
      ),
    );
  }
}

