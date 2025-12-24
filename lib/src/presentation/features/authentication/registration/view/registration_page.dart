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
              content: Text('Đăng ký thành công. Bắt đầu dùng thử miễn phí!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        case AsyncError(:final error):
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
      appBar: AppBar(title: HeadingSmallText(context.locale.signUp)),
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
                decoration: InputDecoration(hintText: 'Họ và tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              Gap(context.spacing.s16),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(hintText: 'Tên đăng nhập'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9]+$', caseSensitive: false).hasMatch(value)) {
                    return 'Tên đăng nhập chỉ được dùng chữ và số, không phân biệt hoa/thường';
                  }
                  return null;
                },
              ),
              Gap(context.spacing.s16),
              TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: context.locale.password,
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
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 8) {
                    return 'Mật khẩu phải có ít nhất 8 ký tự';
                  }
                  return null;
                },
              ),
              Gap(context.spacing.s16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Xác nhận mật khẩu',
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
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  if (value != passwordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              Gap(context.spacing.s32),
              FilledButton(
                onPressed: state.isLoading ? null : _onRegister,
                child: state.isLoading
                    ? const LoadingIndicator()
                    : Text(context.locale.continueAction),
              ),
              LinkText(
                text: context.locale.alreadyHaveAccount,
                linkText: context.locale.signIn,
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
