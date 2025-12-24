import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/riverpod_extensions.dart';
import '../../../../../core/extensions/validation.dart';
import '../../../../../core/utility/validation/validation.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/link_text.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../features/authentication/login/riverpod/login_provider.dart';
import '../../../../features/authentication/login/riverpod/oauth_provider.dart';
import '../../../../features/authentication/oauth/widgets/oauth_button.dart';
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
          context.pushReplacementNamed(Routes.home);
        case AsyncError(:final error, :final stackTrace):
          final errorMessage = error.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
      }
    });

    ref.listenManual(oauthLoginProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value != null:
          // Check if requiresSetCredential
          final requiresSetCredential = value['requiresSetCredential'] as bool? ?? false;
          
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
                  content: Text('Không tìm thấy thông tin học sinh'),
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
        case AsyncError(:final error, :final stackTrace):
          final errorMessage = error.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
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
                    : Text(context.locale.login),
              ),
              Gap(context.spacing.s16),
              // OAuth buttons
              _buildOAuthSection(),
              Gap(context.spacing.s16),
              LinkText(
                text: context.locale.dontHaveAccount,
                linkText: context.locale.signUp,
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
    final oauthState = ref.watch(oauthLoginProvider);
    final isLoading = oauthState.isLoading;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.padding.p8),
              child: Text(
                'Hoặc',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        Gap(context.spacing.s16),
        OAuthButton(
          provider: 'google',
          onPressed: isLoading
              ? () {}
              : () => ref.read(oauthLoginProvider.notifier).loginWithOAuth('google'),
          isLoading: isLoading,
        ),
        Gap(context.spacing.s8),
        OAuthButton(
          provider: 'apple',
          onPressed: isLoading
              ? () {}
              : () => ref.read(oauthLoginProvider.notifier).loginWithOAuth('apple'),
          isLoading: isLoading,
        ),
      ],
    );
  }
}
