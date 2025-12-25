import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/constants/error_codes.dart';
import '../../../../core/di/parts/repository.dart';
import '../../../../domain/repositories/parent_linking_repository.dart';

part 'otp_provider.g.dart';

@riverpod
class OtpVerification extends _$OtpVerification {
  DateTime? _lastResendTime;
  static const _resendCooldownSeconds = 60;

  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> sendOtp(String phoneNumber) async {
    if (state.isLoading) return;

    // Validate phone number format (Vietnamese: 10 digits, starts with 0)
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      state = AsyncValue.error(
        Exception('Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (10 số).'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(parentLinkingRepositoryProvider);
      
      // Add timeout (5 seconds)
      final response = await repository.requestOtp(phoneNumber).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException(
            'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.',
            const Duration(seconds: 5),
          );
        },
      );

      if (!response.isSuccess) {
        final errorCode = response.errorCode ?? ErrorCodes.internalError;
        String errorMessage = response.errorDetail ?? 'Không thể gửi mã OTP. Vui lòng thử lại.';
        
        // Handle specific error codes
        if (errorCode == ErrorCodes.rateLimitExceeded) {
          errorMessage = 'Bạn đã gửi quá nhiều yêu cầu. Tối đa 3 lần mỗi ngày. Vui lòng thử lại vào ngày mai.';
        } else if (errorCode == ErrorCodes.trialNotFound) {
          errorMessage = 'Không tìm thấy trial. Vui lòng bắt đầu trial trước.';
        } else if (errorCode == ErrorCodes.missingRequestParameter) {
          errorMessage = 'Thiếu thông tin cần thiết. Vui lòng thử lại.';
        }
        
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return;
      }

      // Update last resend time
      _lastResendTime = DateTime.now();
      state = const AsyncValue.data(true);
    } on TimeoutException catch (e, stackTrace) {
      state = AsyncValue.error(
        Exception(e.message ?? 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.'),
        stackTrace,
      );
    } on Failure catch (e, stackTrace) {
      String errorMessage = 'Không thể gửi mã OTP. Vui lòng thử lại.';
      if (e.type == FailureType.timeout) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      } else if (e.type == FailureType.network) {
        errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
    } catch (e, stackTrace) {
      String errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
      if (e.toString().contains('timeout') || e.toString().contains('Timeout')) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
    }
  }

  Future<Map<String, dynamic>?> verifyOtp(String phoneNumber, String otpCode) async {
    if (state.isLoading) return null;

    // Validate OTP code (6 digits)
    if (otpCode.length != 6 || !RegExp(r'^[0-9]{6}$').hasMatch(otpCode)) {
      state = AsyncValue.error(
        Exception('Mã OTP phải có 6 chữ số.'),
        StackTrace.current,
      );
      return null;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(parentLinkingRepositoryProvider);
      
      // Add timeout (10 seconds for verify)
      final response = await repository.verifyOtp(phoneNumber, otpCode).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
            'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.',
            const Duration(seconds: 10),
          );
        },
      );

      if (!response.isSuccess) {
        final errorCode = response.errorCode ?? ErrorCodes.internalError;
        String errorMessage = response.errorDetail ?? 'Mã OTP không đúng. Vui lòng thử lại.';
        
        // Handle specific error codes
        if (errorCode == ErrorCodes.otpInvalid || errorCode == ErrorCodes.otpVerificationError) {
          errorMessage = 'Mã OTP không đúng. Vui lòng thử lại.';
        } else if (errorCode == ErrorCodes.trialNotFound) {
          errorMessage = 'Không tìm thấy trial. Vui lòng bắt đầu trial trước.';
        } else if (errorCode == ErrorCodes.missingRequestParameter) {
          errorMessage = 'Thiếu thông tin cần thiết. Vui lòng thử lại.';
        }
        
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return null;
      }

      // Return verification result with parent credentials
      final verifyData = response.data;
      state = const AsyncValue.data(true);
      return verifyData;
    } on TimeoutException catch (e, stackTrace) {
      state = AsyncValue.error(
        Exception(e.message ?? 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.'),
        stackTrace,
      );
      return null;
    } on Failure catch (e, stackTrace) {
      String errorMessage = 'Mã OTP không đúng. Vui lòng thử lại.';
      if (e.type == FailureType.timeout) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      } else if (e.type == FailureType.network) {
        errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
      return null;
    } catch (e, stackTrace) {
      String errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
      if (e.toString().contains('timeout') || e.toString().contains('Timeout')) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
      return null;
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    // Check cooldown period (60 seconds)
    if (_lastResendTime != null) {
      final secondsSinceLastResend = DateTime.now().difference(_lastResendTime!).inSeconds;
      if (secondsSinceLastResend < _resendCooldownSeconds) {
        final remainingSeconds = _resendCooldownSeconds - secondsSinceLastResend;
        state = AsyncValue.error(
          Exception('Vui lòng đợi $remainingSeconds giây trước khi yêu cầu lại OTP.'),
          StackTrace.current,
        );
        return;
      }
    }

    // Reset state and send again
    await sendOtp(phoneNumber);
  }

  int? getResendCooldownRemaining() {
    if (_lastResendTime == null) return null;
    final secondsSinceLastResend = DateTime.now().difference(_lastResendTime!).inSeconds;
    if (secondsSinceLastResend < _resendCooldownSeconds) {
      return _resendCooldownSeconds - secondsSinceLastResend;
    }
    return null;
  }
}

