import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'otp_provider.g.dart';

@riverpod
class OtpVerification extends _$OtpVerification {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> sendOtp(String phoneNumber) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      // Mock: Send OTP via Firebase Auth
      // In real implementation, this would call Firebase Auth to send OTP
      await Future.delayed(const Duration(seconds: 1));

      // Mock: Validate phone number format
      final phoneRegex = RegExp(r'^0[0-9]{9}$');
      if (!phoneRegex.hasMatch(phoneNumber)) {
        throw Exception('Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (10 số).');
      }

      // Mock: Check rate limiting (max 3 times/day)
      // In real implementation, this would check with backend
      // For now, always succeed

      state = const AsyncValue.data(true);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otpCode) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      // Mock: Verify OTP via Firebase Auth
      // In real implementation, this would call Firebase Auth to verify OTP
      await Future.delayed(const Duration(seconds: 1));

      // Mock: Accept OTP "123456" as valid
      final isValid = otpCode == '123456';

      if (isValid) {
        state = const AsyncValue.data(true);
        return true;
      } else {
        state = AsyncValue.error(
          Exception('Mã OTP không đúng. Vui lòng thử lại.'),
          StackTrace.current,
        );
        return false;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    // Reset state and send again
    await sendOtp(phoneNumber);
  }
}

