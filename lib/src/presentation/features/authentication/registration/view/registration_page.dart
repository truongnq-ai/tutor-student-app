import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/go_router_extension.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/link_text.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/text/typography.dart';
import '../riverpod/registration_provider.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual(registrationProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value != null:
          // Registration successful, navigate to Trial Start
          context.pushReplacementNamed(Routes.trialStart);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.locale.auth_registration_success_message),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        case AsyncError(:final error):
          // Extract user-friendly error message
          String errorMessage = context.locale.error_generic;
          
          if (error is Exception) {
            final errorString = error.toString();
            // Remove "Exception: " prefix if present
            if (errorString.startsWith('Exception: ')) {
              errorMessage = errorString.substring(11);
            } else {
              errorMessage = errorString;
            }
          } else {
            errorMessage = error.toString();
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 4),
            ),
          );
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      ref.read(registrationProvider.notifier).register(
            name: nameController.text.trim(),
            username: usernameController.text.trim(),
            password: passwordController.text,
            confirmPassword: confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);

    return Scaffold(
      appBar: AppBar(title: HeadingSmallText(context.locale.auth_signup_title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.padding.p16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(context.spacing.s80),
              FlutterLogo(size: context.spacing.s100),
              Gap(context.spacing.s80),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: context.locale.auth_registration_field_full_name,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.locale.auth_registration_validation_full_name_required;
                  }
                  return null;
                },
              ),
              Gap(context.spacing.s16),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: context.locale.auth_registration_field_username,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.locale.auth_registration_validation_username_required;
                  }
                  if (!RegExp(r'^[a-zA-Z0-9]+$', caseSensitive: false).hasMatch(value)) {
                    return context.locale.auth_registration_validation_username_format;
                  }
                  return null;
                },
              ),
              Gap(context.spacing.s16),
              TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: context.locale.common_field_password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.locale.validation_password_required;
                  }
                  if (value.length < 8) {
                    return context.locale.validation_password_min_length('8');
                  }
                  return null;
                },
              ),
              Gap(context.spacing.s16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: context.locale.auth_registration_field_confirm_password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.locale.auth_registration_validation_confirm_password_required;
                  }
                  if (value != passwordController.text) {
                    return context.locale.auth_registration_validation_password_mismatch;
                  }
                  return null;
                },
              ),
              Gap(context.spacing.s32),
              FilledButton(
                onPressed: state.isLoading ? null : _onRegister,
                child: state.isLoading
                    ? const LoadingIndicator()
                    : Text(context.locale.common_button_continue),
              ),
              LinkText(
                text: context.locale.auth_account_already_have,
                linkText: context.locale.auth_signin_button,
                onTap: () {
                  context.pushNamedAndRemoveUntil(Routes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
