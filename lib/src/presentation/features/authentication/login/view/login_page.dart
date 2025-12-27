import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/validation.dart';
import '../../../../../core/utility/validation/validation.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/link_text.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../features/authentication/login/riverpod/login_provider.dart';
import '../../../../features/authentication/login/riverpod/oauth_provider.dart';
import '../../../../features/authentication/oauth/widgets/oauth_button.dart';
import '../../../../features/onboarding/riverpod/trial_provider.dart';
import '../widgets/language_switcher.dart';

part '../widgets/login_form.dart';
part '../widgets/login_form_footer.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final shouldRemember = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    ref.listenManual(loginProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value != null:
          // After login, ensure trial exists before selecting grade
          _ensureTrialAndNavigate(context, ref);
        case AsyncError(:final error):
          final errorMessage = error.toString().replaceFirst('Exception: ', '');
          // Map error messages to user-friendly localized messages
          final friendlyMessage = _getUserFriendlyErrorMessage(
            context,
            errorMessage,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(friendlyMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 4),
            ),
          );
      }
    });

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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.locale.auth_oauth_error_student_not_found,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          } else {
            // OAuth login successful with tokens
            final tokens = value['tokens'] as Map<String, dynamic>?;
            if (tokens != null) {
              // Tokens are already saved by repository during oauthLogin
              // Navigate to home
              context.pushReplacementNamed(Routes.home);
            } else {
              // No tokens but no error, navigate anyway
              context.pushReplacementNamed(Routes.home);
            }
          }
        case AsyncError(:final error):
          // Don't show error for user cancellation (already handled in provider)
          // Error messages are already user-friendly from the provider
          final errorMessage = error
              .toString()
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
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(loginProvider.notifier)
          .login(
            username: usernameController.text,
            password: passwordController.text,
            shouldRemember: shouldRemember.value,
          );
    }
  }

  Future<void> _ensureTrialAndNavigate(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      // Check if trial exists
      final trialStatus = await ref
          .read(trialProvider.notifier)
          .getTrialStatus();

      if (trialStatus == null) {
        // Start trial first - this will create trial profile and save trialId
        await ref.read(trialProvider.notifier).startTrial();
      }

      // Then navigate to select grade
      if (context.mounted) {
        context.pushReplacementNamed(Routes.selectGrade);
      }
    } catch (e) {
      // If trial start fails, still navigate (user can retry)
      if (context.mounted) {
        context.pushReplacementNamed(Routes.selectGrade);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.padding.p16),
          child: Column(
            children: [
              Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: const LanguageSwitcherWidget(),
              ),
              Gap(context.spacing.s16),
              const FlutterLogo(size: 200),
              Gap(context.spacing.s80),
              Form(
                key: _formKey,
                child: _LoginForm(
                  usernameController: usernameController,
                  passwordController: passwordController,
                  shouldRemember: shouldRemember,
                ),
              ),
              Gap(context.spacing.s32),
              FilledButton(
                onPressed: state.isLoading ? null : _onLogin,
                child: state.isLoading
                    ? const LoadingIndicator()
                    : Text(context.locale.auth_login_button),
              ),
              Gap(context.spacing.s16),
              // OAuth buttons
              _buildOAuthSection(),
              Gap(context.spacing.s16),
              LinkText(
                text: context.locale.auth_account_dont_have,
                linkText: context.locale.auth_signup_button,
                onTap: () {
                  context.pushNamed(Routes.registration);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOAuthSection() {
    final loadingProvider = ref.watch(oAuthLoadingProviderProvider);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.padding.p8),
              child: Text(
                context.locale.auth_entry_divider_or,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        Gap(context.spacing.s16),
        OAuthButton(
          provider: 'google',
          onPressed: loadingProvider != null
              ? () {}
              : () => ref
                    .read(oAuthLoginProvider.notifier)
                    .loginWithOAuth('google'),
          isLoading: loadingProvider == 'google',
        ),
        Gap(context.spacing.s8),
        OAuthButton(
          provider: 'apple',
          onPressed: loadingProvider != null
              ? () {}
              : () => ref
                    .read(oAuthLoginProvider.notifier)
                    .loginWithOAuth('apple'),
          isLoading: loadingProvider == 'apple',
        ),
      ],
    );
  }

  /// Get user-friendly error message from error string
  String _getUserFriendlyErrorMessage(
    BuildContext context,
    String errorMessage,
  ) {
    final lowerError = errorMessage.toLowerCase();

    // Check for authentication errors (401, unauthorized, invalid credentials)
    if (lowerError.contains('401') ||
        lowerError.contains('unauthorized') ||
        lowerError.contains('invalid username') ||
        lowerError.contains('invalid password') ||
        lowerError.contains('incorrect') ||
        lowerError.contains('username') && lowerError.contains('password')) {
      return context.locale.auth_login_error_invalid_credentials;
    }

    // Check for network errors
    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout') ||
        lowerError.contains('socket')) {
      return context.locale.error_network_connection;
    }

    // Check for system errors
    if (lowerError.contains('500') ||
        lowerError.contains('internal') ||
        lowerError.contains('server error')) {
      return context.locale.error_system_internal;
    }

    // Check for session expired (different from invalid credentials)
    if (lowerError.contains('session') && lowerError.contains('expired')) {
      return context.locale.error_auth_unauthorized;
    }

    // Return original message if no mapping found, but limit length
    if (errorMessage.length > 150) {
      return '${errorMessage.substring(0, 150)}...';
    }

    return errorMessage;
  }
}
