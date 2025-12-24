import '../../core/base/response_object.dart';
import '../repositories/parent_linking_repository.dart';

final class RequestOtpUseCase {
  RequestOtpUseCase(this.repository);

  final ParentLinkingRepository repository;

  Future<ResponseObject<void>> call(String phoneNumber) async {
    // Validate phone number format
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      throw Exception(
        'Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (10 số).',
      );
    }
    return repository.requestOtp(phoneNumber);
  }
}

final class VerifyOtpUseCase {
  VerifyOtpUseCase(this.repository);

  final ParentLinkingRepository repository;

  Future<ResponseObject<Map<String, dynamic>>> call(
    String phoneNumber,
    String otpCode,
  ) async {
    return repository.verifyOtp(phoneNumber, otpCode);
  }
}

final class ResendOtpUseCase {
  ResendOtpUseCase(this.repository);

  final ParentLinkingRepository repository;

  Future<ResponseObject<void>> call(String phoneNumber) async {
    return repository.resendOtp(phoneNumber);
  }
}

