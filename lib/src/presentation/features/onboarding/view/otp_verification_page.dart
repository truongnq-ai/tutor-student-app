import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/otp_provider.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String? _errorMessage;
  Timer? _timer;
  Timer? _cooldownTimer;
  int _remainingSeconds = 300; // 5 minutes

  String? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startCooldownTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get phone number from route parameters
    final uri = GoRouterState.of(context).uri;
    _phoneNumber = uri.queryParameters['phone'] ?? '0912345678';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cooldownTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Check cooldown from provider
          final cooldownRemaining = ref.read(otpVerificationProvider.notifier).getResendCooldownRemaining();
          if (cooldownRemaining == null) {
            timer.cancel();
          }
        });
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      // Move to next field
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to previous field
      _focusNodes[index - 1].requestFocus();
    }

    // Clear error when user types
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  String _getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  bool _isOtpComplete() {
    return _getOtpCode().length == 6;
  }

  Future<void> _onVerify() async {
    if (!_isOtpComplete() || _phoneNumber == null) return;

    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    final otpCode = _getOtpCode();

    // Verify OTP using provider
    final verifyResult = await ref.read(otpVerificationProvider.notifier).verifyOtp(_phoneNumber!, otpCode);

    // Listen to state changes
    ref.listenManual(otpVerificationProvider, (previous, next) {
      next.when(
        data: (success) {
          if (success == true && verifyResult != null && mounted) {
            // Navigate to linking success with data
            context.pushReplacementNamed(
              Routes.linkingSuccess,
              queryParameters: {
                'username': verifyResult['username'] ?? '',
                'password': verifyResult['password'] ?? '',
                'dashboardLink': verifyResult['dashboardLink'] ?? '',
              },
            );
          }
        },
        loading: () {},
        error: (error, stackTrace) {
          if (mounted) {
            String errorMessage = error.toString().replaceFirst('Exception: ', '');
            setState(() {
              _errorMessage = errorMessage;
              // Clear all fields on error
              for (var controller in _controllers) {
                controller.clear();
              }
              _focusNodes[0].requestFocus();
            });
          }
        },
      );
    });
  }

  Future<void> _onResendOtp() async {
    if (_phoneNumber == null) return;

    // Check cooldown
    final cooldownRemaining = ref.read(otpVerificationProvider.notifier).getResendCooldownRemaining();
    if (cooldownRemaining != null && cooldownRemaining > 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.locale.onboarding_otp_verification_error_cooldown(cooldownRemaining),
            ),
            backgroundColor: const Color(0xFFFF9800),
          ),
        );
      }
      return;
    }

    // Resend OTP using provider
    await ref.read(otpVerificationProvider.notifier).resendOtp(_phoneNumber!);

    // Listen to state changes
    ref.listenManual(otpVerificationProvider, (previous, next) {
      next.when(
        data: (success) {
          if (success == true && mounted) {
            // Reset timer
            setState(() {
              _remainingSeconds = 300;
            });
            _startTimer();
            _startCooldownTimer();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.locale.onboarding_otp_verification_success_resend),
                backgroundColor: const Color(0xFF4CAF50),
              ),
            );
          }
        },
        loading: () {},
        error: (error, stackTrace) {
          if (mounted) {
            String errorMessage = error.toString().replaceFirst('Exception: ', '');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      );
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpVerificationProvider);
    final isLoading = otpState.isLoading;
    final isExpired = _remainingSeconds == 0;
    final isWarning = _remainingSeconds < 60;
    final cooldownRemaining = ref.read(otpVerificationProvider.notifier).getResendCooldownRemaining();
    final canResend = cooldownRemaining == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText(context.locale.onboarding_otp_verification_title),
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
            // Description
            Text(
              context.locale.onboarding_otp_verification_description(_phoneNumber ?? ''),
              textAlign: TextAlign.center,
              style: context.textStyle.bodyLarge.copyWith(
                fontSize: 16,
                height: 1.5, // 24px / 16px
                color: const Color(0xFF757575),
              ),
            ),
            Gap(context.spacing.s32),
            // OTP input boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return Semantics(
                  label: context.locale.onboarding_otp_verification_input_label(index + 1),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _errorMessage != null
                                ? const Color(0xFFF44336)
                                : _focusNodes[index].hasFocus
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFE0E0E0),
                            width: _focusNodes[index].hasFocus ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF4CAF50),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFF44336),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: context.textStyle.headingMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                    ),
                  ),
                );
              }),
            ),
            if (_errorMessage != null) ...[
              Gap(context.spacing.s8),
              Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFF44336),
                    size: 16,
                  ),
                  Gap(context.spacing.s4),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: context.textStyle.bodySmall.copyWith(
                        fontSize: 12,
                        height: 1.33, // 16px / 12px
                        color: const Color(0xFFF44336),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            Gap(context.spacing.s24),
            // Timer
            Center(
              child: Semantics(
                label: context.locale.onboarding_otp_verification_timer_label(_formatTime(_remainingSeconds)),
                child: Text(
                  isExpired
                      ? context.locale.onboarding_otp_verification_timer_expired
                      : context.locale.onboarding_otp_verification_timer_remaining(_formatTime(_remainingSeconds)),
                  style: context.textStyle.bodyMedium.copyWith(
                    fontSize: 14,
                    height: 1.43, // 20px / 14px
                    color: isExpired
                        ? const Color(0xFFF44336)
                        : isWarning
                            ? const Color(0xFFFF9800)
                            : const Color(0xFF757575),
                    fontWeight: isWarning ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
            Gap(context.spacing.s32),
            // Verify button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isOtpComplete() && !isLoading ? _onVerify : null,
                style: FilledButton.styleFrom(
                  backgroundColor: _isOtpComplete()
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFBDBDBD),
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
                        context.locale.onboarding_otp_verification_button_confirm,
                        style: context.textStyle.bodyLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Gap(context.spacing.s16),
            // Resend link
            Center(
              child: TextButton(
                onPressed: canResend ? _onResendOtp : null,
                child: Text(
                  canResend
                      ? context.locale.onboarding_otp_verification_button_resend
                      : context.locale.onboarding_otp_verification_button_resend_cooldown(cooldownRemaining!),
                  style: context.textStyle.bodyMedium.copyWith(
                    fontSize: 14,
                    height: 1.43, // 20px / 14px
                    color: canResend
                        ? const Color(0xFF2196F3)
                        : const Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ),
            Gap(context.spacing.s32),
          ],
        ),
      ),
    );
  }
}

