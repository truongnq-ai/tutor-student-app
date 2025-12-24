import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/text/typography.dart';

class SetCredentialPage extends ConsumerStatefulWidget {
  const SetCredentialPage({
    super.key,
    required this.studentId,
  });

  final String studentId;

  @override
  ConsumerState<SetCredentialPage> createState() => _SetCredentialPageState();
}

class _SetCredentialPageState extends ConsumerState<SetCredentialPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await ref.read(setCredentialUseCaseProvider).call(
              studentId: widget.studentId,
              username: usernameController.text.trim(),
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
            );

        if (response.isSuccess && response.data != null) {
          // Credential set successfully, navigate to Trial Start (if no trial) or Select Grade
          if (mounted) {
            setState(() => _isLoading = false);
            // Mock: Check if has trial, if not go to Trial Start
            // In real implementation, check trial status from API
            context.pushReplacementNamed(Routes.trialStart);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đặt thông tin đăng nhập thành công.'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        } else {
          // Show error
          if (mounted) {
            setState(() => _isLoading = false);
            final errorMessage = response.getErrorMessage();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Có lỗi xảy ra: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const HeadingSmallText('Đặt thông tin đăng nhập')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.padding.p16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(context.spacing.s80),
              FlutterLogo(size: context.spacing.s100),
              Gap(context.spacing.s32),
              Text(
                'Vui lòng đặt tên đăng nhập và mật khẩu để hoàn tất đăng ký',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Gap(context.spacing.s32),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(hintText: 'Tên đăng nhập'),
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
                onPressed: _isLoading ? null : _onSubmit,
                child: _isLoading
                    ? const LoadingIndicator()
                    : Text(context.locale.continueAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

