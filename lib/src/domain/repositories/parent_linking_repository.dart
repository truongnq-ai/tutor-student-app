import '../../core/base/repository.dart';
import '../../core/base/response_object.dart';

abstract base class ParentLinkingRepository extends Repository {
  Future<ResponseObject<void>> requestOtp(String phoneNumber);
  Future<ResponseObject<Map<String, dynamic>>> verifyOtp(
    String phoneNumber,
    String otpCode,
  );
  Future<ResponseObject<void>> resendOtp(String phoneNumber);
}

