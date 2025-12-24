import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';

class TrialExpiryPage extends ConsumerStatefulWidget {
  const TrialExpiryPage({super.key});

  @override
  ConsumerState<TrialExpiryPage> createState() => _TrialExpiryPageState();
}

class _TrialExpiryPageState extends ConsumerState<TrialExpiryPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int _requestCountToday = 0; // Mock: Track request count

  // Mock achievement data
  final int _totalExercises = 45;
  final int _skillsImproved = 3;
  final int _streakDays = 7;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    // Mock: Check rate limiting (max 3 times/day)
    if (_requestCountToday >= 3) {
      setState(() {
        _errorMessage =
            '⚠️ Bạn đã gửi quá 3 lần hôm nay. Vui lòng thử lại vào ngày mai.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Mock: Send OTP (simulate API call)
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _requestCountToday++;
    });

    // Navigate to OTP verification
    await context.pushNamed(
      Routes.otpVerification,
      queryParameters: {'phone': _phoneController.text},
    );
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại phụ huynh';
    }

    // Vietnamese phone number format: 10 digits, starts with 0
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (10 số).';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6), // Warm yellow
      appBar: AppBar(
        title: const HeadingSmallText('Liên kết phụ huynh'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.padding.p24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(context.spacing.s32),
              // Illustration
              Center(
                child: Semantics(
                  label: 'Thông báo hết thời gian dùng thử',
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
                'Thời gian dùng thử đã kết thúc!',
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
                'Bạn đã hoàn thành 7 ngày dùng thử. Để tiếp tục học, bạn cần liên kết với tài khoản phụ huynh',
                textAlign: TextAlign.center,
                style: context.textStyle.bodyLarge.copyWith(
                  fontSize: 16,
                  height: 1.5, // 24px / 16px
                  color: const Color(0xFF757575),
                ),
              ),
              Gap(context.spacing.s32),
              // Achievement summary
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
                    Text(
                      'Bạn đã làm được:',
                      style: context.textStyle.bodyMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.43, // 20px / 14px
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Gap(context.spacing.s12),
                    Row(
                      children: [
                        Expanded(
                          child: _AchievementItem(
                            icon: '📚',
                            value: '$_totalExercises',
                            label: 'bài tập',
                          ),
                        ),
                        Expanded(
                          child: _AchievementItem(
                            icon: '🎯',
                            value: '$_skillsImproved',
                            label: 'skill cải thiện',
                          ),
                        ),
                        Expanded(
                          child: _AchievementItem(
                            icon: '🔥',
                            value: '$_streakDays',
                            label: 'ngày liên tiếp',
                          ),
                        ),
                      ],
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
                        'Dữ liệu học tập của bạn sẽ được giữ lại khi liên kết',
                        style: context.textStyle.bodyMedium.copyWith(
                          fontSize: 14,
                          height: 1.43, // 20px / 14px
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(context.spacing.s32),
              // Phone input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: 'Nhập số điện thoại phụ huynh',
                  hintText: '0912345678',
                  helperText: 'Ví dụ: 0912345678',
                  prefixIcon: const Icon(Icons.phone),
                  errorText: _errorMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.padding.p12,
                    vertical: context.padding.p14,
                  ),
                ),
                validator: _validatePhone,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
              ),
              Gap(context.spacing.s24),
              // Send OTP button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _isLoading ? null : _onSendOTP,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const LoadingIndicator()
                      : Text(
                          'Gửi mã OTP',
                          style: context.textStyle.bodyLarge.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              Gap(context.spacing.s16),
              // Footer note
              Center(
                child: Text(
                  'Mã OTP sẽ được gửi đến số điện thoại của phụ huynh',
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodySmall.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF757575),
                  ),
                ),
              ),
              Gap(context.spacing.s16),
              // Alternative option
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to link token flow (if implemented)
                  },
                  child: Text(
                    'Hoặc nhận mã liên kết',
                    style: context.textStyle.bodyMedium.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                ),
              ),
              Gap(context.spacing.s32),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  const _AchievementItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 32),
        ),
        Gap(context.spacing.s4),
        Text(
          value,
                          style: context.textStyle.headingMedium.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.4, // 28px / 20px
                            color: const Color(0xFF212121),
                          ),
        ),
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            fontSize: 12,
            color: const Color(0xFF757575),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

