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
import '../../../../../domain/entities/student_check_entity.dart';
import '../../../../features/onboarding/riverpod/trial_provider.dart';
import '../../../../features/onboarding/widgets/trial_status_dialog.dart';
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
      if (!mounted) return;
      switch (next) {
        case AsyncData(:final value) when value != null:
          // After login, ensure trial exists before selecting grade
          _ensureTrialAndNavigate(context, ref);
        case AsyncError(:final error):
          if (!mounted) return;
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
      if (!mounted) return;
      switch (next) {
        case AsyncData(:final value) when value != null:
          // Check if requiresSetCredential
          final requiresSetCredential =
              value['requiresSetCredential'] as bool? ?? false;

          if (requiresSetCredential) {
            // Navigate to set credential page
            final studentId = value['studentId'] as String? ?? '';
            if (studentId.isNotEmpty) {
              if (mounted) {
                context.pushNamed(
                  Routes.setCredential,
                  queryParameters: {'studentId': studentId},
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.locale.auth_oauth_error_student_not_found,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            }
          } else {
            // OAuth login successful with tokens
            final tokens = value['tokens'] as Map<String, dynamic>?;
            if (tokens != null) {
              // Tokens are already saved by repository during oauthLogin
              // Check student status and navigate accordingly
              _ensureTrialAndNavigate(context, ref);
            } else {
              // No tokens but no error, check status anyway
              _ensureTrialAndNavigate(context, ref);
            }
          }
        case AsyncError(:final error):
          if (!mounted) return;
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
      // Check student status (trial and licence)
      final checkStatus = await ref
          .read(trialProvider.notifier)
          .checkStudentStatus();

      if (checkStatus == null) {
        // Error occurred, navigate to home as fallback
        if (context.mounted) {
          context.pushReplacementNamed(Routes.home);
        }
        return;
      }

      // Handle 6 statuses
      await _handleStudentStatus(context, ref, checkStatus);
    } catch (e) {
      // If check fails, navigate to home as fallback
      if (context.mounted) {
        context.pushReplacementNamed(Routes.home);
      }
    }
  }

  Future<void> _handleStudentStatus(
    BuildContext context,
    WidgetRef ref,
    StudentCheckEntity checkStatus,
  ) async {
    final status = checkStatus.status;

    switch (status) {
      case 'NO_TRIAL':
        // Navigate to select grade + learning goals (merged screen)
        if (context.mounted) {
          context.pushReplacementNamed(Routes.selectGradeAndGoals);
        }
        break;

      case 'TRIAL_ACTIVE_DEVICE_CONSUMED':
        // Show dialog with message and OK button -> navigate to login
        if (context.mounted) {
          await TrialStatusDialog.show(
            context,
            message:
                checkStatus.message ??
                'Thiết bị này đã sử dụng hết lượt dùng thử.',
            onOk: () {
              if (context.mounted) {
                context.pushReplacementNamed(Routes.authEntry);
              }
            },
          );
        }
        break;

      case 'TRIAL_ACTIVE':
        // Navigate to learning page + show reminder snackbar
        if (context.mounted) {
          context.pushReplacementNamed(Routes.home);
          // Show reminder notification after navigation
          final daysRemaining = checkStatus.daysRemaining ?? 0;
          final expiresAt = checkStatus.expiresAt;
          if (expiresAt != null && context.mounted) {
            final expiresAtStr =
                '${expiresAt.day}/${expiresAt.month}/${expiresAt.year} ${expiresAt.hour}:${expiresAt.minute.toString().padLeft(2, '0')}';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Số ngày dùng thử còn lại $daysRemaining ngày. Thời điểm kết thúc $expiresAtStr.',
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
        break;

      case 'LICENCE_ACTIVE':
        // Navigate to learning page + snackbar if < 7 days
        if (context.mounted) {
          context.pushReplacementNamed(Routes.home);
          final daysRemaining = checkStatus.daysRemaining ?? 0;
          if (daysRemaining < 7 && context.mounted) {
            final expiresAt = checkStatus.expiresAt;
            if (expiresAt != null) {
              final expiresAtStr =
                  '${expiresAt.day}/${expiresAt.month}/${expiresAt.year} ${expiresAt.hour}:${expiresAt.minute.toString().padLeft(2, '0')}';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tài khoản của bạn sắp hết hiệu lực ($daysRemaining ngày). Thời điểm kết thúc $expiresAtStr.',
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          }
        }
        break;

      case 'LICENCE_EXPIRED':
      case 'TRIAL_EXPIRED_NO_LICENCE':
        // Show dialog with message and OK button -> navigate to login
        if (context.mounted) {
          await TrialStatusDialog.show(
            context,
            message:
                checkStatus.message ?? 'Tài khoản của bạn đã hết hiệu lực.',
            onOk: () {
              if (context.mounted) {
                context.pushReplacementNamed(Routes.authEntry);
              }
            },
          );
        }
        break;

      default:
        // Unknown status, navigate to home
        if (context.mounted) {
          context.pushReplacementNamed(Routes.home);
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
